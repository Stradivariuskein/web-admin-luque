SELE 11
USE CLIENTES INDEX CLIENTES

SELE 4
USE COMPRO1 INDEX COMPRO2

R5 = .F.
M_AUXI = SPACE(10)

DO WHILE .T.
   CLEAR
   DO TITULO
   DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
   @ 1,0 TO 23,79 DOUBLE
   SET COLOR TO I
   @ 3,25 SAY ' * RESUMEN DE CUENTA DE CLIENTES * '
   SET COLOR TO
   @ 6,1 TO 6,78
   DO WHILE .T.
      SELE 11
      M_CLIENTE = SPACE(10)
      @ 8,3 SAY 'Codigo de Cliente (9999999999 = TODOS) : ' GET M_CLIENTE PICT '@!'
      STOR M_FECHA TO M_DESDE,M_HASTA
      @ 10,3 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
      @ 12,3 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
      READ
      IF LASTKEY() = 27
         EXIT
      ENDIF
      IF VAL(M_CLIENTE) = 9999999999
         SET COLOR TO I
         @ 8,39 SAY 'SE IMPRIMEN TODOS'
         SET COLOR TO
         EXIT
      ENDIF
      SEEK M_CLIENTE
      IF !FOUND()
         DO M_CARTEL WITH 40,24,0,.T.,.T.,.T.
         ESPERAR(0)
         @ 24,0 SAY SPACE(79)
      ELSE
         SET COLOR TO I
         @ 8,39 SAY NOMBRE
         SET COLOR TO
         EXIT
      ENDIF
   ENDDO
   IF LASTKEY() = 27
      EXIT
   ENDIF
   IMPRE = .F.
   IF APRUEBA(24,0,11)
      IMPRE = .T.
      SET DEVICE TO PRINT
   ENDIF
   SELE 11
   IF VAL(M_CLIENTE) = 9999999999
      GO TOP
   ENDIF
   M_AUXI = M_CLIENTE
   HOJA = 1
   LINEAS = 70
   PRIMERA = .T.
   NO_IMPRE = .F.
   M_TOTCTA = 0
   DO WHILE !EOF()
      IF VAL(M_AUXI) = 9999999999
         M_CLIENTE = COD_CLI
      ENDIF
      TOT_DEUDA = 0
      LO = 1
      DO WHILE LO <= 1
         IF VAL(M_AUXI) = 9999999999
            SELE 11
            SEEK M_CLIENTE
            IF SALDO = 0 .AND. SALDOI = 0
               HACE = .F.
            ELSE
               HACE = .T.
            ENDIF
         ELSE
            HACE = .T.
         ENDIF
         IF LO = 1
            SELE 4
            IF VAL(M_AUXI) = 9999999999
               SEEK M_CLIENTE
               IF !FOUND()
                  GO TOP
               ENDIF
            ELSE
               SEEK M_CLIENTE
            ENDIF
         ELSE
            SELE 7
            IF VAL(M_AUXI) = 9999999999
               SEEK M_CLIENTE
               IF !FOUND()
                  GO TOP
               ENDIF
            ELSE
               SEEK M_CLIENTE
            ENDIF
         ENDIF
         DO WHILE !EOF() .AND. HACE
            IF LINEAS > 65 .AND. IMPRE
               DO ENC_RES
               NO_IMPRE = .T.
            ENDIF
            IF LINEAS > 20 .AND. !IMPRE
               DO ENC_RES
            ENDIF
            IF IMPRE
               IF !NO_IMPRE .AND. LO = 1
                  DO ENC_RES2
                  NO_IMPRE = .T.
               ENDIF
            ENDIF
            IF M_CLIENTE = CLIENTE .AND. !ANULADA
               IF TIPO = 'FAC' .OR. TIPO = 'CDO'
                  M_FRASE = 'FACTURA        '
               ELSE
                  IF TIPO = 'NDB'
                     M_FRASE =     'NOTA de DEBITO '
                  ELSE
                     IF TIPO = 'NCR'
                        M_FRASE = 'NOTA de CREDITO'
                     ELSE
                        IF TIPO = 'REC' .OR. TIPO = 'RE2'
                           M_FRASE = 'RECIBO         '
                        ELSE
                           IF TIPO =  'AJD' .OR. TIPO = 'AJA'
                              M_FRASE =  'AJUSTE SALDO   '
                           ELSE
                              IF TIPO = 'NC2'
                                  M_FRASE = 'REC.xDTO.      '
                              ELSE
                                   SKIP
                                   LOOP
                              ENDIF
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
               IF IMPRE
                  IF !NO_IMPRE
                     DO ENC_RES2
                  ENDIF
               ENDIF
               M_DESCU = BONIF
               IF LO = 1
                  M_IMPAUX = (TOTAL + IVA + REC_IVA - M_DESCU)
               ELSE
                  M_IMPAUX = TOTAL -  M_DESCU
               ENDIF
               IF TIPO <> 'REC' .AND. TIPO <> 'RE2'
                  TOT_DEUDA = IIF(TIPO = 'NCR'.OR. TIPO = 'AJA'.OR. TIPO = 'NC2',TOT_DEUDA - M_IMPAUX,TOT_DEUDA + M_IMPAUX)
               ELSE
                  TOT_DEUDA = TOT_DEUDA - M_IMPAUX
               ENDIF
               IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA
                   IF TIPO = 'REC' .OR. TIPO = 'NCR' .OR. TIPO = 'AJA' .OR. TIPO = 'NC2'
                      @ LINEAS,1 SAY DTOC(FECHA) + ' ' + M_FRASE + '  ' + STR(NUMERO,5,0) + IIF(MR5,'.',' ') + '                   ' + IIF(TIPO = 'NCR'.OR. TIPO = 'REC',' ',' ') + ' ' + STR(M_IMPAUX,12,2)
                   ELSE
                      @ LINEAS,1 SAY DTOC(FECHA) + ' ' + M_FRASE + '  ' + STR(NUMERO,5,0) + IIF(MR5,'.',' ') + '   ' + IIF(TIPO = 'NCR'.OR. TIPO = 'REC',' ',' ') + ' ' + STR(M_IMPAUX,12,2)
                   ENDIF
                   SET COLOR TO W+
                   @ LINEAS,68 SAY STR(TOT_DEUDA,12,2)
                   SET COLOR TO
                   LINEAS = LINEAS + 1
               ENDIF
               SKIP
            ELSE
               IF M_CLIENTE <> CLIENTE
                  IF VAL(M_AUXI) = 9999999999
                     GO BOTTOM
                     SKIP
                  ELSE
                     GO BOTTOM
                     SKIP
                  ENDIF
               ELSE
                  SKIP
               ENDIF
            ENDIF
         ENDDO
         IF !R5
            LO = 10
         ENDIF
         LO = LO + 1
      ENDDO
      IF HACE
         IF LINEAS <> 6
             SET COLOR TO W+
             @ LINEAS - 1,68 SAY STR(TOT_DEUDA,12,2)
             SET COLOR TO
         ELSE
             SET COLOR TO W+
             @ LINEAS,68 SAY STR(TOT_DEUDA,12,2)
             SET COLOR TO
             LINEAS = LINEAS + 1
         ENDIF
         IF TOT_DEUDA >= 0
             M_TOTCTA = M_TOTCTA + TOT_DEUDA
         ENDIF
         NO_IMPRE = .F.
         IF IMPRE
*              @ LINEAS + 3,0 SAY REPLICATE('=',79)
*              LINEAS = LINEAS + 4
         ELSE
               DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
               ESPERAR(0)
               PRIMERA = .T.
               LINEAS = 100
               IF LASTKEY() = 27
                   SELE 11
                   GO BOTTOM
               ENDIF
          ENDIF
      ENDIF
      SELE 11
      IF VAL(M_AUXI) <> 9999999999
         GO BOTTOM
      ENDIF
      SKIP
   ENDDO
   IF IMPRE
      @ LINEAS + 2,2 SAY 'Total de Cta. Cte. de Clientes : '
      @ LINEAS + 2,40 SAY M_TOTCTA PICT '###,###,###,###.##'
      EJECT
      SET DEVICE TO SCREEN
   ELSE
      @ 23,2 SAY 'Total de Cta. Cte. de Clientes : '
      @ 23,40 SAY M_TOTCTA PICT '###,###,###,###.##'
      ESPERAR(0)
   ENDIF
ENDDO
IF VAL(M_AUXI) = 9999999999
   ERASE C:SIAAC\AUXI_0.NTX
   ERASE C:SIAAC\AUXI_1.NTX
ENDIF
CLOSE ALL
RETURN

PROCEDURE ENC_RES
*****************
*Encabezamiento del listado de RESUMEN DE CTA.
LINEAS = 1
IF PRIMERA
   IF IMPRE
      @ LINEAS,10 SAY IIF(IMPRE,CHR(14),'                  ') + ' * RESUMEN DE CUENTA DE CLIENTES * '
      PRIMERA = .F.
   ELSE
      CLEAR
      PRIMERA = .F.
   ENDIF
ELSE
   IF IMPRE
      EJECT
   ELSE
      DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
      ESPERAR(0)
      CLEAR
   ENDIF
ENDIF

IF IMPRE
   *  @ LINEAS,76 SAY STR(HOJA,3,0)
ELSE
   @ LINEAS,10 SAY IIF(!IMPRE,'                  ' + ' * RESUMEN DE CUENTA DE CLIENTES * ','')
ENDIF
@ LINEAS + 1,1 SAY REPLICATE('=',79)
@ LINEAS + 2,1 SAY 'FECHA        CONCEPTO       NUMERO         DEBE            HABER        SALDO'
@ LINEAS + 3,1 SAY IIF(IMPRE,CHR(27) + CHR(71),'')  +  'Cliente: ' + ' (' + CLIENTES->COD_CLI + ' ) '  + RTRIM(CLIENTES->NOMBRE) + IIF(IMPRE,CHR(27) + CHR(72),'')
@ LINEAS + 4,1 SAY REPLICATE('=',79)
LINEAS = 6
HOJA = HOJA + 1
RETURN

PROCEDURE ENC_RES2
********* ********
@ LINEAS,1 SAY REPLICATE('=',79)
@ LINEAS + 1,1 SAY IIF(IMPRE,CHR(27) + CHR(71),'')  +  'Cliente: ' + ' (' + CLIENTES->COD_CLI + ' ) '  + RTRIM(CLIENTES->NOMBRE) + IIF(IMPRE,CHR(27) + CHR(72),'')
LINEAS = LINEAS + 3
RETURN
