gestion_planettes proc near
  push es
  push ds
  pusha

  mov si,offset palette_noire   ; Met la palette en noir pour ‚viter les
  call envoie_palette           ; clignotements

  mov si,offset palette_noire
  mov di,offset palette_anim
  call prepare_fondu

  mov phase_fondu,0

  call affiche_logo

  call echange_pages
  call vsync

  mov ax,340                    ; On coupe l'‚cran … partir de la ligne 340
  call coupe_ecran              ; pour afficher le nom et le scrolling.

  call affiche_nom_planete      ; Affiche le nom (le soleil en l'occurence).

rotation_suivante:
  time 50
  call efface_page              ; Efface l'‚cran
  time 0
  time 23
  call scrolling                ; Affiche le scrolling
  time 0
  time 63
  call affiche_planete          ; Trace les planetes
  time 0
  call fondu_suivant            ; Gestion du fondu de couleur
  call echange_pages            ; Flipping d'adresses vid‚o
  call vsync                    ; Synchronisation verticale
  mov si,offset palette_source  ; Valide le changement de palette
  call envoie_palette

  in al,61h              ;Lire bit de contr“le du haut-parleur
  and al,11111100b       ;Annuler deux bits inf‚rieurs
  out 61h,al             ;D‚sactiver haut-parleur

  cmp fondu_termine,0           ; Tant que le fondu est actif, on ne controle
  jne rotation_suivante         ; pas le clavier.
  cmp afficher_texte,1
  jne pas_afficher_encyclopedie

  mov ax,500                    ; Le fondu est termin‚, donc on va afficher
  call coupe_ecran              ; la partie ®encyclop‚dique¯. On supprime
  call affiche_encyclopedie     ; la coupure ‚cran, on appelle la routine,
  mov ax,340                    ; puis on r‚active la coupure ‚cran.
  call coupe_ecran
  mov si,offset palette_noire   ; Puis r‚initialise le fondu, r‚affiche le
  mov di,offset palette_anim    ; logo et le nom de la planete...
  call prepare_fondu
  mov afficher_texte,0
  mov phase_fondu,0
  call affiche_nom_planete
  call affiche_logo
  jmp rotation_suivante

pas_afficher_encyclopedie:
  cmp afficher_texte,2
  je quitte_planetes

  mov ah,1                     ; Attend que l'on presse une touche
  int 16h                      ; interrupt 16h
  je rotation_suivante

  mov ah,0                   ; Interrupt 16h --> Lecture du clavier
  int 16h                    ; AL=ASCII / AH=SCAN CODE

  cmp al,32                  ; [ESPACE] ??? Oui, alors on indique que l'on
  jne pas_quitte_planete     ; quitte

  mov si,offset palette_anim    ; Pr‚pare le fondu final, et met '2' pour
  mov di,offset palette_noire   ; indiquer … la fin du fondu que c'est la
  call prepare_fondu            ; fin du programme.
  mov afficher_texte,2
  mov phase_fondu,0
  jmp rotation_suivante

pas_quitte_planete:
  cmp al,13                  ; Si 'Return' ou 'Enter', affiche le texte
  jne pas_selection_texte

  mov bx,30
  if active_musique eq 1
  call bipbip                   ; Signal sonore
  endif
  mov si,offset palette_anim
  mov di,offset palette_noire
  call prepare_fondu            ; Lance le fondu, et indique '1' pour dire
  mov afficher_texte,1          ; qu'il faudra lancer l'encyclop‚die … la
  mov phase_fondu,0             ; fin du fondu.
  mov ax,planete_courante
  mov numero_texte,ax
  jmp rotation_suivante

pas_selection_texte:
  cmp ah,77                     ; FlŠche droite ???
  jne pas_planete_suivante

  mov bx,20
  if active_musique eq 1
  call bipbip                   ; Signal sonore, puis calcule le num‚ro
  endif                         ; de la planete suivante.
  mov ax,planete_courante
  inc ax
  mov planete_courante,ax
  cmp ax,10
  jne pas_raz_suivante
  mov planete_courante,0
pas_raz_suivante:
  call affiche_nom_planete
  jmp rotation_suivante

pas_planete_suivante:
  cmp ah,75                     ; FlŠche gauche ???
  jne selection_invalide

  mov bx,20
  if active_musique eq 1        ; Idem, mais pour la planete pr‚c‚dente.
  call bipbip
  endif
  mov ax,planete_courante
  dec ax
  mov planete_courante,ax
  jns pas_raz_precedente
  mov planete_courante,9
pas_raz_precedente:  
  call affiche_nom_planete
  jmp rotation_suivante

selection_invalide:
  mov bx,30
  if active_musique eq 1           ; Si on appuie sur n'importe quelle autre
  call bipbip                      ; touche, on affiche l'‚cran d'aide.
  endif
  mov si,offset palette_anim
  mov di,offset palette_noire
  call prepare_fondu
  mov afficher_texte,1
  mov phase_fondu,0
  mov numero_texte,10
  jmp rotation_suivante

quitte_planetes:

  popa
  pop ds
  pop es
  ret
endp

; DS:SI
; - +0 La distance en milliers de kilomŠtres par rapport au soleil. (En millions en r‚alit‚...)
; - +4 Le diametre de la planete en milliers de kilomŠtres.
; - +8 Le pas en degr‚ pour effectuer une r‚volution complete.
; - +12 L'angle courant de la planete...
; +16 -> Planete suivante
;
; ES:DI
; - +0 Position X
; - +4 Position Y
; - +8 Position Z
; - +12 Rayon
; - +16 Couleur
; - +20 Num‚ro
;
affiche_planete proc near
  ;
  ; On remplit la table xyz...
  ;
  ;
  mov si,offset donnees_planetes ; Liste des planetes (permanente)
  mov di,offset liste_affichage  ; Liste des planetes (temporaire)
  mov edx,0
  mov ecx,nb_planete
planete_suivante:
  mov eax,dword ptr [si]      ; Distance au soleil
  shr eax,4                   ; RX=distance/16
  mov rx,eax
  shr eax,1                   ; RX=distance/32
  mov ry,eax

  mov eax,dword ptr [si+12]   ; Angle courant de la planete (position en degr‚s)
  mov position,eax
  add eax,dword ptr [si+8]    ; D‚place la planete (angle courant+vitesse), et
  cmp eax,360*65536*2         ; fait le test MODULO 360 degr‚s.
  jbe pas_de_probleme
  sub eax,360*65536*2
pas_de_probleme:
  mov dword ptr [si+12],eax   ; Sauve la nouvelle position
  call calcule_position       ; Effectue le calcul trigo.
  mov eax,0                   ; On obtient en sortie les coordonn‚es ‚cran.
  mov ax,x
  mov dword ptr [di],eax      ; X ‚cran
  mov ax,y
  mov dword ptr [di+4],eax    ; Y ‚cran

  mov [di+8],eax              ;
  mov eax,[si+4]              ; R=diametre de la planete
  shr eax,1
  mov [di+12],eax             ; Sauve le rayon de la planete
  mov eax,edx
  add eax,33                  ; La premiŠre couleur est en index 33
  mov [di+16],eax             ; Index de couleur
  mov [di+20],edx             ; Num‚ro de la planette
  inc edx                     ; Planete suivante
  add si,16
  add di,24
  loop planete_suivante
  ;
  ; On trie la table xyz, sur les z, du plus petit au plus grand
  ; (Z ‚tant une valeur cod‚e sur 4 octets en SIGN‚).
  ; C'est l'algorithme le plus performant pour 10 valeurs !)
  ; On pourait g‚rer des pointeurs au lieu de d‚placer physiquement les
  ; valeurs, mais ca ne ferait qu'alourdir l'op‚ration, alors que le temps
  ; est perdu essentiellement dans les op‚rations graphiques.

  mov si,offset liste_affichage
  mov cx,0         ; i=0
boucle_exterieure:
  mov dx,cx        ; j=i
  mov ax,si        ; di=si
  mov di,ax
boucle_interieure:
  mov ebx,[di+8]
  cmp [si+8],ebx
  jle echange_pas

  push di       ; On intervertie toutes les valeurs...
  push si
  push cx
  mov cx,6
swap:
  mov eax,[si]
  mov ebx,[di]
  mov [si],ebx
  mov [di],eax
  add si,4
  add di,4
  loop swap
  pop cx
  pop si
  pop di

echange_pas:
  add di,24
  inc dx                      ; j=j+1
  cmp dx,nb_planete           ; tant que j<nb-planete (10)
  jne boucle_interieure
  add si,24
  inc cx                      ; i=i+1
  cmp cx,nb_planete-1         ; tant que i<nb_planete-1  (9)
  jne boucle_exterieure

  ; Les planetes sont tri‚s par ordre de profondeur, donc on
  ; peut les afficher sans risques.

  mov si,offset liste_affichage
  mov cx,nb_planete
affiche_la_belle_planete:
  mov eax,[si+16]           ; Couleur
  mov couleur,al
  mov eax,[si+0]            ; Centre X
  mov xcdisque,ax
  mov eax,[si+4]            ; Centre Y
  mov ycdisque,ax
  mov edx,[si+12]           ; Rayon->Ypos(0-199)*Rayon/64
  mul edx                   ; Plus la planete est loin, plus elle est petite.
  shr eax,6
  inc eax
  mov rdisque,ax
  mov eax,[si+20]
  mov numero_planete,ax
  call trace_disque         ; Effectue l'affichage
  add si,24
  loop affiche_la_belle_planete
  ret
endp



;
; Fonction qui calcule les coordonn‚es d'un objet dont on fournie
; les coordonn‚es polaires.
; En entr‚e:
; (rx,ry): Rayon en X, et rayon en Y
; (position): Angle d'affichage (En degr‚*65536)
;
; En sortie:
; (x,y): Coordonn‚es rectangulaires.
;
; NB: la table de cosinus donne une pr‚cision de l'ordre de 1/4 de degr‚s.
;
calcule_position proc near
  pusha
  mov si,offset table_cosinus

  mov ebx,position        ; CHarge l'angle courant
  shr ebx,15              ; R‚cupŠre la partie entiere (divise par 65536)
  shl bx,2                ; REmultiplie par 4 -> index sur la table en DD
  push bx
  mov ebx,[bx+si]         ; ANGLE d‚sir‚
  mov eax,rx              ; RAyon en X
  imul eax,ebx            ; Multiplie l'un par l'autre
  shr eax,16              ; R‚cupŠre le r‚sultat en entier 16 bits
  add ax,160
  mov x,ax

  pop bx
  mov ebx,[bx+si+90*16]   ; ANGLE d‚sir‚
  mov eax,ry              ; RAyon en y
  imul eax,ebx            ; Multiplie l'un par l'autre
  shr eax,16              ; R‚cupŠre le r‚sultat en entier 16 bits
  add ax,200
  mov y,ax
  popa
  ret
endp



; Routine qui fait clignoter la planete s‚lectionn‚e, agit sur la couleur
; d'index 255

clignotement_couleur proc near
  push ax
  xor ax,ax
  mov al,byte ptr [palette_source+766]  ; Ancienne couleur
  cmp sens_couleur,0            ; 0-> Incremente / 1-> D‚cr‚mente
  jne decremente_couleur
incremente_couleur:
  inc ax
  cmp ax,63
  jl fin_clignotement
  not sens_couleur
  jmp fin_clignotement

decremente_couleur:
  dec ax
  cmp ax,20
  jg fin_clignotement
  not sens_couleur

fin_clignotement:
  mov byte ptr [palette_source+765],al  ; Sauve la nouvelle couleur
  mov byte ptr [palette_source+766],al
  mov byte ptr [palette_source+767],al
  pop ax
  ret
endp


;
; En entr‚e:
; (CX,CY) coordonn‚es du centre du disque. (X<320,Y<200)
; (R) rayon du disque.
; (couleur) couleur de remplissage du disque (couleur<256)
;
trace_disque proc near
  pusha
  mov ax,numero_planete         ; Si planete_courante=planete affich‚e, alors
  cmp ax,planete_courante       ; On lui affecte la couleur 255 (celle qui
  jne fin_clignotement_couleur  ; clignote)
  cmp fondu_termine,0
  jne fin_clignotement_couleur
  mov couleur,255
  call clignotement_couleur
fin_clignotement_couleur:

  call calcule_adresse_logique

  mov ax,1
  sub ax,rdisque
  add ax,ax
  mov ddisque,ax                    ; di=2(1-R)

  mov ax,ycdisque
  mov bx,ax
  sub ax,rdisque
  add bx,rdisque
  mov y1,ax
  mov y2,bx

  mov ax,80
  mul y1
  mov di,ax

  mov bx,0                     ; Xi=0
  mov cx,rdisque               ; Yi=r
  mov dx,3c4h       ; Registre de s‚lection de plans

boucle_trace_disque:
  call trace_segment_disque          ; Plot (Xi,Yi)
  cmp cx,0
  je fin_trace_disque         ; yi n‚gatif ??? ---> termin‚

  cmp ddisque,0
  js label2                   ; di<0
  je label20                  ; di=0
;
;                            ; di>0
;
  mov ax,ddisque
  add ax,bx
  add ax,ax
  dec ax                      ; delta=2di+2xi-1
  jns label30                 ; delta>=0
label20:                      ; delta<0
  inc bx                       ; Xi=Xi+1
  dec cx                       ; Yi=Yi-1
  inc y1
  dec y2
  add di,80
  mov ax,bx
  sub ax,cx
  inc ax
  add ax,ax
  add ddisque,ax               ; Di=Di+2(Xi-Yi+1)
  jmp boucle_trace_disque

label2:
  mov ax,ddisque
  add ax,cx
  add ax,ax
  dec ax                      ; delta=2di+2yi-1
  jns label20                 ; delta>=0
;
;                            ; delta<0
;
  inc bx                       ; Xi=Xi+1
  mov ax,bx
  add ax,ax
  add ax,ddisque
  inc ax
  mov ddisque,ax                    ; di=di+2xi+1
  jmp boucle_trace_disque

label30:
  dec cx                  ; Yi=Yi-1
  inc y1
  dec y2
  add di,80
  mov ax,ddisque
  sub ax,cx
  sub ax,cx
  inc ax                 ; Di=Di-2Yi+1
  mov ddisque,ax
  jmp boucle_trace_disque

fin_trace_disque:
  popa
  ret
 endp







trace_segment_disque proc near
  pusha
  shr bx,1              ; Teste la parit‚ de X, en divisant par 2
  jc fin_trace_segment  ; (on est en 320x400, donc on trace des ellipses
                        ; pour obtenir des cercles.

  mov si,di             ; Sauve pour la suite des op‚rations
  mov fs,bx
  mov gs,cx

;
; Segment vertical de gauche
;
  neg bx            ; -x
  add bx,xcdisque   ; +x centre= coordonn‚e en X
  mov cl,bl         ; Effectue la s‚lection de plan
  shr bx,2
  add di,bx         ; Offset sur l'‚cran
  and cl,3
  mov ah,1
  shl ah,cl
  mov al,2
  out dx,ax         ; Valide le bon plan

  mov al,couleur

; On trace deux par deux, afin d'‚conomiser un LOOP toutes les deux copies.
; Le test sert … ‚viter le tra‡age lorsque CX=0, car sinon ca plante...

  mov cx,gs
  cmp cx,0
  je trace_simple_x1
trace_segment_x1:
  stosb
  add di,80-1
  stosb
  add di,80-1
  loop trace_segment_x1
trace_simple_x1:
  stosb
  add di,80-1

  mov di,si
  mov bx,fs
;
; Segment vertical de droite
;
  add bx,xcdisque   ; Calcule la coordonn‚e en X
  mov cl,bl         ; Effectue la s‚lection de plan
  shr bx,2
  add di,bx         ; Offset sur l'‚cran
  and cl,3
  mov ah,1
  shl ah,cl
  mov al,2
  out dx,ax

  mov al,couleur

  mov cx,gs
  cmp cx,0
  je trace_simple_x2
trace_segment_x2:
  stosb
  add di,80-1
  stosb
  add di,80-1
  loop trace_segment_x2
trace_simple_x2:
  stosb
  add di,80-1

fin_trace_segment:
  popa
  ret
endp





; Pour faire d‚filer le texte, il faut un buffer dans lequel on m‚morise
; l'‚tat actuel du message, car il est trop difficile de d‚placer directement
; les octets dans la m‚moire vid‚o (organisation du mode X, trŠs sp‚ciale.)
; Donc, on recopie ce buffer plan de pixel par plan de pixel, puis on d‚cale
; de 1 octet tout le contenu du buffer, ce qui revient … donner l'impression
; que le texte d‚file vers la gauche. Ensuite, on r‚affiche … droite du
; buffer le morceau de la lettre qui doit apparaitre.

scrolling proc near
  push es


  push adresse_ecran              ; Fait pointer ES sur la m‚moire ‚cran
  pop es

  mov si,offset buffer_scroll            ; S‚par‚ en 4 plans...

  mov dx,3c4h
  mov ah,01                       ; Commence par le plan 1

  mov cx,4                        ; 4 Plans … recopier
recopie_plan_suivant:
  push cx
  push si
  mov al,02
  out dx,ax                 ; S‚lection du plan
  add ah,ah                 ; Passe au plan suivant
  mov di,80*40
  mov cx,32     ; 640 recopie, dont 20 au REPT, donc 32 it‚ration … faire
recopie_plan_0:
  rept 20         ; On optimise: Au lieu d'ex‚cuter 640 instructions LOOP
  mov al,[ds:si]  ; (Une d‚crementation de CX+Un test+Un branchement), on
  stosb           ; en effectue que 32. Le REPT 20, pr‚cise … TASM qu'il
  add si,4        ; doit recopier 20 fois la s‚quence d'instructions.
  endm
  loop recopie_plan_0
  pop si
  inc si
  pop cx
  loop recopie_plan_suivant

; Maintenant que c'est affich‚, on fait scroller le buffer...

  push ds               ; DS=ES
  pop es

  mov ax,offset buffer_scroll            ; S‚par‚ en 4 plans...
  mov di,ax
  inc ax
  mov si,ax

  mov cx,640
  rep movsd                       ; Pixels nø0,4,8,...

  call inscrit_lettre_scroll
  pop es
  ret
endp


; On affiche la lettre … droite du buffer, colonne par colonne.
; Tous les 8 pixels affich‚s, on change de lettre.

inscrit_lettre_scroll proc near
  push es

  push seg fonte               ; ES pointe sur la fonte
  pop es

  mov bx,compteur_scroll       ; Colonne courante … afficher

  mov si,pointeur_scroll       ; R‚cup‚ration du caractŠre suivante, et
  mov al,[si]                  ; mise … jour du pointeur sur le texte.
  cmp bx,7
  jne continue_lettre_courante
  inc si                       ; Si l'on atteint le dernier caractŠre, alors
  cmp al,0                     ; on recommence au d‚but du texte.
  jne pas_fin_scrolling
  mov si,offset texte_scroll
  mov al,[si]
pas_fin_scrolling:
  mov pointeur_scroll,si
continue_lettre_courante:

  sub ah,ah                    ; Calcule l'offset du caractŠre dans la fonte
  shl ax,6
  mov si,offset fonte
  add si,ax                    ; Adresse finale du caractŠre
  add si,bx
  inc bx
  and bx,7
  mov compteur_scroll,bx

  mov di,offset buffer_scroll+319     ; Derniere colonne du buffer de scroll

  mov cx,8
  mov al,43                     ; Couleur … afficher (de 43 … 51)
boucle_affiche_caractere:
  mov ah,[es:si]
  cmp ah,0
  je trace_pas
  mov ah,al                     ; Si le pixel n'est pas noir, on lui
trace_pas:                      ; affecte la bonne couleur dans le d‚grad‚.
  mov [ds:di],ah
  inc al                        ; Index de couleur suivant
  add si,8                      ; Colonne suivante de la lettre
  add di,320                    ; Ligne suivante du buffer
  loop boucle_affiche_caractere

  pop es
  ret
endp


; Affiche en gros caractŠres le nom de chaque planete.
; Chaque lettre fait 32x33. (NB: Si elles avaient fait 32x32, on aurait pu
; remplacer le MUL 1056, par un d‚callage … gauche (32x32=1024). Mais, vu
; qu'un mot fait au maximum 10 caractŠres, cela a peu d'importance.)

affiche_nom_planete proc near
  push fs
  push es
  push ds
  pusha
  
  mov si,offset liste_noms
  mov ax,planete_courante
  add ax,ax
  add si,ax
  mov bx,[si]            ; Charge l'offset du texte
 
  push ds                 ; FS=DS=le nom de la planete
  pop fs

  push adresse_ecran      ; ES:DI pointe sur l'‚cran
  pop es

  push seg epic_font      ; DS:SI pointe sur la fonte
  pop ds
  
  mov di,0

  mov ax,[fs:bx]          ; On donne un offset d'affichage pour
  add bx,2
  add di,ax               ; centrer le texte

boucle_affiche_nom:
  mov al,[fs:bx]          ; Lecture de la lettre … afficher (code ASCII)
  cmp al,0
  je fin_affichage_nom
  inc bx                  ; D‚place le pointeur

  sub ah,ah
  sub al,'A'              ; On obtient un num‚ro de 0 … 26 (26=espace)
  mov cx,1056
  mul cx
  mov si,offset epic_font
  add si,ax               ; Adresse finale de la lettre dans la fonte.

  mov dx,3c4h             ; S‚lection de plan
  mov ax,0102h
  
  mov cx,4                ; 4 plan … afficher
plan_lettre_suivant:
  out dx,ax               ; Valide la plan

  add ah,ah               ; Plan suivant

  push cx
  push ax
  mov cx,33               ; 33 pixels de haut
recopie_verticale_0:
  push cx
  rept 8                  ; 8 octets x4plans =32 pixels
  mov al,[ds:si]
  stosb                   ; = mov [es:di++],al
  add si,4
  endm
  add di,80-8             ; Ligne suivante de l'‚cran
  pop cx
  loop recopie_verticale_0
  sub si,32*33-1          ; Remonte au d‚but du caractŠre
  sub di,80*33            ; Remonte au d‚but de la lettre sur l'‚cran.
  pop ax
  pop cx
  loop plan_lettre_suivant

  mov ax,0f02h            ; Chaque lettre est s‚par‚e de 4 pixels noirs
  out dx,ax               ; donc on s‚lectionne les 4 plans en mˆme temps
  add di,8                ; et on efface toute une colonne d'octets
  mov cx,33
efface_colonne:
  mov byte ptr [es:di],0
  add di,80
  loop efface_colonne

  sub di,80*33-1          ; Positionne sur l'emplacement ‚cran suivant
  jmp boucle_affiche_nom
  

fin_affichage_nom:
  
  popa
  pop ds
  pop es
  pop fs
  ret
endp



; Routine qui affiche le logo ®PLANETES¯ en haut de l'‚cran.
; Le logo est un bloc graphique de 320x47 pixels, … afficher en
; mode X, sur les 2 pages graphiques

affiche_logo proc near
  push es
  push ds
  pusha

  push adresse_ecran    ; Adresse de l'‚cran
  pop es
  mov di,80*80

  push seg logo_titre   ; Adresse du logo
  pop ds
  mov si,offset logo_titre


  mov dx,3c4h           ; Registre de validation des plans
  mov ax,0102h
  
  mov cx,4              ; 4 plans … afficher
plan_logo_suivant:
  out dx,ax             ; S‚lection du plan

  add ah,ah             ; Pr‚pare pour le plan suivant

  push cx
  push ax
  mov cx,47*80          ; Un plan du logo fait 80 (=320/4) octets x47 lignes
recopie_logo:
  mov al,[ds:si]        ; Octet source
  mov [es:di+32000],al  ; Recopie dans la page ‚cran num‚ro 2
  stosb                 ; Recopie dans la page ‚cran num‚ro 1 (mov [es:di++],al)
  add si,4              ; Un plan contient les pixels modulo 4
  loop recopie_logo
  sub si,47*320-1       ; Plan suivant du logo
  sub di,47*80          ; Repart au d‚but de l'‚cran pour le plan suivant

  pop ax
  pop cx
  loop plan_logo_suivant

  popa
  pop ds
  pop es
  ret
endp


