*******************************************************************************
*FACAUTO.PRG
*
*Facturacion Automatica de Remitos
*
*******************************************************************************


*IF !SEGURIDAD(MM_CLAVE,'U')
*     DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*     ESPERAR(0)
*     RETURN
*ENDIF

SELE 2
USE ARTIC INDEX ARTIC

SELE 4
USE COMPRO1 INDEX COMPRO1

SELE 5
USE DETALLE1 INDEX DETALLE1

SELE 7
USE AUXILI2 INDEX AUXILI2

SELE 6
USE AUXILI3 INDEX AUXILI3

SELE 9
USE VENDEDOR INDEX VENDEDOR

SELE 11
USE CLIENTES INDEX CLIENTES

SELE 13
USE CONTADO1 INDEX CONTADO1

SELE 14
USE ACUM INDEX ACUM

SELE 15
USE AUXILI4 INDEX AUXILI4

SELE 18
USE CONT2 INDEX CONT2

DO WHILE .T.
     CLEAR
     DO TITULO
     DO PANT_CONS
     DO PIDE_FAUT
     IF LASTKEY() = 27
        EXIT
     ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE PIDE_FAUT
*******************

*Pide Datos Para Consulta

DECLARE V_COMPRO[1]
V_COMPRO[1] = 'REMITO'

DECLARE COD_COMP[1]
COD_COMP[1]='REM'


DECLARE V_ARTI[21]
DECLARE V_CANTIDAD[21]
DECLARE V_PRECIO[21]
DECLARE V_TOTAL[21]
DECLARE FACTURA[21]
DECLARE IMPORTE[21]
DECLARE COMP_REC[21]
DECLARE V_DESCUEN[21]
DECLARE VALOR[21]
DECLARE V_CANTAUX[21]
DECLARE REMI[200]


R5 = .F.
M_TOTPAR = 0
SAVE SCREEN TO M_PAUX
DO WHILE .T.
      IF !R5
         @ 1,0 TO 23,79 DOUBLE
      ELSE
         @ 1,0 TO 23,79 DOUBLE
         @ 23,79 SAY '.'
      ENDIF
      RESTORE SCREEN FROM M_PAUX
      M_NUM = SELE_REM()
      IF M_NUM = 0
           EXIT
      ENDIF
      M_COMPRO = 'REM'
      IF !FOUND()
           DO M_CARTEL WITH 31,24,0,.T.,.T.,.T.
           ESPERAR(0)
           @ 24,0 SAY SPACE(79)
      ELSE
           M_CLIENTE = CLIENTE
           TOTALF = TOTAL
           SELE 11
           SEEK M_CLIENTE
           SET COLOR TO I
           @ 3,28 SAY SUBSTR(NOMBRE,1,20)
           SET COLOR TO
           IF R5
              SELE 7
           ELSE
              SELE 4
           ENDIF
           @ 6,60 SAY FECHA
           M_FRASE = FRASE
           M_DESCU= BONIF
           M_NROREM = NUMERO
           M_BONIF = (TOTAL + IVA + REC_IVA) * M_DESCU / 100
           M_P = 100
           M_NROREM = NROREM
           M_CONDP = CONDP
           DO BLANQ_VEC WITH .T.
           DO CARGA_VEC
           DO MUESTRA
           DO PANT_TOT
           REMITO = .F.
           @ 24,0 SAY SPACE(79)
           IF APRUEBA(24,0,21)
                        IF !R5
                           SELE 13
                           SEEK 'FAC'
                        ELSE
                           SELE 18
                           SEEK 'FAC'
                        ENDIF
                        NUMCOMP = NUMERO
                        IF R5
                           SELE 7
                        ELSE
                           SELE 4
                        ENDIF
                        ADIC = REC_IVA
                        M_IVA = IVA
                        TOTALF = TOTAL
                        TOTNETO = TOTALF + ADIC + M_IVA - M_BONIF
                        M_OC = O_C
                        M_PREDOLAR = COTIZA
                        M_FECH = FECHA
                        IF COTIZA <> 0
                           MENSAJE = .T.
                        ELSE
                           MENSAJE = .F.
                        ENDIF
                        COPIAS = 1
                        M_TIPOC = 1
                        M_COMPRO = 'FAC'
                        C = 1
                        CONTADO = .F.
                        M_VENDEDOR = CAJERO
                        DOLAR = .T.
                        M_COTIZA = COTIZA
                        V_COMPRO[1] = 'FACTURA'
                        COD_COMP[1]='FAC'
                        M_FACTU = .T.
                        IF APRUEBA(24,0,49)
                            DO IMPRIME
                        ENDIF
                        DO GRAB_ARCHI
                        IF !R5
                            SELE 4
                        ELSE
                            SELE 7
                        ENDIF
                        SEEK 'REM' + STR(M_NUM,5,0)
                        REPLACE FACTURADO WITH .T.
           ENDIF
      ENDIF
ENDDO
CLOSE ALL
RETURN


FUNCTION SELE_REM
*****************
*Selecciona Remitos a Facturar
ESPERAR(0)
IF LASTKEY() = 27
     RETURN(0)
ENDIF

IF LASTKEY() = 106
      IF R5
         R5 = .F.
      ELSE
         ?? CHR(7)
         @ 23,79 SAY '.'
         R5 = .T.
      ENDIF
ENDIF

FOR I = 1 TO 200
    REMI[I] = ''
NEXT

IF !R5
    SELE 4
    ARCHIVO = 'COMPRO1'
ELSE
    SELE 7
    ARCHIVO = 'AUXILI2'
ENDIF
GO TOP
I = 0
DO WHILE !EOF()
    IF TIPO = 'REM' .AND. !FACTURADO .AND. !ANULADA
         I = I + 1
         SELE 11
         SEEK &ARCHIVO->CLIENTE
         IF !R5
            SELE 4
         ELSE
            SELE 7
         ENDIF
         REMI[I] = STR(NUMERO,5,0) + ' ' + SUBSTR(CLIENTES->NOMBRE,1,20)
    ENDIF
    SKIP
ENDDO
IF I = 0
   DO M_CARTEL WITH 61,24,0,.T.,.T.,.T.
   ESPERAR(0)
   RETURN(0)
ENDIF

DECLARE REMI2[I]
FOR A = 1 TO I
    REMI2[A] = REMI[A]
NEXT

SAVE SCREEN TO M_PANTA
IF R5
   @ 23,79 SAY '.'
ELSE
   @ 1,0 TO 23,79 DOUBLE
ENDIF
C = VENTOPCION('REMITOS PENDIENTES DE FACTURACION',REMI2,10,30,20,.T.,.T.,1)
IF LASTKEY() = 27
     RETURN(0)
ENDIF

RESTORE SCREEN FROM M_PANTA
@ 2,28 SAY SPACE(30)
SET COLOR TO I
@ 2,28 SAY 'REMITO'
SET COLOR TO
M_NUM = VAL(SUBSTR(REMI2[C],1,5))
IF R5
   SELE 7
ELSE
   SELE 4
ENDIF
SEEK 'REM' + STR(M_NUM,5,0)
RETURN(M_NUM)
