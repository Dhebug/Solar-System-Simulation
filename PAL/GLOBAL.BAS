RESTORE
CLS
OPEN "o", #1, "global.pal"
DO
  READ nom$
  IF nom$ <> "*" THEN
    PRINT nom$
    OPEN "i", #2, nom$
      PRINT LOF(2)
      a$ = INPUT$(700, 2)
      'PRINT #1, CHR$(col);
    CLOSE #2
  END IF
LOOP UNTIL nom$ = "*"
CLOSE #1

END

DATA "image.pal"
DATA "intro.pal"
DATA "jaune.pal"
DATA "violet.pal"
DATA "noire.pal