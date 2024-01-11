*Consulta de Acumulados de Ventas

*IF !SEGURIDAD(MM_CLAVE,'T')
*     DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*     ESPERAR(0)
*     RETURN
*ENDIF

SELE 14
USE ACUMULA INDEX ACUMULA

SELE 15
USE ACUMULA2 INDEX ACUMULA2

R5 = .F.

DO WHILE .T.
   CLEAR
   DO TITULO
   @ 1,0 TO 23,79 DOUBLE
   IF R5
      @ 23,79 SAY '.'
   ENDIF
   SET COLOR TO I
   @ 3,20 SAY ' * CONSULTA DE ACUMULADOS DE VENTAS * '
   SET COLOR TO
   @ 10,2 TO 17,78
   M_DESDE = DATE()
   M_HASTA = DATE()
   @ 13,5 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
   @ 13,50 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
   ESPERAR(0)
   IF LASTKEY() = 220
      IF !R5
         ?? CHR(7)
         @ 23,79 SAY '.'
         R5 = .T.
      ELSE
         @ 1,0 TO 23,79 DOUBLE
         R5 = .F.
      ENDIF
   ENDIF
   IF LASTKEY() = 27
      EXIT
   ENDIF
   READ
   IF LASTKEY() = 27
      EXIT
   ENDIF
   IF R5
      SELE 15
   ELSE
      SELE 14
   ENDIF
   GO TOP
   M_COMPRO = 0
   M_ACUM = 0
   IMPRE = .F.
   IF APRUEBA(24,0,11)
      SET DEVICE TO PRINT
      IMPRE = .T.
   ENDIF
   DO WHILE !EOF()
      IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA
*        M_COMPRO = M_COMPRO + CANT_COMPR
         M_ACUM = M_ACUM + ACUMULADO
         SKIP
      ELSE
         SKIP
      ENDIF
   ENDDO
   DO TITULO
   IF IMPRE
      @ 3,15 SAY CHR(14) + ' * ACUMULADO de VENTAS * '
      @ 5,3 SAY 'Desde Fecha: ' + CTOD(M_DESDE)
      @ 7,3 SAY 'Hasta Fecha: ' + CTOD(M_HASTA)
   ELSE
      CLEAR
      DO TITULO
      @ 1,0 TO 23,79
      @ 3,25 SAY  ' * ACUMULADO de VENTAS * '
      @ 5,3 SAY 'Desde Fecha: ' + DTOC(M_DESDE)
      @ 7,3 SAY 'Hasta Fecha: ' + DTOC(M_HASTA)
   ENDIF
   @ 10,3 SAY 'Total de Ventas                : ' + STR(M_ACUM,12,2)
*  @ 12,3 SAY 'Total de Comprobantes Emitidos : ' + STR(M_COMPRO,6,0)
   IF !IMPRE
      DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
      ESPERAR(0)
   ELSE
      EJECT
      SET DEVICE TO SCREEN
   ENDIF
ENDDO
CLOSE ALL
RETURN
