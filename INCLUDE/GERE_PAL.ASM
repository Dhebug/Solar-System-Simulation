;
; Transmet une palette qui est en DS:SI et qui contient 256 triplets RVB
; (768 octets � envoyer)
; entr�e: DS:SI=palette � envoyer
; dac_write_address_reg -->  3C8h (Registre de s�lection)
; dac_data_reg          -->  3c9h (Registre de donn�es)
;
envoie_palette proc near
  pusha
  mov dx,3c8h         ; S�lection de num�ro de couleur
  sub al,al           ; Couleur d'index 0 (Premi�re couleur)
  out dx,al
  inc dx              ; Passe sur le registre d'�criture des composantes RVB
  mov cx,768
  rep outsb           ; �gal � CX*[out DX,DS:SI++]
  popa
  ret
endp




;
; Routine qui effectue une fondu en 64 phases entre deux palettes pass�es
; en param�tre.
; Appel:
; SI=Palette source
; DI=Palette destination
;
execute_fondu proc near
  push es
  push ds
  pusha

  call prepare_fondu		; Calcule les incr�ments pour le fondus

  mov phase_fondu,0

phase_suivante:
  call fondu_suivant		; Calcule la prochaine palette
  call vsync			; synchro verticale
  mov si,offset palette_source
  call envoie_palette		; effectue le changement de palette
  cmp fondu_termine,0
  jne phase_suivante		; jusqu'� la fin du fondu

  popa
  pop ds
  pop es
  ret
endp


; Cette routine re�oit l'adresse de la palette source en DS:SI et de la
; palette destination en DS:DI. Elle transfert ces 2 palettes dans les
; buffers internes �palette_source� et �palette_destination�, puis calcule
; en virgule fixe 32 bits les incr�ments/d�cr�ments n�c�ssaires pour
; passer de la premi�re palette � la seconde en 64 phases. Ces valeurs
; sont stock�es dans �table_increments� et �table_intermediaire�.

prepare_fondu proc near
  push es
  pusha

  push ds                ; Fait pointer ES=DS
  pop es
;
; Copie dans les tableaux �palette_source� et �palette_destination� les
; deux palettes qui servent � effectuer le fondu
;
  push di                ; Sauve l'adresse de la seconde palette
  mov di,offset palette_source
  mov cx,192             ; 192x4=768 octets transf�r�s
  rep movsd              ; Copie la palette source
  pop si
  mov cx,192
  rep movsd              ; Copie la palette destination

;
; Calcul les incr�ments qui serviront � effectuer le fondu
; (NB: movzx charge une valeur en �tendant le signe en fonction
; de la taille du registre destination)
;
  mov ebx,63              ; Diviseur 32 bits
  mov si,offset palette_source
  mov di,offset table_increments
  mov cx,768              ;compteur
corps:
  movzx edx,byte ptr[si]        ;palette source
  shl edx,16
  mov [di+3072],edx     ;on memorise la couleur dans �tableau_intermediaire�
  movzx eax,byte ptr[si+768]    ;palette destination
  shl eax,16
  sub eax,edx
  mov edx,0             ; pour la division
  cmp eax,0             ; Si l'offset est n�gatif, il faut que la partie
  jge ok_positif        ; haute (edx) de la division soit mise � -1
  mov edx,-1
ok_positif:
  idiv ebx

  stosd               ; M�morise l'incr�ment (eax) dans table_increment
  inc si
  loop corps

  popa
  pop es
  ret
endp



; Cette routine utilise �table_increments� et �table_intermediaire� pour
; calculer la prochaine couleur � afficher. �table_intermediaire� est alors
; mise � jour, et le r�sultat est stock� dans �palette_source� qui peut
; d�s lors �tre envoy� au DAC.

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
  mov cx,768         ;compteur des �tapes dans une phase (768)
corps_pal:
  lodsd			  ; Charge l'incr�ment
  add eax,[si+3072-4]	  ; on ajoute la valeur courante=> nouvelle valeur
  mov [si+3072-4],eax     ; Devient nouvelle valeur courante
  shr eax,16		  ; R�cup�re la partie enti�re sur 16 bits
  stosb		          ;on envoit la partie basse de ax dans la palette
  loop corps_pal
fin_fondu:

  popa
  pop es
  ret
endp
