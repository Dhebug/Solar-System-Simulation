;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%                                                                          %%
;%%  Projet d'Architecture des SystŠmes Informatiques                        %%
;%%  Ann‚e 1993/1994                                                         %%
;%%  - Dubief ArlŠne                                                         %%
;%%  - Mercier S‚bastien                                                     %%
;%%  - Pointier Micka‰l                                                      %%
;%%                                                                          %%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



; D‚claration des labels qui proviennent des fichiers … LINKER

extrn debut_image

extrn images
image_1=images
image_2=image_1+1841
image_3=image_2+1352
image_4=image_3+1259
image_5=image_4+1919
image_6=image_5+2891

extrn palettes
palette_image=palettes
palette_intro=palette_image+768
palette_jaune=palette_intro+768
palette_violette=palette_jaune+768
palette_noire=palette_violette+768
palette_anim=palette_noire+768

extrn fonte
extrn epic_font
extrn end_font
extrn logo_titre


; D‚claration des constantes utilis‚es

adresse_ecran   equ 0A000h
nb_planete      equ 10
cpu_time        equ 0           ; 1 pour avoir le temps machine affich‚
lance_intro     equ 1           ; 1 pour avoir l'intro
active_musique  equ 1           ; 1 pour avoir les bruitages

.model compact
.stack 256
.data


table_cosinus label
 include include\cosinus.asm ; Cosinus/Sinus pr‚calcul‚s (*65536)
 include include\celeste.asm ; Les coordonn‚es des planetes
 include include\textes.asm  ; Les textes ®encyclop‚diques¯



;
; 10x(X,Y,Z,Rayon,Couleur,numero)
;
liste_affichage      dd 10*6 dup (0)

position             dd 0       ; Angle en degr‚ (*65536)
rx                   dd 0       ; Rayon en X
ry                   dd 0       ; Rayon en Y

x                    dw 0       ; Coordonn‚e ‚cran finale en X
y                    dw 0       ; Et en Y

numero_texte         dw 0       ; Num‚ro du texte … afficher

y1                   dw 0       ; Coordon‚es verticales du segment … tracer.
y2                   dw 0

numero_planete       dw 0       ; Num‚ro de la planete en cour d'affichage
planete_courante     dw 0       ; Num‚ro de la planete courante

afficher_texte       db 0       ; Drapeau pour la routine de planetes
                                ; indique l'op‚ration … faire apres le fondu
                                ; (Quitter, afficher le texte,...)
code_souligne        db 0       ; Pour la routine de texte

sens_couleur         db 0       ; Indique si incr‚mente ou d‚cr‚mente couleur

old_video            db 0       ; Ancienne r‚solution

pages_ecran          label word ; Permet d'acc‚der aux deux pages
page_logique         db 0
page_physique        db 1

xcdisque             dw 0       ; Centre X du disque
ycdisque             dw 0       ; Centre Y du disque
rdisque              dw 0       ; Rayon du disque
ddisque              dw 0       ; Delta (erreur pour le tra‡age de disque)

couleur              db 0       ; Couleur d'affichage du disque

fin_intro            db 0       ; Utilis‚ par la routine de temporisation


buffer_scroll        db 320*8 dup (0)
pointeur_scroll      dw offset texte_scroll
compteur_scroll      dw 0


script_intro label
                     dw offset image_1,offset palette_jaune
                     dw offset image_2,offset palette_violette
                     dw offset image_3,offset palette_jaune
                     dw offset image_4,offset palette_violette
                     dw offset image_5,offset palette_jaune
                     dw offset image_6,offset palette_violette


palette_source       db 768 dup(0)
palette_destination  db 768 dup(0)

table_increments     dd 768 dup(0)
table_intermediaire  dd 768 dup(0)

phase_fondu          db 0
fondu_termine        db 0

notes label word
                     dw 9121,8609,8126,7670  ;Valeurs de notes pour l'octave 3
                     dw 7239,6833,6449,6087
                     dw 5746,5423,5119,4831
                     dw 4560,4304,4063,3834  ;Valeurs de notes pour l'octave 4
                     dw 3619,3416,3224,3043
                     dw 2873,2711,2559,2415
                     dw 2280,2152,2031,1917  ;Valeurs de notes pour l'octave 5
                     dw 1809,1715,1612,1521
                     dw 1436,1355,1292,1207


; Permet de changer la couleur de la bordure
; et donc de visualiser le temps machine occup‚
; par une routine donn‚e.
time macro col
  if cpu_time eq 1
  push ax
  push dx
  mov dx,3dah
  in al,dx
  mov dx,3c0h
  mov al,11h+32
  out dx,al
  mov al,col
  out dx,al
  pop dx
  pop ax
  endif
  endm

jumps
.code
.386


debut:
  mov ax,@Data            ; Fait pointer DS sur le segment de donn‚es
  mov ds,ax

  call teste_processeur
  cmp ax,0
  je fin_programme

  mov ah,15              ; GET GRAPHIC MODE
  int 10h                ; Cette interruption permet de connaitre le mode
  mov old_video,al       ; graphique qui est utilis‚ actuellement.

  mov ax,0013h            ; Passe en mode 320x200 256 couleurs
  int 10h

  cld                     ; Traite les r‚p‚tition par incr‚mentation

  if lance_intro eq 1
    call intro_symboles
    call intro_planette
  endif
  call mode_x
  call gestion_planettes

  mov ah,0              ; SET GRAPHIC MODE
  mov al,old_video      ; Restaure l'ancien mode graphique
  int 10h

  mov ah,9
  mov dx,offset message_termine     ; Affiche le texte final...
  int 21h

fin_programme:
  mov ah,4ch             ; Retour au DOS
  int 21h







 if lance_intro eq 1
   include include\intro_1.asm
   include include\intro_2.asm
 endif
 include include\planetes.asm
 include include\gere_pal.asm
 include include\encyclop.asm
 include include\cpu_test.asm
 if active_musique eq 1
   include include\bipbip.asm
 endif


; Effacement de tout l'‚cran

efface_ecran proc near
  pusha
  push es

  call valide_plans

  mov ax,adresse_ecran         ; Fait pointer ES sur la m‚moire ‚cran
  mov es,ax
  mov di,0
  mov ecx,16000            ; 64000 octets=16000 mots longs
  mov eax,0
  rep stosd
  pop es
  popa
  ret
endp



; Effacement de la page logique.
; Le mode graphique choisi est le mode 320x400x256 couleurs, qui
; occupe donc 128000 octets.
; Vu que le mode X permet d'adresser les pixels par groupe de 4,
; il faut donc envoyer 128000/4=32000 octets nuls pour effacer
; la totalit‚ de la page graphique. En utilisant STOSD qui envoie les
; octets par groupe de 4, il suffit de 32000/4=8000 it‚rations pour
; effacer la page. D'o— ECX=8000.

efface_page proc near
  pusha
  push es

  call valide_plans
  call calcule_adresse_logique
  mov eax,es
  add eax,20*30
  mov es,ax
  mov edi,0
  mov ecx,3500            ; 32000 octets=8000 mots longs
  mov eax,0               ; Pour effacer 4 octets
  rep stosd               ; Recopie par 4 octets
  pop es
  popa
  ret
endp




; Routine qui attend la fin du balayage ‚cran.
; Permet d'‚viter les clignotements lors des op‚rations vid‚o.
; (Nb:Un balayage dure 1/70Šme de seconde).

vsync proc near
  push ax
  push dx
  mov dx,3dah        ; inp_stat_reg_1
attend_synchro:
  in al,dx
  test al,8          ; bit_vert_retrace
  je attend_synchro
attend_fin_synchro:
  in al,dx
  test al,8
  jne attend_fin_synchro
  pop dx
  pop ax
  ret
endp




; Fonction g‚n‚rale de temporisation avec attente de touche:
; Passer en CX le nombre de balayages ‚cran … attendre
; (Nb:Un balayage dure 1/70Šme de seconde, donc pour attendre une
; seconde, il faut mettre 70 dans CX... CQFD). La routine en
; profite pour indiquer si une touche a ‚t‚ press‚e ou non, et
; interromp la temporisation dans ce cas.

temporise proc near
  pusha
boucle_temporise:
  call vsync
  mov ah,1                 ; Attend que l'on presse une touche
  int 16h                  ; Renvoie Z=1 si aucune touche press‚e
  loope boucle_temporise   ; Jusqu'… CX=0 ou touche press‚e...
  je pas_touche
  inc fin_intro            ; Signale qu'une touche a ‚t‚ press‚e.
pas_touche:
  popa
  ret
endp




;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;% Permet de vider tous les caractŠres pr‚sents    %
;% dans la file d'attente (buffer) du clavier.     %
;% Evite les problŠmes pos‚s par la r‚p‚tition     %
;% clavier.                                        %
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vide_buffer_clavier proc near
  pusha
caractere_suivant:
  mov ah,1                 ; Attend que l'on presse une touche
  int 16h                  ; Renvoie Z=1 si aucun caractŠre
  je fin_vidage_buffer
  mov ah,0                 ; Retire le caractŠre du buffer clavier
  int 16h
  jmp caractere_suivant
fin_vidage_buffer:
  popa
  ret
endp



; On ‚crit en 3C4h le num‚ro du registre … changer (2)
;       et en 3C5h la valeur … y inscrire.
; Cela peut se faire avec l'instruction 16 bits OUT DX,AX en une seule
; op‚ration.

valide_plans proc near
  pusha
  mov dx,3c4h    ; S‚lection des 4 plans de bit, afin d'effacer
  mov ax,0f02h   ; TOUS les pixels de l'‚cran...
  out dx,ax
  popa
  ret
endp


; Routine qui permet de passer en mode X
; Cette routine est adapt‚ d'une proc‚dure en Turbo Pascal, je
; n'est pas la description des registres utilis‚s. En tout cas, ca
; fonctionne. (Se reporter … un ouvrage sp‚cialis‚.)

mode_x proc near
  pusha

  mov dx,3c4h

  mov al,4
  out dx,al

  inc dx

  in al,dx
  and al,247
  or al,4
  out dx,al

  mov dx,3d4h

  mov al,17h
  out dx,al

  inc dx

  in al,dx
  or al,64
  out dx,al

  dec dx

  mov al,14h
  out dx,al

  inc dx

  in al,dx
  and al,191
  out dx,al

  dec dx

  mov ax,4009h
  out dx,ax

  call efface_ecran

  popa
  ret
endp



; Effectue l'‚change entre les deux pages graphiques.
;
; Page num‚ro 1: A000
; Page num‚ro 2: A000+32000=BD00
;
echange_pages proc near
  push ax

  mov ax,pages_ecran
  xchg ah,al
  mov pages_ecran,ax

  call calcule_adresse_physique
  call valide_adresse_ecran

  pop ax
  ret
endp




; Effectue le changement d'adresse ‚cran. Cela permet de
; changer la page physique, ou de faire un scrolling ‚cran.

valide_adresse_ecran proc near
  push ax
  push dx

  mov dx,3d4h

  mov al,0ch
  mov ah,bh
  out dx,ax

  inc al
  mov ah,bl
  out dx,ax

  pop dx
  pop ax
  ret
endp





; Permet de choisir une ligne de l'‚cran o— le balayage repartira
; au d‚but de l'‚cran.
; AX=Num‚ro de la ligne … couper
; Pour supprimer la rupture, il suffit de passer une valeur supp‚rieure
; … 480 comme num‚ro de ligne
; Idem que pr‚c‚dement, c'est un convertion d'un routine Turbo Pascal.

coupe_ecran proc near
  pusha
  call vsync

  mov dx,3d4h

  mov bh,ah
  mov bl,bh
  and bx,0201h

  shl bx,4

  shl bh,1

  mov ah,al
  mov al,18h
  out dx,ax

  mov al,7
  out dx,ax
  inc dx
  in al,dx
  dec dx

  mov ah,al
  and ah,11101111b
  or ah,bl
  mov al,7
  out dx,ax

  mov al,9
  out dx,al
  inc dx
  in al,dx
  dec dx

  mov ah,al
  and ah,10111111b
  or ah,bh
  mov al,9
  out dx,ax

  popa
  ret
endp



; Calcul l'adresse d'un segment vid‚o

calcule_adresse_logique proc near
  push eax
  mov eax,adresse_ecran+250   ;((320*50)/16)/4      ; Fait pointer ES sur la m‚moire ‚cran
  cmp page_logique,0
  je premiere_page_logique
  add eax,2000
premiere_page_logique:
  mov es,ax
  pop eax
  ret
endp


; Calcule l'adresse vid‚o

calcule_adresse_physique proc near
  mov ebx,80*50
  cmp page_physique,0
  je premiere_page_physique
  add ebx,32000
premiere_page_physique:
  ret
endp
end debut
