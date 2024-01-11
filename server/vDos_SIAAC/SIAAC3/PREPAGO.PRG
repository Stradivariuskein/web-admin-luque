*Listado de prevision de Pagos.
*
*
SELE 3
USE PROVEDOR INDEX PROVEDOR

R5 = .F.
M_DESDE = DATE()
M_HASTA = DATE()
M_VEND = 1

DO WHILE .T.
     CLEAR
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     @ 1,0 TO 23,79 DOUBLE
     IF R5
         @ 23,79 SAY '.'
     ENDIF
     DO TITULO
     SET COLOR TO I
     @ 3,25 SAY 'LISTADO DE PREVISION DE PAGOS'
     SET COLOR TO
     @ 5,1 TO 5,78
     @ 8,3 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
     @ 10,3 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA) .AND. M_HASTA >= M_DESDE
     READ
     IF LASTKEY() = 27
           EXIT
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
            ARCHIVO = 'COMPRAS'
            SELE 1
            USE &ARCHIVO INDEX &ARCHIVO
            GO TOP
            DO WHILE !EOF()
                   IF LINEAS > 66 .AND. IMPRE
                          DO ENC_PAGO
                   ENDIF
                   IF LINEAS > 20 .AND. !IMPRE
                           DO ENC_PAGO
                   ENDIF
                   IF TIPO = 'FAC' .OR. TIPO = 'NDB'
                         IF VENC >= M_DESDE .AND. VENC <= M_HASTA .AND. ESTADO = 'I' .AND. !ANULADA
                                SELE 3
                                SEEK &ARCHIVO->PROVEDOR
                                SELE 1
                                M_TOTAL = TRANSFORM((IMP_BRUTO + IVA + ADIC) - ACTA,'###,###,###.##')
                                M_T = (IMP_BRUTO + IVA + ADIC) - ACTA
                                @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(FACTURA,10,0) + '  ' + SUBSTR(PROVEDOR->NOMBRE,1,21) + ' ' + M_TOTAL + '         ' + DTOC(VENC)
                                LINEAS = LINEAS + 1
                                M_ACOB = M_T + M_ACOB
                         ENDIF
                   ELSE
                         IF TIPO = 'NCR'
                               IF VENC >= M_DESDE .AND. VENC <= M_HASTA .AND. ESTADO = 'I' .AND. !ANULADA
                                      SELE 4
                                      SEEK &ARCHIVO->PROVEDOR
                                      SELE 1
                                      M_TOTAL = TRANSFORM((IMP_BRUTO + IVA + ADIC),'-###,###,###.##')
                                      M_T = (IMP_BRUTO + IVA + ADIC)
                                      @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(FACTURA,10,0) + '  ' + SUBSTR(PROVEDOR->NOMBRE,1,21) + '' + M_TOTAL + '         ' + DTOC(VENC)
                                      LINEAS = LINEAS + 1
                                      M_ACOB = M_ACOB - M_T
                               ENDIF
                         ENDIF
                   ENDIF
                   SKIP
            ENDDO
            IF !R5
               A = 3
            ENDIF
     NEXT
     IF IMPRE
         @ LINEAS + 1,1 SAY '                                            =================='
         @ LINEAS + 2,1 SAY 'Total a Pagar  : '
         @ LINEAS + 2,48 SAY TRANSFORM(M_ACOB,'###,###,###.##')
         @ LINEAS + 3,1 SAY '                                            =================='
         EJECT
         SET DEVI TO SCREEN
     ELSE
         @ LINEAS + 1,1 SAY '                                            =================='
         @ LINEAS + 2,1 SAY 'Total a Pagar  : '
         @ LINEAS + 2,48 SAY TRANSFORM(M_ACOB,'###,###,###.##')
         @ LINEAS + 3,1 SAY '                                            =================='
         DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
         ESPERAR(0)
     ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE ENC_PAGO
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
@ LINEAS,20 SAY 'LISTADO DE PREVISION DE PAGOS'
@ LINEAS +2,2 SAY 'Desde Fecha : ' + DTOC(M_DESDE) + ' Hasta Fecha : ' + DTOC(M_HASTA)
@ LINEAS +3,2 SAY 'Hoja Nro: ' + STR(HOJA,3,0)
@ LINEAS + 5,1 SAY REPLICATE('=',79)
@ LINEAS + 6,1 SAY 'Fecha  Comprob. Nro.      Proveedor          Imp. a Pagar             F. Venc'
@ LINEAS + 7,1 SAY REPLICATE('=',79)
HOJA = HOJA + 1
LINEAS = 9
RETURN
