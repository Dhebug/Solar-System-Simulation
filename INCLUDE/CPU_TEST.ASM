; Test processeur:
; - Sur 8088/8086, les 4 bits de poids fort du registre Flags sont
; mis … 1 lors d'un empilement.
; - Sur 80286, ces mˆmes 4 bits sont forc‚s … z‚ro.
; On fait donc la manipulation, et si on obtient 1111xxxx ou 0000xxxx, on
; en d‚duit que le processeur n'est ni un 386, ni un 486, ni un... 586 ?

teste_processeur proc near
  pushf
  pop ax
  mov bx,ax
  and ah,00001111b      ; Efface les 4 bits de poids fort
  or bh,11110000b       ; Positionne les 4 bits de poids fort
  push ax
  popf
  pushf
  pop ax
  and ah,11110000b      ; Ne conserve que les 4 bits de poids fort
  cmp ah,11110000b
  je mauvais_processeur
  push bx
  popf
  pushf
  pop ax
  and ah,11110000b      ; Ne conserve que les 4 bits de poids fort
  je mauvais_processeur

processeur_correct:
  mov ax,-1
  ret

; On affiche un texte pour pr‚venir l'utilisateur qu'un
; 386 est le minimum requis.
mauvais_processeur:
  mov ah,9
  mov dx,offset message_processeur
  int 21h
  mov ax,0
  ret
endp
