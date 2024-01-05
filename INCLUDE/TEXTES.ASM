liste_noms label
 dw offset nom_soleil
 dw offset nom_mercure
 dw offset nom_venus
 dw offset nom_terre
 dw offset nom_mars
 dw offset nom_jupiter
 dw offset nom_saturne
 dw offset nom_uranus
 dw offset nom_neptune
 dw offset nom_pluton

nom_soleil      dw 6
                db "[SOLEIL[",0
nom_mercure     dw 8
                db "MERCURE",0
nom_venus       dw 8
                db "[VENUS[[",0
nom_terre       dw 8
                db "[TERRE[[",0
nom_mars        dw 4
                db "[[MARS[[",0
nom_jupiter     dw 8
                db "JUPITER",0
nom_saturne     dw 8
                db "SATURNE",0
nom_uranus      dw 2
                db "[URANUS[",0
nom_neptune     dw 8
                db "NEPTUNE",0
nom_pluton      dw 4
                db "[PLUTON[",0


liste_textes label
 dw offset msg_soleil
 dw offset msg_mercure
 dw offset msg_venus
 dw offset msg_terre
 dw offset msg_mars
 dw offset msg_jupiter
 dw offset msg_saturne
 dw offset msg_uranus
 dw offset msg_neptune
 dw offset msg_pluton
 dw offset msg_explication

msg_soleil label
db " ",0
db "  ",1,"Le Soleil",1," :",0
db " ",0
db "    Gaz comprenant principalement de l'",0
db "hydrogŠne, mais aussi de l'h‚lium et en",0
db "faible quantit‚ des atomes plus lourds.",0
db " ",0
db "    Masse : 1,989.10e30 kg ",0
db "    Unit‚ astronomique : 149 598 000 km",0
db "ñ300 km",0
db "    Age : 4,5 millard d'ann‚es.",0
db " ",0
db " Ceci est obtenu grƒce aux mesures de la",0
db "radioactivit‚ des roches terrestres et ",0
db "des m‚t‚orites.",0
db " ",0
db "   ",1,"Caract‚ristiques",1," :",0
db " ",0
db "     * photosphŠre : ",0
db "r‚gion profonde (partie que nous voyons",0
db "… l'oeil nu).",0
db " ",0
db "     * chromosphŠre :",0
db "o— se forment les raies les plus fortes",0
db "et dont la temp‚rature croŒt vers l'ex-",0
db "t‚rieur.",0
db " ",0
db "     * couronne : ",0
db "r‚gion trŠs chaude (observ‚e pendant",0
db "longtemps lors des ‚clipses de soleil en",0
db "raison de la brillance du ciel bleu qui",0
db "la cache hors ‚clipse)",0,0

msg_mercure label
db " ",0
db "  ",1,"MERCURE",1," :",0
db " ",0
db "    ",1,"Caract‚ristiques intrinsŠques",1," :",0
db " ",0
db "DiamŠtre : 4880 km",0
db "Masse    : 1/6120000 (en masse solaire)",0
db "Densit‚  : 5,46 (par rapport … l'eau)",0
db "P‚riode de rotation sid‚rale : 59 jours",0
db " ",0
db 1,"Caract‚ristiques orbitales et r‚volution",1,0
db " ",0
db "Distance moyenne par rapport au soleil:",0
db " 0,39 million de km",0
db "P‚riode de r‚volution sid‚rale :",0
db " 88 jours",0
db "Excentricit‚ de l'orbite : 0,206",0
db "Inclinaison de l'orbite sur l'‚clipti-",0
db "que : 7ø 00'",0,0

msg_venus label
db " ",0
db "  ",1,"VENUS",1," :",0
db " ",0
db "    ",1,"Caract‚ristiques intrinsŠques",1," :",0
db " ",0
db "DiamŠtre : 12100 km",0
db "Masse    : 1/407820 (en masse solaire)",0
db "Densit‚  : 5,38 (par rapport … l'eau)",0
db "P‚riode de rotation sid‚rale: 243 jours",0
db " ",0
db 1,"Caract‚ristiques orbitales et r‚volution",1,0
db " ",0
db "Distance moyenne par rapport au soleil:",0
db " 0,72 million de km",0
db "P‚riode de r‚volution sid‚rale :",0
db " 225 jours",0
db "Excentricit‚ de l'orbite : 0,007",0
db "Inclinaison de l'orbite sur l'‚clipti-",0
db "que : 3ø 24'",0,0

msg_terre label
db " ",0
db "  ",1,"TERRE",1," :",0
db " ",0
db "    ",1,"Caract‚ristiques intrinsŠques",1," :",0
db " ",0
db "DiamŠtre : 12757 km",0
db "Masse    : 1/332312 (en masse solaire)",0
db "Densit‚  : 5,52 (par rapport … l'eau)",0
db "P‚riode de rotation sid‚rale:",0
db " 23 h 56 mn 4 s",0
db " ",0
db 1,"Caract‚ristiques orbitales et r‚volution",1,0
db " ",0
db "Distance moyenne par rapport au soleil:",0
db " 1,00 million de km",0
db "P‚riode de r‚volution sid‚rale :",0
db " 1 an",0
db "Excentricit‚ de l'orbite : 0,007",0,0

msg_mars label
db " ",0
db "  ",1,"MARS",1," :",0
db " ",0
db "    ",1,"Caract‚ristiques intrinsŠques",1," :",0
db " ",0
db "DiamŠtre : 6800 km",0
db "Masse    : 1/3088000 (en masse solaire)",0
db "Densit‚  : 3,95 (par rapport … l'eau)",0
db "P‚riode de rotation sid‚rale: 24h 37mn",0
db " ",0
db 1,"Caract‚ristiques orbitales et r‚volution",1,0
db " ",0
db "Distance moyenne par rapport au soleil:",0
db " 1,52 million de km",0
db "P‚riode de r‚volution sid‚rale :",0
db " 1 an 322 jours",0
db "Excentricit‚ de l'orbite : 0,093",0
db "Inclinaison de l'orbite sur l'‚clipti-",0
db "que : 1ø 51'",0,0

msg_jupiter label
db " ",0
db "  ",1,"JUPITER",1," :",0
db " ",0
db "    ",1,"Caract‚ristiques intrinsŠques",1," :",0
db " ",0
db "DiamŠtre : 142880 km",0
db "Masse    : 1/1047 (en masse solaire)",0
db "Densit‚  : 1,33 (par rapport … l'eau)",0
db "P‚riode de rotation sid‚rale : 9h 50mn",0
db " ",0
db 1,"Caract‚ristiques orbitales et r‚volution",1,0
db " ",0
db "Distance moyenne par rapport au soleil:",0
db " 5,20 million de km",0
db "P‚riode de r‚volution sid‚rale :",0
db " 11 ans 315 jours",0
db "Excentricit‚ de l'orbite : 0,048",0
db "Inclinaison de l'orbite sur l'‚clipti-",0
db "que : 1ø 18'",0
db " ",0
db "    ",1,"Les satellites",1," :",0
db " ",0
db "actuellement 12 sont recens‚s dont :",0
db " Io (diamŠtre : 3350 km)",0
db " Europe (diamŠtre 3000 km)",0
db " GanymŠde (diamŠtre 4750 km)",0
db " Callisto (diamŠtre 4460 km)",0,0

msg_saturne label
db " ",0
db "  ",1,"SATURNE",1," :",0
db " ",0
db "    ",1,"Caract‚ristiques intrinsŠques",1," :",0
db " ",0
db "DiamŠtre : 120920 km",0
db "Masse    : 1/3498 (en masse solaire)",0
db "Densit‚  : 0,685 (par rapport … l'eau)",0
db "P‚riode de rotation sid‚rale : 10h 14mn",0
db " ",0
db 1,"Caract‚ristiques orbitales et r‚volution",1,0
db " ",0
db "Distance moyenne par rapport au soleil:",0
db " 9,55 million de km",0
db "P‚riode de r‚volution sid‚rale :",0
db " 29 ans 167 jours",0
db "Excentricit‚ de l'orbite : 0,056",0
db "Inclinaison de l'orbite sur l'‚clipti-",0
db "que : 2ø 29'",0
db " ",0
db "    ",1,"Les satellites",1," :",0
db " ",0
db "actuellement 10 sont recens‚s dont :",0
db "Minas (diamŠtre : 600 km)",0
db "Encelade (diamŠtre : 600)",0
db "T‚thys (diamŠtre : 1200),",0
db "Dion‚ (diamŠtre : 1200)",0
db "Rh‚a (diamŠtre : 1400)",0
db "Titan (diamŠtre : 4900)",0
db " Japet (diamŠtre : 1800)",0,0

msg_uranus label
db " ",0
db "  ",1,"URANUS",1," :",0
db " ",0
db "    ",1,"Caract‚ristiques intrinsŠques",1," :",0
db " ",0
db "DiamŠtre : 47170 km",0
db "Masse    : 1/22934 (en masse solaire)",0
db "Densit‚  : 1,6 (par rapport … l'eau)",0
db "P‚riode de rotation sid‚rale : 10h 49mn",0
db " ",0
db 1,"Caract‚ristiques orbitales et r‚volution",1,0
db " ",0
db "Distance moyenne par rapport au soleil:",0
db " 19,22 million de km",0
db "P‚riode de r‚volution sid‚rale :",0
db " 84 ans 7 jours",0
db "Excentricit‚ de l'orbite : 0,046",0
db "Inclinaison de l'orbite sur l'‚clipti-",0
db "que : 0ø 47'",0
db " ",0
db "    ",1,"Les satellites",1," :",0
db " ",0
db "actuellement 5 sont connus dont :",0
db " Ariel",0
db " Titana",0
db " Ob‚ron",0,0

msg_neptune label
db " ",0
db "  ",1,"NEPTUNE",1," :",0
db " ",0
db "    ",1,"Caract‚ristiques intrinsŠques",1," :",0
db " ",0
db "DiamŠtre : 45000 km",0
db "Masse    : 1/18889 (en masse solaire)",0
db "Densit‚  : 2,2 (par rapport … l'eau)",0
db "P‚riode de rotation sid‚rale : 16h",0
db " ",0
db 1,"Caract‚ristiques orbitales et r‚volution",1,0
db " ",0
db "Distance moyenne par rapport au soleil:",0
db " 30,11 million de km",0
db "P‚riode de r‚volution sid‚rale :",0
db " 164 ans 290 jours",0
db "Excentricit‚ de l'orbite : 0,009",0
db "Inclinaison de l'orbite sur l'‚clipti-",0
db "que : 1ø 46'",0
db " ",0
db "    ",1,"Les satellites",1," :",0
db " ",0
db "actuellement 2 sont connus dont :",0
db "Triton (diamŠtre : 5000 km environ)",0,0


msg_pluton label
db " ",0
db "  ",1,"PLUTON",1," :",0
db " ",0
db "    ",1,"Caract‚ristiques intrinsŠques",1," :",0
db " ",0
db "DiamŠtre : 5800 km",0
db "Masse    : inconnu",0
db "Densit‚  : inconnu",0
db "P‚riode de rotation sid‚rale : 6 jours",0
db " ",0
db 1,"Caract‚ristiques orbitales et r‚volution",1,0
db " ",0
db "Distance moyenne par rapport au soleil:",0
db " 39,52 million de km",0
db "P‚riode de r‚volution sid‚rale :",0
db " 248 ans 157 jours",0
db "Excentricit‚ de l'orbite : 0,249",0
db "Inclinaison de l'orbite sur l'‚clipti-",0
db "que : 17ø 09'",0,0

msg_explication label
 db 1,"Simulation de systŠme solaire",1,0
 db " ",0
 db "½ 1994 Dubief, Mercier, Pointier",0
 db " ",0
 db "Ce logiciel simule de fa‡on trŠs",0
 db "simplifi‚e le systŠme solaire dont",0
 db "nous d‚pendons",0
 db " ",0
 db "     ",1,"Fonctionnement du logiciel",1,0
 db " ",0
 db "Vous ne pouvez rien faire pendant les",0
 db "phases de fondu de couleur.",0
 db " ",0
 db "DŠs que la planete actuellement",0
 db "s‚lectionn‚e se met … clignoter,",0
 db "vous pouvez alors utiliser les",0
 db "touches flech‚es pour en choisir",0
 db "une autre.",0
 db " ",0
 db " Planete pr‚c‚dente.",0
 db " Planete suivante.",0
 db " ",0
 db "Un bruitage vous confirme l'op‚ration",0
 db "et le cadre se d‚place sur la planete",0
 db "d‚sign‚e. Vous pouvez alors obtenir",0
 db "certaines informations en pressant la",0
 db "touche de validation (Enter/Return/...)",0
 db " ",0
 db "Pour quitter, appuyez sur ESPACE...",0,0

message_termine label
 db 10,13
 db "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿",10,13
 db "³Merci d'avoir regard‚ ce programme.³",10,13
 db "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ",10,13
 db "$"

message_processeur label
 db 10,13
 db "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿",10,13
 db "³ Simulation de systŠme solaire... ³",10,13
 db "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿",10,13
 db "³    D‚sol‚, mais votre ordinateur n'est ‚quip‚ d'un processeur       ³",10,13
 db "³                       ant‚rieur au 80386.                           ³",10,13
 db "³   Si vous voulez faire tourner cette application, il vous faut      ³",10,13
 db "³au minimum un processeur 386 sx, ainsi qu'une carte VGA 256 couleurs.³",10,13
 db "³ N‚anmoins, un 486sx 25 sera id‚al pour obtenir une bonne animation. ³",10,13
 db "³                  Merci de votre compr‚hension !                     ³",10,13
 db "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ",10,13
 db "$"

texte_scroll label byte
 db "                "
 db "Ce programme a ‚t‚ r‚alis‚ par "
 db "ArlŠne DUBIEF, S‚bastien MERCIER, et Micka‰l POINTIER.    "
 db "--- ½ 1994 Nous du groupe 3A-licence info ! ---   "
 db "              "
 db "Ce programme consiste en une simulation simplifi‚e de notre "
 db "systŠme solaire, et ce, dans le cadre d'un projet de programmation "
 db "en assembleur INTEL 80x86. "
 db "              "
 db "Si vous pouvez lire ce texte, c'est que vous disposez au minimum "
 db "d'un ordinateur de type 80386 ‚quip‚ d'une carte VGA disposant "
 db "de 256ko de m‚moire vid‚o. "
 db "Il est possible que l'animation soit saccad‚e, mais un simple "
 db "486 SX cadenc‚ … 25 Mhz suffit pour obtenir une animation fluide. "
 db "Par ailleur, le fait de poss‚der un ordinateur plus rapide ne "
 db "changera rien … l'animation, car celle-ci est synchronis‚e avec le "
 db "balayage ‚cran (normalement 70hz pour la fr‚quence verticale) ce qui "
 db "fait que l'animation ®tournera¯ … 70 images/seconde au maximum...    "
 db "Aucune partie de ce code ne provient directement d'un livre ou d'un "
 db "source assembleur ext‚rieur. Tout au plus y'a t-il parfois une "
 db "utilisation des informations qui s'y trouvaient concernant l'adressage "
 db "des ports d'entr‚e sortie et la structure de la m‚moire vid‚o. "
 db "              "
 db "              "
 db "BIBLIOGRAPHIE:      "
 db "®Programmer en Langage Machine sur PC, Editions Micro Application¯ "
 db "(bon ouvrage pour d‚buter, explications claires, mais beaucoup d'erreurs "
 db "qui rendent parfois le sens initial du contenu assez obscur ! Contient "
 db "une description des instructions sp‚cifiques aux 386 et 486) - "
 db "®La Bible PC, Editions Micro Application¯ "
 db "(On trouve tout sur tout, mais on y trouve encore plus d'erreurs que dans "
 db "le pr‚c‚dent, et les explications sont parfois moins claires qu'un arrˆt "
 db "rendu par la cour de cassation. N‚anmoins indispensable) - "
 db "®Assembleur facile, Editions Marabout¯ "
 db "(Petit format, contenu compact, trŠs didactique, beaucoup d'exemples. "
 db "C'est le type mˆme du livre utile pour le d‚butant. Dommage qu'il ne se "
 db "limite qu'au processeur 8086/88) - "
 db "®Guide Microsoft de la programmation des cartes graphiques¯ "
 db "(TrŠs gros pav‚, index totalement nul, une masse d'informations assez "
 db "confuse, truff‚ de petits cadres 'ASTUCE:' qui ne servent g‚n‚ralement "
 db "qu'… vous pr‚venir que le listing que vous venez de saisir ne tournera "
 db "peut-ˆtre pas sur telle machine pour telle raison... TrŠs frustrant. De "
 db "plus les commentaires sur les manipulations vid‚o sont g‚n‚ralement aussi "
 db "clairs que ceux que l'on trouve dans la bible, et parfois pire !) - "
 db "®Micro Memento Programmeur PC, Editions P.S.I.¯ "
 db "(Petit format, contient l'essentiel sur les interruptions, les registres "
 db "modifi‚s, les tables de vecteurs, etc. Incomplet, mais pr‚cis: fiable) - "
 db "              "
 db "Remerciements …: Mathieux et Rapha‰l pour les informations sur le mode X, "
 db "Eric Vialas pour la Bible et le Guide des cartes graphiques. "
 db "[  Rules !!!  ½ DáæÛ / ïîÂç ...]              "
 db "Have a nice day !!!......... ..... ... .. . . . .        "
 db "                                              "
 db "                                              "
 db "                                              "
 db " ",0
