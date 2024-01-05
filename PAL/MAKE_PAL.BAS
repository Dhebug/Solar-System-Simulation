'
' La palette qui affiche tout en vert
'
PRINT "Palette d'introduction"
OPEN "o", #1, "intro.pal"
GOSUB DebutPalette
FOR i = 0 TO 99
  c = INT(63 - 63 * i / 100)
  PRINT #1, CHR$(c); CHR$(63); CHR$(c);
NEXT i
GOSUB FinPalette
CLOSE #1
'
' JAUNE -> ROUGE
'
PRINT "Palette jaune"
OPEN "o", #1, "jaune.pal"
GOSUB DebutPalette
FOR i = 0 TO 99
  c = INT(63 - 63 * i / 100)
  PRINT #1, CHR$(63); CHR$(c); CHR$(0);
NEXT i
GOSUB FinPalette
CLOSE #1
'
' VIOLET -> BLEU
'
PRINT "Palette violette"
OPEN "o", #1, "violet.pal"
GOSUB DebutPalette
FOR i = 0 TO 99
  c = INT(63 - 63 * i / 100)
  PRINT #1, CHR$(c); CHR$(0); CHR$(63);
NEXT i
GOSUB FinPalette
CLOSE #1
'
' TOUT en noir !
'
PRINT "Palette noire"
OPEN "o", #1, "noire.pal"
FOR i = 0 TO 255
  PRINT #1, CHR$(0); CHR$(0); CHR$(0);
NEXT i
CLOSE #1
'
END


FinPalette:
  FOR i = 0 TO 27
    PRINT #1, CHR$(0); CHR$(0); CHR$(0);
  NEXT i
RETURN

DebutPalette:
  PRINT #1, CHR$(0); CHR$(0); CHR$(0);      ' Met la couleur de la bordure en noir
  FOR i = 0 TO 99
    c = INT(63 - 63 * i / 100)
    PRINT #1, CHR$(c); CHR$(63); CHR$(c);
  NEXT i
  FOR i = 0 TO 26
    PRINT #1, CHR$(0); CHR$(0); CHR$(0);
  NEXT i
RETURN



