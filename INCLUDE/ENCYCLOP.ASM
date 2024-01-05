; Module qui affiche un texte, avec une apparition par
; d‚fillement (scrolling) vertical.
;
affiche_encyclopedie proc near
  pusha

  call vsync
  mov si,offset palette_noire	; Met la palette en noir pour cacher
  call envoie_palette		; les horreurs.

  mov bx,0
  call valide_adresse_ecran	; Fait pointer l'‚cran sur l'adresse 0

  call efface_ecran		; ...clair ?

  mov si,offset liste_textes	; Liste de pointeurs sur les textes
  mov ax,numero_texte		; Num‚ro du texte x2
  add ax,ax
  add si,ax                     ; Donne l'adresse du d‚but du texte
  mov bx,[si]                   ; Charge l'offset du texte
  call affiche_texte		; Affiche le texte … l'‚cran

  call vsync
  mov si,offset palette_image	; Valide la bonne palette (la mˆme que
  call envoie_palette		; celle de l'image Saturne)

  mov cx,200			; Il faut 200 it‚rations pour faire
  mov bx,0			; apparaitre le texte de bas an haut.
boucle_scrolling_haut:
  call vsync
  call valide_adresse_ecran
  add bx,160			; ®Descend¯ l'‚cran de 2 lignes...
  loop boucle_scrolling_haut
  push bx

  call vide_buffer_clavier	; Au cas ou il y aurait un caractŠre en attente

  mov ah,0	              	; Attente de touche BIOS
  int 16h

  mov cx,200			; Idem, mais pour faire disparaitre le texte.
  pop bx
boucle_scrolling_bas:
  call vsync
  call valide_adresse_ecran
  sub bx,160
  loop boucle_scrolling_bas

  call vsync
  mov si,offset palette_noire	; On fait les op‚rations de nettoyage pour
  call envoie_palette		; relancer l'animation des planetes

  call efface_ecran

  call vide_buffer_clavier

  call vsync

  popa
  ret
  endp




;
; BX pointe sur l'offset du message
;
affiche_texte proc near
  pusha
  push ds
  push es
  push fs

  push ds                      ; FS pointe sur le DataSegment
  pop fs

  push seg fonte               ; DS pointe sur la fonte
  pop ds

  mov eax,adresse_ecran+2000	; ES pointe sur l'‚cran (moiti‚e
  mov es,ax			; inf‚rieure)

  mov di,0
  mov si,offset fonte	

  mov code_souligne,0		; D‚valide le soulignement
  mov dx,3c4h			; Pour les validations de plan

; en entr‚e : bx pointe sur le texte … afficher
;             si pointe sur la fonte
;             di pointe sur l'‚cran
;
boucle_aff_texte:
  push di                 ;sauvegarde du d‚but de la ligne

car_suiv:
  mov al,[fs:bx] 	; R‚cupŠre le code ASCII du caractŠre
  cmp al,0
  je fin_ligne            ;si 0, on est en fin de ligne
  cmp al,1		  ;si 1, on inverse le mode soulignement
  jne aff_car
  not code_souligne       ; Le code de soulignement n'a pas
  inc bx                  ; … ˆtre affich‚, alors on le saute
  jmp car_suiv

aff_car:
  mov ah,0		  ; On multiplie par 64, car la police contient
  shl ax,6		  ; toutes les caractŠres en 8x8 pixels...
  push si                 ;sauvegarde le pointeur sur le d‚but de la fonte
  add si,ax               ;on pointe sur le caractŠre dans la fonte
  mov ecx,8                ;caractŠre sur 8 lignes

boucle_car:
  mov ax,0102h            ; S‚lectionne le plan 0
  out dx,ax

  mov al,[ds:si]
  mov ah,[ds:si+4]
  mov [es:di],ax	  ; ‚crit les pixels 0 et 4

  mov ax,0202h            ; S‚lectionne le plan 1
  out dx,ax

  mov al,[ds:si+1]
  mov ah,[ds:si+5]
  mov [es:di],ax	  ; ‚crit les pixels 1 et 5

  mov ax,0402h            ; S‚lectionne le plan 2
  out dx,ax

  mov al,[ds:si+2]
  mov ah,[ds:si+6]
  mov [es:di],ax	  ; ‚crit les pixels 2 et 6

  mov ax,0802h            ; S‚lectionne le plan 3
  out dx,ax

  mov al,[ds:si+3]
  mov ah,[ds:si+7]
  mov [es:di],ax	  ; ‚crit les pixels 3 et 7

  add si,8		  ; rang‚e suivante sur la lettre
  add di,80                ;passe … la ligne suivante
  loop boucle_car

  cmp code_souligne,0
  je souligne_pas_caractere

  mov ax,0f02h
  out dx,ax                ; S‚lectionne les 4 plans de bit simultan‚ment

  mov word ptr [es:di+80],0505h	; Affecte 8 pixels simultan‚ment avec la
  				; couleur 5 (rouge sombre)

souligne_pas_caractere:

  sub di,80*8-2             ;on revient au d‚but du caractŠre
  inc bx                     ;on passe au caractŠre suivant
  pop si
  jmp car_suiv

fin_ligne:
  inc bx
  pop di
  add di,80*10               ;on passe … la position du caractŠre suivant
                             ;sur l'‚cran
  mov al,[fs:bx]
  cmp al,0
  jne boucle_aff_texte

  pop fs
  pop es
  pop ds
  popa
  ret

endp





