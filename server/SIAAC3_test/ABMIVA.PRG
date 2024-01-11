SELE 1
USE IVA


DO WHILE .T.
     CLEAR
     DO TITULO
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     @ 1,0 TO 23,79 DOUBLE
     SET COLOR TO I
     @  2,32 SAY 'ABM de IVA'
     SET COLOR TO
     M_IVA = IVA
     M_ADIC = ADIC
     @ 5,2 SAY 'Porcentaje de Iva               : ' GET M_IVA  PICT '###.##'
     @ 7,2 SAY 'Adicional de Iva                : ' GET M_ADIC PICT '###.##'
     READ
     IF LASTKEY() = 27
         EXIT
     ENDIF
     IF APRUEBA(24,0,2)
           REPLACE IVA WITH M_IVA
           REPLACE ADIC WITH M_ADIC
     ENDIF
ENDDO
CLOSE ALL
RETURN
