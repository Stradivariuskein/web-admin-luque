SELE 1
USE CLIENTES
INDEX ON COD_CLI TO CLI
GO TOP
DO WHILE .NOT. EOF()
      REPLACE SALDO WITH 0
      REPLACE SALDOI WITH 0
      SKIP
ENDDO

SELE 4
USE COMPRO1
INDEX ON CLIENTE TO PEPE1

SELE 7
USE AUXILI2
INDEX ON CLIENTE TO PEPE2

SELE 4
GO TOP

DO WHILE .NOT. EOF()
      M_CLIENTE = CLIENTE
      M_SALDO = 0
      DO WHILE .NOT.EOF() .AND. CLIENTE = M_CLIENTE
         IF .NOT.ANULADA
            IF TIPO = 'FAC' .OR. TIPO = 'CDO' .OR. TIPO = 'NDB'
               M_DESCU = (TOTAL * BONIF) / 100
               M_SALDO = M_SALDO + TOTAL + IVA + REC_IVA - M_DESCU
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
      IF M_CLIENTE = 2
          WAIT
      ENDIF
      SELE 1
      SEEK M_CLIENTE
      REPLACE SALDO WITH M_SALDO
  ENDIF
  SELE 4
ENDDO

SELE 7
GO TOP

DO WHILE .NOT. EOF()
      M_CLIENTE = CLIENTE
      M_SALDO = 0
      DO WHILE .NOT.EOF() .AND. CLIENTE = M_CLIENTE
         IF .NOT.ANULADA
            IF TIPO = 'FAC' .OR. TIPO = 'CDO' .OR. TIPO = 'NDB'
               M_DESCU = (TOTAL * BONIF) / 100
               M_SALDO = M_SALDO + TOTAL + IVA + REC_IVA - M_DESCU
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
      SELE 1
      SEEK M_CLIENTE
      REPLACE SALDOI WITH M_SALDO
  ENDIF
  SELE 7
ENDDO
CLOSE ALL
RETURN
