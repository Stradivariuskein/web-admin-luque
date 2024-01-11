*Listado de prevision de cobranzas
*
*
SELE 3
USE VENDEDOR INDEX VENDEDOR

SELE 4
USE CLIENTES INDEX CLIENTES

R5 = .F.
M_DESDE = DATE()
M_HASTA = DATE()
M_VEND = SPACE(10)
M_ZONA = SPACE(10)
DO WHILE .T.
     CLEAR
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     @ 1,0 TO 23,79 DOUBLE
     IF R5
         @ 23,79 SAY '.'
     ENDIF
     DO TITULO
     SET COLOR TO I
     @ 3,25 SAY 'LISTADO DE PREVISION DE COBRANZAS'
     SET COLOR TO
     @ 5,1 TO 5,78
     @ 8,3 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
     @ 10,3 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA) .AND. M_HASTA >= M_DESDE
     READ
     IF LASTKEY() = 27
         EXIT
     ENDIF
     DO WHILE .T.
        SELE 3
        @ 12,3 SAY 'Numero de Vendedor  (9999999999=TODOS): ' GET M_VEND PICT '@!'
        READ
        IF LASTKEY() = 27
             EXIT
        ENDIF
        IF VAL(M_VEND) = 9999999999
             SET COLOR TO I
             @ 12,35 SAY 'SE IMPRIMEN TODOS              '
             SET COLOR TO
             EXIT
        ENDIF
        SEEK M_VEND
        IF !FOUND()
            DO M_CARTEL WITH 19,24,0,.T.,.T.,.T.
            ESPERAR(0)
            @ 24,0 SAY SPACE(79)
        ELSE
            SET COLOR TO I
            @ 12,35 SAY NOMBRE
            SET COLOR TO
            EXIT
        ENDIF
     ENDDO
     IF LASTKEY() = 27
         LOOP
     ENDIF
     @ 13,3 SAY 'Zona (9999999999 = TODAS)              : ' GET M_ZONA PICT '@!'
     READ
     IF LASTKEY() = 27
         LOOP
     ENDIF
     LINEAS = 70
     HOJA = 1
     PRIMERA = .T.
     IMPRE = .F.
     IF APRUEBA(24,0,11)
         SET DEVI TO PRINT
         IMPRE = .T.
     ENDIF
     M_ACOB = 0
     FOR A = 1 TO 1
        SELE 1
        ARCHIVO = 'COMPRO1'
        INDICE = 'COMPRO2'
        USE &ARCHIVO
        INDEX ON FECHA TO AUXILI0
        IF VAL(M_VEND) <> 9999999999
            SET FILTER TO CAJERO = M_VEND
        ENDIF
        GO TOP
        DO WHILE !EOF()
               IF LINEAS > 66 .AND. IMPRE
                      DO ENC_PREV
               ENDIF
               IF LINEAS > 20 .AND. !IMPRE
                       DO ENC_PREV
               ENDIF
               IF TIPO = 'FAC' .OR. TIPO = 'NDB' .OR. TIPO = 'AJD' .OR. TIPO = 'CDO'
                     IF FVENC >= M_DESDE .AND. FVENC <= M_HASTA .AND. !CANCELADA .AND. !ANULADA
                            SELE 4
                            SEEK &ARCHIVO->CLIENTE
                            IF M_ZONA <> '9999999999'
                                 IF ZONA <> M_ZONA
                                     SELE 1
                                     SKIP
                                     LOOP
                                 ENDIF
                            ENDIF
                            SELE 1
                            M_TOTAL = TRANSFORM((TOTAL + IVA + REC_IVA) - BONIF - ACTA,'###,###,###.##')
                            M_T = (TOTAL + IVA  + REC_IVA) - BONIF - ACTA
                            IF M_T <> 0
                               @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + '       ' + SUBSTR(CLIENTES->NOMBRE,1,21) + ' ' + M_TOTAL + '         ' + DTOC(FVENC)
                               LINEAS = LINEAS + 1
                               M_ACOB = M_T + M_ACOB
                            ENDIF
                     ENDIF
               ELSE
                     IF TIPO = 'NCR'
                           IF FVENC >= M_DESDE .AND. FVENC <= M_HASTA .AND. !CANCELADA .AND. !ANULADA
                                  SELE 4
                                  SEEK &ARCHIVO->CLIENTE
                                  IF M_ZONA <> '9999999999'
                                       IF ZONA <> M_ZONA
                                           SELE 1
                                           SKIP
                                           LOOP
                                       ENDIF
                                  ENDIF
                                  SELE 1
                                  M_TOTAL = TRANSFORM((TOTAL + IVA + REC_IVA),'-###,###,###.##')
                                  M_T = (TOTAL + IVA  + REC_IVA)
                                  @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + '       ' + SUBSTR(CLIENTES->NOMBRE,1,21) + '' + M_TOTAL + '         ' + DTOC(FVENC)
                                  LINEAS = LINEAS + 1
                                  M_ACOB = M_ACOB - M_T
                           ENDIF
                     ENDIF
               ENDIF
               SKIP
        ENDDO
        SET FILTER TO
        IF !R5
            A = 3
        ENDIF
     NEXT
     IF IMPRE
         @ LINEAS + 1,1 SAY '                                            =================='
         @ LINEAS + 2,1 SAY 'Total a cobrar : '
         @ LINEAS + 2,48 SAY TRANSFORM(M_ACOB,'###,###,###.##')
         @ LINEAS + 3,1 SAY '                                            =================='
         EJECT
         SET DEVI TO SCREEN
     ELSE
         @ LINEAS + 1,1 SAY '                                            =================='
         @ LINEAS + 2,1 SAY 'Total a cobrar : '
         @ LINEAS + 2,48 SAY TRANSFORM(M_ACOB,'###,###,###.##')
         @ LINEAS + 3,1 SAY '                                            =================='
         DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
         ESPERAR(0)
     ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE ENC_PREV
******************

IF PRIMERA
     IF !IMPRE
         CLEAR
     ENDIF
     PRIMERA = .F.
ELSE
     IF IMPRE
        EJECT
     ELSE
        DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
        ESPERAR(0)
        CLEAR
     ENDIF
ENDIF

LINEAS = 1
@ LINEAS,20 SAY 'LISTADO DE PREVISION DE COBRANZAS'
@ LINEAS +2,2 SAY 'Desde Fecha : ' + DTOC(M_DESDE) + ' Hasta Fecha : ' + DTOC(M_HASTA)
@ LINEAS +3,2 SAY 'Hoja Nro: ' + STR(HOJA,3,0)
IF VAL(M_VEND) <> 9999999999
     @ LINEAS + 3,30 SAY 'Vendedor : ' + VENDEDOR->NOMBRE
ELSE
     @ LINEAS + 3,30 SAY 'Vendedor : ' + 'TODOS'
ENDIF
@ LINEAS + 4,1 SAY 'Zona : ' + IIF(M_ZONA = '9999999999','TODAS',M_ZONA)
@ LINEAS + 5,1 SAY REPLICATE('=',79)
@ LINEAS + 6,1 SAY 'Fecha  Comprob. Nro.      Cliente            Imp. a Cobrar            F. Venc'
@ LINEAS + 7,1 SAY REPLICATE('=',79)
HOJA = HOJA + 1
LINEAS = 9
RETURN
