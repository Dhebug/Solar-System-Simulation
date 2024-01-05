;
; Transmet une palette qui est en DS:SI et qui contient 256 triplets RVB
; (768 octets Ö envoyer)
; entrÇe: DS:SI=palette Ö envoyer
; dac_write_address_reg -->  3C8h (Registre de sÇlection)
; dac_data_reg          -->  3c9h (Registre de donnÇes)
;
envoie_palette proc near
  pusha
  mov dx,3c8h         ; SÇlection de numÇro de couleur
  sub al,al           ; Couleur d'index 0 (Premiäre couleur)
  out dx,al
  inc dx              ; Passe sur le registre d'Çcriture des composantes RVB
  mov cx,768
  rep outsb           ; Çgal Ö CX*[out DX,DS:SI++]
  popa
  ret
endp




;
; Routine qui effectue une fondu en 64 phases entre deux palettes passÇes
; en paramätre.
; Appel:
; SI=Palette source
; DI=Palette destination
;
execute_fondu proc near
  push es
  push ds
  pusha

  call prepare_fondu		; Calcule les incrÇments pour le fondus

  mov phase_fondu,0

phase_suivante:
  call fondu_suivant		; Calcule la prochaine palette
  call vsync			; synchro verticale
  mov si,offset palette_source
  call envoie_palette		; effectue le changement de palette
  cmp fondu_termine,0
  jne phase_suivante		; jusqu'Ö la fin du fondu

  popa
  pop ds
  pop es
  ret
endp


; Cette routine reáoit l'adresse de la palette source en DS:SI et de la
; palette destination en DS:DI. Elle transfert ces 2 palettes dans les
; buffers internes Æpalette_sourceØ et Æpalette_destinationØ, puis calcule
; en virgule fixe 32 bits les incrÇments/dÇcrÇments nÇcÇssaires pour
; passer de la premiäre palette Ö la seconde en 64 phases. Ces valeurs
; sont stockÇes dans Ætable_incrementsØ et Ætable_intermediaireØ.

prepare_fondu proc near
  push es
  pusha

  push ds                ; Fait pointer ES=DS
  pop es
;
; Copie dans les tableaux Æpalette_sourceØ et Æpalette_destinationØ les
; deux palettes qui servent Ö effectuer le fondu
;
  push di                ; Sauve l'adresse de la seconde palette
  mov di,offset palette_source
  mov cx,192             ; 192x4=768 octets transfÇrÇs
  rep movsd              ; Copie la palette source
  pop si
  mov cx,192
  rep movsd              ; Copie la palette destination

;
; Calcul les incrÇments qui serviront Ö effectuer le fondu
; (NB: movzx charge une valeur en Çtendant le signe en fonction
; de la taille du registre destination)
;
  mov ebx,63              ; Diviseur 32 bits
  mov si,offset palette_source
  mov di,offset table_increments
  mov cx,768              ;compteur
corps:
  movzx edx,byte ptr[si]        ;palette source
  shl edx,16
  mov [di+3072],edx     ;on memorise la couleur dans Ætableau_intermediaireØ
  movzx eax,byte ptr[si+768]    ;palette destination
  shl eax,16
  sub eax,edx
  mov edx,0             ; pour la division
  cmp eax,0             ; Si l'offset est nÇgatif, il faut que la partie
  jge ok_positif        ; haute (edx) de la division soit mise Ö -1
  mov edx,-1
ok_positif:
  idiv ebx

  stosd               ; MÇmorise l'incrÇment (eax) dans table_increment
  inc si
  loop corps

  popa
  pop es
  ret
endp



; Cette routine utilise Ætable_incrementsØ et Ætable_intermediaireØ pour
; calculer la prochaine couleur Ö afficher. Ætable_intermediaireØ est alors
; mise Ö jour, et le rÇsultat est stockÇ dans Æpalette_sourceØ qui peut
; däs lors àtre envoyÇ au DAC.

fondu_suivant proc near
  push es
  pusha

  mov fondu_termine,0

  cmp phase_fondu,63
  je fin_fondu
  mov fondu_termine,1
  inc phase_fondu

  push ds
  pop es

  mov si,offset table_increments
  mov di,offset palette_source
  mov cx,768         ;compteur des Çtapes dans une phase (768)
corps_pal:
  lodsd			  ; Charge l'incrÇment
  add eax,[si+3072-4]	  ; on ajoute la valeur courante=> nouvelle valeur
  mov [si+3072-4],eax     ; Devient nouvelle valeur courante
  shr eax,16		  ; RÇcupäre la partie entiäre sur 16 bits
  stosb		          ;on envoit la partie basse de ax dans la palette
  loop corps_pal
fin_fondu:

  popa
  pop es
  ret
endp
