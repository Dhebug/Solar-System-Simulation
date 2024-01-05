;
; Module de cr‚ation de bruitages
;
;
; Comment faire de la musique agr‚able avec le ®PC-Speaker¯ ??
; AX -> Dur‚e de la note
; BX -> Num‚ro de la note

bipbip proc near
  pusha

  mov al,182             ;Pr‚parer g‚n‚ration d'un son
  out 43h,al             ;Envoyer valeur au Timer Command Register

  add bx,bx		 ;Multiplie par 2 pour acc‚der … un WORD

  mov ax,[notes+bx]      ;Lire valeur de note

  out 42h,al             ;Octet faible dans Timer Counter Register
  mov al,ah              ;Transf‚rer octet fort dans AL
  out 42h,al             ;et aussi dans Timer Counter Register

  in al,61h              ;Lire bit de contr“le du haut-parleur
  or al,3                ;Deux bits inf‚rieurs activent haut-parleur
  out 61h,al             ;Activer haut-parleur

  popa
  ret
endp
