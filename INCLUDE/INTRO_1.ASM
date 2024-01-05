;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%
;%%   G‚n‚rique pour le projet d'ASI
;%%
;%%   -> Apparition des ®images symboles¯ des divers disciplines
;%%      enseign‚e … la fac de Besan‡on.
;%%   -> Utilisation d'une routine de d‚compactage simple
;%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


intro_symboles proc near
  push es
  push ds
  pusha

  call vsync
  mov si,offset palette_noire     ; Met la palette en noir avant d'afficher
  call envoie_palette

  call vsync
  call prepare_ecran     ; Affiche le motif de fonds

  call vsync

  mov si,offset palette_noire    ; effectue le fondu d'arriv‚e sur le vert
  mov di,offset palette_intro
  call execute_fondu

  mov fin_intro,0

  mov si,offset script_intro    ; D‚but du script
  mov cx,6               ; 6 images … afficher
boucle_affiche_intro:
  push cx
  call prepare_ecran     ; Affiche le motif de fonds
  lodsd                  ; EAX=offset palette:offset image
  push si
  mov si,ax		 ; SI=d‚but de l'image
  call affiche_intro	 ; affiche l'image compact‚e

  shr eax,16		 ; r‚cupŠre l'adresse de la palette de l'image

  mov si,offset palette_intro   ; Fait apparaitre l'image
  mov di,ax
  call execute_fondu	; Fondu d'apparition
  mov cx,70*2
  call temporise         ; Attend un petit peu
  mov si,ax
  mov di,offset palette_intro
  call execute_fondu	 ; Fondu de disparition
  mov cx,15
  call temporise         ; Attend un petit peu

  pop si
  pop cx
  cmp fin_intro,0
  loope boucle_affiche_intro

  mov si,offset palette_intro   ; Fondu au noir...
  mov di,offset palette_noire
  call execute_fondu
  call vide_buffer_clavier
  popa
  pop ds
  pop es
  ret
endp

; Affiche un motif … l'‚cran, compos‚ de lignes verticales de 2 pixels
; d'‚paisseur, utilisant les index de couleur de 1 … 100.
;
prepare_ecran proc near
  pusha
  push es
  push adresse_ecran
  pop es
  mov edi,0
  mov eax,01010101h	; Couleur 1 sur 4 pixels cons‚cutifs
  mov dx,100
ligne_suivante:
  mov ecx,160		; Inscrit (320 pixels x 2lignes)/4 octets
  rep stosd 		; Trace les 2 lignes
  add eax,01010101h	; Ajoute 1 … chaque pixels pour le d‚grad‚
  dec dx
  jne ligne_suivante
  pop es
  popa
  ret
endp



; Affiche une image compact‚e par segments horizontaux
; DS:SI doit pointer sur l'image.
;

affiche_intro proc near
  push es
  push ds
  pusha

  push adresse_ecran         ; Fait pointer ES sur la m‚moire ‚cran
  pop es

  mov dx,0               ; PremiŠre ligne d'affichage.
segment_suivant:
  lodsb			 ; Charge le 1er octet (X1 poids fort)
  cmp al,-1		 ; Si X1=-1, c'est la fin de l'image
  je fin_segment
  sub ah,ah
  mov bx,ax              ; X1 segment

  lodsb			; Charge le 2Šme octet (X2 poids fort)
  sub ah,ah
  mov cx,ax              ; X2 segment

  lodsb			; 3Šme octet (6bits:Y,1bit:X2,1bit:X1)
  sar ax,1		; Poids faible de X1
  adc bx,bx		; X1 complet
  sar ax,1		; Poids faible de X2 (Y complet)
  adc cx,cx		; X2 complet
  add dx,ax              ; Offset vertical d'affichage

  mov ax,320
  push dx
  mul dx                 ; AX=Adresse verticale d'affichage du segment.
  pop dx
  add ax,bx              ; On a l'adresse du premier point du segment … gauche.

  mov di,ax              ; DI pointe sur le d‚but du segment

  mov ax,dx
  sar ax,1               ; La couleur est ‚gale … 128+Y/2
  add ax,128

  sub cx,bx              ; Nombre d'it‚rations … effectuer (X2-X1)

  rep stosb              ; Et zou ! Le segment est trac‚... (Waoouuuuhhh...)

  jmp segment_suivant
fin_segment:

  popa
  pop ds
  pop es
  ret
endp


