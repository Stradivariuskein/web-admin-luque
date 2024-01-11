*AJUSTE de SALDOS en LA CUENTA CORRIENTE
*******************************************************************************

SELE 11
USE CLIENTES INDEX CLIENTES

SELE 4
USE COMPRO1 INDEX COMPRO1,COMPRO2
SET ORDER TO 1

SELE 12
USE DOLAR INDEX DOLAR
SEEK M_FECHA

SELE 13
USE CONTADO1 INDEX CONTADO1

R5 = .F.
M_CLIENTE = SPACE(10)
DO WHILE .T.
   CLEAR
   DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
   @ 1,0 TO 23,79 DOUBLE
   DO TITULO
   SET COLOR TO I
   @ 3,30 SAY 'AJUSTE de SALDOS de CUENTAS CORRIENTES'
   SET COLOR TO
   @ 5,1 TO 5,78
   DO WHILE .T.
      SELE 11
      @ 8,3 SAY 'Codigo de Cliente : ' GET M_CLIENTE PICT '@!'
      READ
      IF LASTKEY() = 27
         EXIT
      ENDIF
      SEEK M_CLIENTE
      IF !FOUND()
         DO M_CARTEL WITH 40,24,0,.T.,.T.,.T.
         ESPERAR(0)
      ELSE
         SET COLOR TO I
         @ 10,3 SAY NOMBRE
         SET COLOR TO
         EXIT
      ENDIF
   ENDDO
   IF LASTKEY() = 27
      EXIT
   ENDIF
   @ 12,1 TO 12,78
   M_IMP = 0
   M_TIPO = 'D'
   M_COTIZA = DOLAR->COTIZ
   @ 14,3 SAY 'Importe de Diferencia : ' GET M_IMP PICT '############.##' VALID M_IMP >= 0
   @ 16,3 SAY 'Deudor o Acreedor     : ' GET M_TIPO PICT 'A' VALID M_TIPO = 'D' .OR. M_TIPO = 'A'
   @ 18,3 SAY 'Cotizacion del Dolar  : ' GET M_COTIZA PICT '######.##' VALID M_COTIZA > 0
   READ
   IF LASTKEY() = 27
      LOOP
   ENDIF
   IF APRUEBA(24,0,2)
      @ 24,0 SAY SPACE(79)
      DO M_CARTEL WITH 62,24,0,.T.,.F.,.T.
      IF !R5
         SELE 13
         SEEK IIF(M_TIPO = 'D','AJD','AJA')
         M_NUMERO = NUMERO
         REPLACE NUMERO WITH NUMERO + 1
         SELE 4
      ENDIF
      APPEND BLANK
      REPLACE TIPO WITH IIF(M_TIPO = 'D','AJD','AJA')
      REPLACE NUMERO WITH M_NUMERO
      REPLACE TOTAL WITH M_IMP
      REPLACE CLIENTE WITH M_CLIENTE
      REPLACE COTIZA WITH M_COTIZA
      REPLACE FECHA WITH M_FECHA
      REPLACE FVENC WITH M_FECHA
      REPLACE CAJERO WITH CLIENTES->COD_VEND
      IF !R5
                M_SALDO = 0
                M_ACUMCAN = 0
                PASO = .F.
                GO TOP
                DO WHILE !EOF()
                   IF M_CLIENTE = CLIENTE .AND. !ANULADA
                      IF TIPO = 'FAC' .OR. TIPO = 'CDO' .OR. TIPO = 'NDB'
                         M_DESCU = (TOTAL * BONIF) / 100
                         M_SALDO = M_SALDO + TOTAL + IVA + REC_IVA - M_DESCU
                         IF M_TIPO = 'A'
                               IF !CANCELADA .AND. !PASO
                                     IF TOTAL + IVA + REC_IVA - M_DESCU < M_IMP - M_ACUMCAN
                                                REPLACE CANCELADA WITH .T.
                                     ELSE
                                           IF TOTAL + IVA + REC_IVA - M_DESCU = M_IMP - M_ACUMCAN
                                                 REPLACE CANCELADA WITH .T.
                                           ELSE
                                               IF TOTAL + IVA + REC_IVA - M_DESCU > M_IMP - M_ACUMCAN
                                                       REPLACE ACTA WITH ACTA + M_IMP - M_ACUMCAN
                                                       PASO = .T.
                                               ENDIF
                                           ENDIF
                                     ENDIF
                                     M_ACUMCAN = M_ACUMCAN + TOTAL + IVA + REC_IVA - M_DESCU
                               ENDIF
                         ENDIF
                      ELSE
                         IF TIPO = 'REC' .OR. TIPO = 'NCR'
                            M_SALDO = M_SALDO - (TOTAL + IVA + REC_IVA)
                         ELSE
                            IF TIPO = 'AJD' .OR. TIPO = 'AJA'
                               IF TIPO = 'AJD'
                                  M_SALDO = M_SALDO + TOTAL
                               ELSE
                                  M_SALDO = M_SALDO - TOTAL
                               ENDIF
                            ENDIF
                         ENDIF
                      ENDIF
                   ENDIF
                   SKIP
                ENDDO
                SELE 11
                REPLACE SALDO WITH M_SALDO
      ENDIF
   ENDIF
ENDDO
CLOSE ALL
RETURN
