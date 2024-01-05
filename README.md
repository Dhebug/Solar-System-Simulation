# Solar-System-Simulation
This is the source code of a basic solar system simulation written in 80386 assembler as a part of my Bachelor degree from around 1992/1993.

# How to build
This program was designed to build with the DOS version of TASM/TLINK.
The content of the OBJ folder should not be deleted, these OBJ files contain assets designed to be linked with them main program.

What follows is a "markdownified" version of the original document we provided alongside the project.

# Original documentation
Projet en assembleur 80386: Simulation de système solaire

DUBIEF Arlène
MERCIER Sébastien
POINTIER Mickaël


# Dossier Utilisateur :
## Comment exécuter le programme :


Pour pouvoir utiliser ce programme, il suffit de se metttre sous le système MS-DOS et de taper les commandes suivantes :

    A: [enter]
    MAIN [enter]
   

		
# Utilisation du programme:

Une présentation s'effectue. Les logos de la Faculté des Sciences et des Techniques de Besançon sont affichés successivement. Pour éviter cet affichage vous pouvez appuyer sur une touche quelconque du clavier. 
L'image de la planète Saturne apparait, puis le système solaire 'simplifié'.
Pour sélectionner une planète ou le soleil, il suffit d'appuyer sur les touches suivantes :

    [Flèche gauche] pour la planète suivante,
    [Flèche droite] pour la planète précédente.

Le nom de la planète s'affiche à l'écran. Au départ la planète sélectionnée est le soleil.
Pour obtenir les informations la concernant, il faut appuyer sur la touche [enter]. Pour revenir au système solaire, il faut appuyer sur une touche quelconque.
Pour quitter le programme, il faut appuyer sur la barre [espace].
Si l'utilisateur appuye sur une autre touche que celle précédemment citées, un texte d'aide s'affiche.

# Dossier Programmeur:

## Choix techniques:

Pour que la réalisation de ce projet soit efficace, il était nécéssaire de disposer d'instructions puissantes, et d'un mode vidéo correct. C'est pour cette raison que ce programme ne fonctionne que sur une machine disposant au moins d'un processeur de type 80386 (ou compatible) ainsi que d'une carte VGA équipée de 256ko de mémoire vidéo. Cette configuration minimale permet de faire fonctionner le programme sans aucun problème, mais on ne disposera d'une animation rapide et fluide qu'à partir d'un processeur 80486 SX. De même, le fait de posséder une carte graphique de type «local bus» accélère considérablement le programme, puisque celle-ci fait usage d'instructions de transferts de 32 bits.

## Intérêt de la programmation en code assembleur 80386:

Le 80386 est un processeur dérivant des 8088/8086 (8 bits), 80186 (8/16 bits), et 80286 (16 bits). A ce titre, il bénéficie d'une compatibilité ascendante avec ceux-ci. Mais il apporte de nombreuses améliorations, qui se traduisent par une performance accrue (micro-programmation optimisée, pipeline d'instruction plus grand, etc...), mais surtout par l'apport de nombreuses fonctions et caractéristiques qui simplifient grandement la tâche du programmeur. En particulier, notre programme utilise:

- Les registres 32 bits.
Les processeurs INTEL disposent de 4 registres généraux 16 bits dénommés AX,BX,CX et DX, qui sont subdivisés en registres 8 bits (AX:AH/AL, BX:BH/BL, CX:CH/CL, DX:DH/DL). Le 80386 augmente leur capacité en apportant 16 bits supplémentaires. On dispose ainsi des registres EAX, EBX, ECX, EDX qui permettent de stocker des valeurs 32 bits. Il est toujours possible d'adresser directement les 16 bits inférieurs. (NOTA: Il n'est malheureusement pas possible d'accéder aux 16 bits supérieurs du registre directement. Il est donc indispensable de passer par une instruction de décallage/rotation telle que ROR EAX,16 si l'on souhaite lire le mot de poids fort.) Cette extension 32 bits a été aussi apportée aux registres d'index SI et DI qui deviennent respectivement ESI et EDI.
Dans ce programme, les registres 32 bits ont deux usages particuliers. D'une part, ils nous permettent d'effectuer des calculs mathématiques avec des nombres non entiers, qui sont représentés en virgule fixe. Les 16 bits inférieurs représentent la partie décimale, tandis que les 16 bits supérieurs représentent la partie entière du nombre. On dispose donc d'une amplitude de +/- 32767 pour stocker les nombres, ainsi que d'une précision de 2-16, ce qui est largement suffisant dans le cadre d'un calcul en coordonnées écran. Néanmoins, cette précision est indispensable car elle permet d'effectuer de nombreux calculs successifs sans que les arrondis ne provoquent d'erreurs perceptibles. D'autre part, ils permettent d'effectuer des calculs sur 16 bits, mais en non signé. Pour ce faire, il suffit de faire une addition 32 bits dont le mot de poids fort est nul. Cette caractéristique est intéressante, car lorsque l'on fait des calculs de positionnement mémoire (calculs d'offsets et de segments) on ne travaille pas avec des valeurs signées.

- Les registres de segment supplémentaires.
Ce programme est assemblé en modèle compact. Cela signifie qu'il ne contient qu'un seul segment de code (pointé par CS), mais qu'il dispose de plusieurs segments de données. Or le segment de donnée par défaut est pointé par DS, et il ne reste qu'un seul autre registre de segment sur les microprocesseurs antérieurs au 80386: ES. Dans notre cas, vu que nous passont beaucoup de temps à accéder à la mémoire écran (Zone de 64ko située au segment $A000) le registre ES pointe sur cette zone. Pourtant, lorsque nous devons inscrire un texte, nous avons besoin d'un pointeur sur ce texte, d'un pointeur sur l'écran, et d'un pointeur sur la police de caractères. Vu que la somme de tous le graphismes, textes et autres données dépasse «allègrement» 100ko, il n'est pas possible d'avoir qu'un seul segment de donnée pour le texte et la police.

- Les instructions 32 bits.
Ce programme utilise beaucoup d'instructions étendues, telles que PUSHA et POPA (apparues sur le 80286), MOVSX et MOVZX, LODSD et STOSD... qui n'existent pas sur les processeurs 8088/86. Elles permettent de clarifier le code, et le rendent plus compact.  Par ailleurs, l'utilisation des instructions de copie de chaîne en mode 32 bits, permet de travailler plus efficacement puisque cela accélère les effacements d'écran et autres traçages graphiques.


## Structure du programme:

Ce programme est composé de 4 parties principales:
- Une présentation qui affiche les logos des différentes disciplines de l'université de Besançon.
- L'affichage d'une image représentant la planète Saturne.
- Une animation simplifiée représentant les différentes parties du système solaire terrien.
- Un affichage «encyclopédique» fournissant quelques informations de base sur un des astres sélectionnés.

Pour des raisons de rapidité et de simplicité, le programme n'utilise pas de variables locales. Toutes les variables sont globales, il n'est donc pas nécéssaire d'effectuer une gestion de passage de paramètres par la pile. Ceci n'est pas important, car aucune partie de ce programme n'est destinée à être intégrée par la suite dans un langage de plus haut niveau.


## La présentation:

La présentation est affichée en mode VGA 320x200 en 256 couleurs. Dans ce mode, 1 octet de la mémoire  vidéo correspond directement à un pixel. Les manipulations vidéo sont donc très simple. Une ligne occupe 320 octets, l'écran prend 64000 octets.
Le fond dégradé vert, est affiché par la procédure PREPARE_ECRAN. Cet affichage utilise les couleurs 1 à 100 pour créer un motif de 2 pixels d'épaisseur. Un changement de palette donnera l'illusion d'un dégradé uni. La séquence d'animation est définie par un «script» qui contient la liste des images à afficher, ainsi que la palette de couleur correspondante. Avant d'afficher chaque image, on valide une palette de couleur identique à celle du fonds, mais ceci pour les couleurs 128 à 228, qui servent à l'affichage en dégradé des images. Ainsi, on ne voit pas le traçage se réaliser, et l'image ne devient visible qu'une fois le fondu de couleur entamé.
C'est la procédure AFFICHE_INTRO qui affiche chaque image. On lui passe en DS:SI l'adresse de l'image mémorisée dans un format compacté (Cette méthode de compactage a été utilisée pour la première fois dans une démonstration sur un ordinateur ATARIä, et reste la propriété exclusive du groupe NeXT.). Chaque image est décomposée en segments horizontaux, et chaque segment est mémorisé sous la forme [X1][X2][Y]. Il ne reste plus qu'à tracer ces segments à l'écran pour obtenir l'image initiale. Néanmoins, pour des raisons d'efficacité, On utilisera 3 octets pour mémoriser un segment. Mais, vu qu'un octet ne permet pas de stocker un nombre supérieur à 255, il faut 9 bits pour mémoriser une coordonnée écran sur l'intervalle [0,319]. Donc, on récupera ce bit supplémentaire sur l'octet destiné à [Y]... Mais il ne reste plus que 6 bits [0-63], pour mémoriser Y. On peut donc se servir de Y, non comme une position absolue, mais comme une position relative au segment precédent. La seule contrainte est que deux segments ne peuvent être séparés par plus de 63 lignes. Le codage final est donc celui-ci:

    octet 1: [x1/x1/x1/x1/x1/x1/x1/x1]	Les 8 bits supérieurs de X1.
    octet 2: [x2/x2/x2/x2/x2/x2/x2/x2]	Les 8 bits supérieurs de X2.
    octet 3: [yo/yo/yo/yo/yo/yo/x2/x1]	Les 6 bits de Yoffset, le bit de poids faible de x2, et de x1.

La séquence d'instructions SAR ax,1  .... ADC bx,bx  permet de récupérer le bit manquant dans BX.

Une temporisation est effectuée, pour laisser le temps de voir l'image. C'est la procédure TEMPORISE qui s'en charge.


## L'affichage de l'image.

Cette image représente Saturne. Elle est affichée dans le même mode écran que précédement. La méthode de compactage utilisée n'est pas la même. Elle est basée sur le fait qu'une grande partie des pixels de l'image sont noirs. L'image est donc compactée sur un principe de type RLE (Run Lenght Encoding) adapté spécifiquement à cette image. (En clair, cela signifie que si l'on change l'image, il est probable qu'elle prendra plus de place une fois compactée !). Principe: On lit un mot N. Si N est nul, c'est que l'on a terminé le compactage. Si N est positif, cela signifie qu'il faut recopier les N octets suivants. Si N est négatif, cela signifie qu'il faut écrire -N pixels noirs. Cet algorithme est EXTREMEMENT rapide, puisqu'il a été implémenté de manière à n'utiliser que les directives de traitement de chaîne et un minimum de tests.


## L'affichage des planètes.

Le module d'affichage des planètes est animé. Pour effectuer une animation correcte, il n'est pas possible de travailler sur une seule page écran. Mais pour disposer de plusieurs page écran, on doit recourir au mode X, qui est un mode entrelacé utilisant 4 plans de pixels. Ce mode permet d'accéder à la totalité des 256ko de la mémoire vidéo, et ce grâce à l'utilisation de 4 registres latch qui déterminent quels sont les plans de pixels qui seront affectés par une opération de transfert vidéo. De plus, on dispose donc de 4 pages graphiques si l'on travaille en mode 320x200. Nous avons choisi d'augmenter la résolution graphique, et donc nous disposons de 2 pages graphiques dans un mode 320x400. Ce mode graphique ne peut-être utilisé en passant par les fonctions 10h du BIOS. Il est nécéssaire de passer directement par les registres de la carte vidéo. Néanmoins, ce mode vidéo est reconnu par toutes les cartes VGA standard.


## La carte VGA:

L'adresse de la mémoire écran est en $A000. Et l'espace adressable est de 64ko.

### Ports utilisés:

3DA: Input Status Register 1. Le bit 8 indique s'il est égal à 0, que le faisceau de balayage est sur le chemin du retour. On peut profiter de ce moment pour effectuer les bidouilles graphiques telles que changement de palette ou modification des registres vidéo.

3C4: Data Register Select.
3C5: Data Register Valid. On inscrit en 3C4 le numéro d'un registre à modifier, et on met en 3C5 la valeur à y inscrire. Cela peut ce faire en une seule opération, en faisant MOV dx,3c4h ...  MOV ax,Valeur/Registre ... OUT dx,ax. En particulier, le registre numéro 2 est utilisé pour décider quels sont les plans de pixel à sélectionner. Le paramètre réclamé est un masque de 4 bits. Si un bit est à 1, le plan de pixel est sélectionné, sinon il ne l'est pas.

3D4: Data Register Select 2.
3C5: Data Register Valide 2. Même principe que précédement, on s'en sert entre autre pour passer en mode X, et pour changer l'adresse de base de l'écran.

### Structure écran:

Espace adressable (64 ko)		Registres latch		Plan numéro 1 (64 ko)
					Registres latch		Plan numéro 2 (64 ko)
					Registres latch		Plan numéro 3 (64 ko)
					Registres latch		Plan numéro 4 (64 ko)

Le plan numéro 1 mémorise les pixels numéro 0,4,8,12,16,20,...
Le plan numéro 2 mémorise les pixels numéro 1,5,9,13,17,21,...
Le plan numéro 3 mémorise les pixels numéro 2,6,10,14,18,22,...
Le plan numéro 4 mémorise les pixels numéro 3,7,11,15,19,23,...

Cette organisation est intéressante lorsque l'on souhaite adresser tous les pixels simultanément (effacement de l'écran...), car il suffit de valider chaque plan, et dès lors, tout octet écrit dans l'espace adressable sera recopié dans les 4 pixels correspondant. Pourtant, dès lors que l'on désire adresser un pixel en particulier, il est nécéssaire de calculer sa position, de savoir dans quel plan il se trouve, de valider les registres latch pour n'activer  que le plan correspondant, et enfin de tracer le pixel. Pour cette raison, le traçage des planètes est effectué verticalement, car il suffit d'effectuer le calcul de positionnement horizontal qu'une seule fois pour chaque segment vertical à tracer.


## Calculs de positionnement des planètes:

Pour chaque planète, nous disposons de diverses informations, telles que son diamètre,  son éloignement par rapport au soleil, sa vitesse de rotation, sa position courante. A chaque nouveau calcul, nous dupliquons ces informations dans un tableau qui sera ensuite trié sur la profondeur des planètes. (Algorithme du tri à bulle) Lors de ce calcul, la position courante de la planète est mise à jour, et on effectue une transformation polaire/rectangulaire, pour obtenir des coordonnées écran à partir des coordonnées 'spatiales'. Une fois le tri effectué, les planètes sont affichées de la plus lointaine vers la plus proche, ce qui résoud les problèmes de 'clipping'.

### La transformations polaire/rectangulaire:

Nous utilisons une table précalculée (avec le Qbasic), contenant les valeurs des Cosinus, de 0 à 359 (+90) degrés (avec une précision d'1/4 de degré). Cette table permet d'obtenir la table des Sinus, il suffit d'utiliser la table des Cosinus en rajoutant un décalage de 90°.
Les valeurs de cette table sont multipliées par 65536, afin d'obtenir des valeurs numériques codées sur 16 bits. Nous prenons donc l'angle courant de la planète, cet angle est multiplié par 2, ce qui sert d'index sur la table des Cosinus. (Une valeur 16 bits occupe deux octets). Cette valeur est ensuite multipliée par la distance qui sépare la planète du soleil. Le calcul complet donne finalement:

x_ecran=160+distance_soleil*[table_cosinus+angle*2]
y_ecran=200+distance_soleil*[table_cosinus+angle*2+90*2]

avec (160,200) le centre de l'écran en mode VGA 320x400, et 90*2 étant l'offset qui permet d'obtenir un Sinus.

Ces calculs sont intégralement réalisés avec des registres 32 bits, et utilisent le système de calcul en virgule fixe. La coordonnée écran finale est précise d'un ordre de 2-16 (0,000015258...).


### Le traçage des planètes:

Les planètes sont représentés par des disques. La méthode utilisée est la génération de circonférence de Bresenham. La routine calcule sur un quadrant, et les autres valeurs sont obtenues par symétrie. Au traçage, une déformation est appliquée afin d'obtenir une equation d'ellipse. En effet, en mode 320x400, les VRAIS cercles ressemblent à des «patatoïdes» très inesthétiques. Le calcul utilise au maximum les registres, et le traçage lui même a été optimisé pour le mode graphique utilisé.


## Palettes et fondus de couleur:

Tous les effets d'apparition et de disparition font appel aux routines envoie_palette, prepare_fondu et execute_fondu. Les palettes sont des ensembles de triplets de couleurs Rouge Vert Bleu. Une palette contenant 256 couleurs, elle occupe 256x3=768 octets. Pour changer la palette, nous passons directement par le DAC (processeur vidéo dédié à l'affichage), ce qui assure une vitesse maximale de transfert. Tout changement de palette doit être synchronisé avec le balayage écran (utilisation de vsync) , sous peine de voir de «la neige» sur l'écran (matérialisée par l'apparition de pixels clignotants, scintillants et miroitants...).
Les fondus sont générés à partir de deux palettes. La palette source est passée en paramètre dans DS:SI, et la palette destination dans DS:DI. Pour chaque composante de chaque couleur on calcule la différence entre la palette source et la palette destination. Cette différence est signée. En divisant par 64, on obtient un chiffre décimal compris entre -1 et 1.  Cet offset est stoqué dans un tableau intermédiaire en représentation à virgule fixe 32 bits. Chaque fois que l'on appelle execute_fondu, ces offsets sont appliqués sur la palette courante, qui finit par correspondre à la palette destination.

### exemple:
Pour passer du Rouge (63,0,0) au Noir (0,0,0), en 64 phases, on obtient les incréments:
(-1 / 0 / 0)
[Ici, seul le rouge sera modifié, on lui enlevera "1" à chaque phase du fondu.]

Pour passer du Orange (63,32,0) au Bleu ciel (0,32,63), on obtient les valeurs:
(-1 / 0 /1)
[Tandis que le rouge diminue, le bleu augmente.]

Pour passer du Vert Kaki (17,35,5) au Rose Pale (60,50,47), on obtient les valeurs:
(0,671875 / 0,234375 / 0,65625)
[Ces valeurs sont difficilement représentable par des entiers. D'où l'utilité du calcul en virgule fixe.]


## Les textes:

Toutes les polices de caractères sont stoquées sous une forme spécialement prévue pour l'assembleur. Tous les caractères sont mémorisés les un à la suite des autres, et donc on accède directement au nème caractère en pointant sur le (n*taille_d_un_caractère) octet de la police. La police 8x8 utilisée dans la partie «encyclopédique» et dans le texte qui défille en bas de l'écran principal contient la totalité des caractères ASCII. Chaque caractère occupe 64 octets (8x8), et donc on accède à la lettre 'A', en multipliant le code ASCII de 'A' (65) par 64. Cette opération peut-être effectuée rapidement grâce au décallage logique de 6 positions vers la gauche (26=64). La police utilisée pour afficher le nom des planètes est incomplète. On y trouve que les lettres majuscules, ainsi que l'espace. Il faut donc soustraire 65 du code ASCII de la lettre à afficher pour obtenir le numéro correspondant dans la police. Il n'est pas possible d'accéder à une lettre en faisant un simple décallage à gauche, car les lettres font 32x33 pixels (La police a été réalisée par un graphiste inconnu...), ce qui nous oblige:
1) A sacrifier une ligne de pixels pour la transformer en une sympathique police 32x32...
2) A faire des multiplications par 1056, au lieu de décaller de 10bits vers la gauche...
La solution 2) a été retenue... 
L'affichage des lettres est fait verticalement, pour eviter les manipulations inutiles au niveau de la sélection des plans de pixels.

Le défillement du texte est obtenu en décallant un petit buffer de 320x8 octets d'un octet vers la gauche. A chaque défillement, on met à jour les 8 pixels de droite du buffer en faisant «rentrer» les nouvelles lettres au fur et à mesure. Tous les 8 pixels, on passe à un nouveau caractère.


## Le titre:

Le titre est un gros bloc bitmap de 320x47 pixels. Il est écrit une fois au début de l'animation sur les 2 pages écran.  Evidement, l'effacement de l'animation a été calculé pour n'effacer que la partie animée.



## Principe de l'animation en «double buffer»:

Pour obtenir une animation «propre» , il est nécéssaire d'utiliser deux écrans. L'écran physique est  affiché sur le moniteur, tandis que l'écran logique est mis à jour. Une fois que la mise à jour est terminée (texte écrit, planètes affichées, etc...),  l'écran logique et l'écran physique sont interchangés. Il est nécéssaire de se synchroniser avec le balayage vidéo pour que cette opération se déroule sans accros.
Ce programme utilise une «astuce» qui consiste à faire redémarrer les compteurs vidéo à l'adresse zéro lorsqu'une certaine ligne de l'écran a été atteinte. Par ce moyen, nous pouvons afficher n'importe quel image fixe, ou texte défillant pendant une animation principale, sans se soucier des effets de bord, ou de clipping.


## Programmation du haut parleur:

Pour programmer le haut parleur, il suffit de donner une fréquence (un mot), que l'on affecte à deux registres. Ensuite, deux bits contrôlent l'activité ou l'inactivité du haut-parleur.

## Routines diverses:

Les attentes de touche sont réalisées par l'interruption 16h du bios. Cette fonction est plus intéressante que les fonctions 21h, car:
- Elles n'affichent pas le caractère saisi.
- Elles ne peuvent pas être interrompues par CTRL C ou par BREAK.
- Elles prennent moins de temps machine.
Une procedure vide_buffer a été implémenté afin d'éviter les sélections intempestives. Avant chaque attente de touche, le buffer clavier est ainsi purgé.

La détection processeur est basée sur les différences de fonctionnement de l'instruction PUSHF. Sur 8088/86, les 4 bits de poinds fort du registre d'état sont positionnés à 1, tandis que sur 80286 il sont effacés. Sur les 80386/486 et suivants, ces bits ne sont pas modifiés.
