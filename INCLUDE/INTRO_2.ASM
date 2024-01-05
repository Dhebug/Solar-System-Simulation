; Affichage d'une image 320x200 en 256 couleurs.
; L'image utilsie un compactage RLE sp‚cifique.
;
;
intro_planette proc near
  pusha

  call vsync
  mov si,offset palette_noire     ; Met la palette en noir avant d'afficher
  call envoie_palette

  call affiche_image      ; Affiche l'image SATURN.BIN

  mov si,offset palette_noire
  mov di,offset palette_image
  mov byte ptr[di+13*3],0	; Force la couleur 13 en noir.
  mov byte ptr[di+13*3+1],0
  mov byte ptr[di+13*3+2],0
  call execute_fondu     ; effectue le fondu d'arriv‚e

  mov cx,70*3		 ; Une attente de 3 secondes
  call temporise

  mov si,offset palette_image
  mov di,offset palette_noire
  call execute_fondu    ; effectue le fondu de d‚part

  call efface_ecran

  call vide_buffer_clavier
  popa
  ret
endp

;
; Affiche l'image avec Saturne.
; L'image est compact‚e:
; [ds:si] pointe sur l'image
; [es:di] pointe sur l'‚cran
;
affiche_image proc near
  pusha
  push ds
  push es
  push seg debut_image    ; Fait pointer DS sur le segment contenant
  pop ds                  ; l'image … afficher.
  mov ax,adresse_ecran         ; Fait pointer ES sur la m‚moire ‚cran
  mov es,ax
  mov si,offset debut_image
  mov di,0

depacke_image:
  lodsw
  cmp ax,0	 	  ; Si code=0, on a termin‚ le d‚compactage
  je fin_depacke_image
  js code_repete	  ; Si n‚gatif, on r‚pŠte le caractŠre '13' (noir)
code_copie:		  ; Si positif, on recopie les octets de l'image
  mov ecx,eax             ; Nombre d'octets … recopier
  rep movsb
  jmp depacke_image

code_repete:
  mov ecx,eax             ; 'ax' contient le code n‚gatif
  neg ecx                 ; Nombre de r‚p‚tition du code
  mov al,13               ; Il faut ‚crire 'cx' fois '13'
  rep stosb
  jmp depacke_image

fin_depacke_image:

  pop es
  pop ds
  popa
  ret
endp
