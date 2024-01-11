*******************************************************************************
*Listados de Iva Compras y Ventas                                             *
*                                                                             *
*Fuente : LISTADOS.PRG                                                        *
*******************************************************************************
DECLARE TOTALES[4]

DECLARE MENPEE[8]
DECLARE OPPEE[8]
OPPEE[1]='LISTADO DE IVA COMPRAS'
OPPEE[2]='LISTADO DE IVA VENTAS'
OPPEE[3]='LISTADO DE VENTAS POR PROVINCIA'
OPPEE[4]='LISTADO DE PREVISION DE COBRANZAS'
OPPEE[5]='LISTADO DE PREVISION DE PAGOS'
OPPEE[6]='LISTADO DE INGRESOS BRUTOS'
OPPEE[7]='LISTADO DE FACTURAS COBRADAS'
OPPEE[8]='LISTADO DE FACTURAS PAGADAS A PROVEEDORES'

MENPEE[1]='          º  Detalle de  Compras efectuadas a Proveedores'
MENPEE[2]='          º  Detalle de  Ventas efectuadas a Clientes'
MENPEE[3]='          º  Listado de Ventas p/Ingresos Brutos'
MENPEE[4]='          º  Prevision de cobranzas a Clientes'
MENPEE[5]='          º  Prevision de Pagos a Proveedores'
MENPEE[6]='          º  Listado de Ingresos Brutos'
MENPEE[7]='          º  Listado de Facturas Cobradas x Vendedor'
MENPEE[8]='          º  Listado de Facturas Pagadas'

DO WHILE .T.
     CLEAR
     DO TITULO
     *    Displaya opciones y captura.
          OPPE=OPCIONES('SISTEMA DE VENTAS - LISTADOS VARIOS',OPPEE,MENPEE)
     *    Fin
          IF LASTKEY()=27
           EXIT
          ENDIF
             DO CASE
                CASE OPPE=1
                  DO LIS_IVA WITH 'C',.T.
                CASE OPPE=2
                  DO LIS_IVA WITH 'V',.T.
                CASE OPPE = 3
                  DO LIS_IVA WITH 'V',.F.
                CASE OPPE = 4
                  DO PREVCOB
                CASE OPPE = 5
                  DO PREPAGO
                CASE OPPE = 6
                  DO ING_BRUTO
                CASE OPPE = 7
                  DO FACOB
                CASE OPPE = 8
                  DO FAPAG
             ENDCASE
ENDDO
CLOSE ALL
RETURN


PROCEDURE LIS_IVA
*****************

*Hace listado de IVA Compras o Ventas

PARAMETERS MODO,TODO

SELE 22
USE PROVI INDEX PROVI

IMPRE = .F.
M_DESDE = DATE() - 30
M_HASTA = DATE()
IF MODO = 'V' .AND. !TODO
    M_PROVI = 1
    @ 22,2 SAY 'Provincia : ' GET M_PROVI PICT '###' VALID VALPROVI(M_PROVI,22,35)
ENDIF
@ 23,2 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
@ 23,55 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
READ

IF LASTKEY() = 27
    @ 23,0 SAY SPACE(79)
    CLOSE ALL
    RETURN
ENDIF

SELE 2
USE CLIENTES INDEX CLIENTES

SELE 12
USE PROVEDOR INDEX PROVEDOR

IF MODO = 'V'
    SELE 4
    USE COMPRO1
    INDEX ON FECHA TO AUXILI0
ELSE
    SELE 4
    USE COMPRAS
    INDEX ON FECHA TO AUXILI0
ENDIF

@ 24,0 SAY SPACE(80)


DO M_CARTEL WITH 10,24,0,.T.,.T.,.T.
ESPERAR(0)
IF LASTKEY() = 27
   CLOSE ALL
   RETURN
ENDIF

IMPRE = .T.
SET DEVICE TO PRINT
@ PROW(),PCOL() SAY CHR(15)

GO TOP
LINEAS = 68
HOJA = 1
PRIMERA = .T.
FOR I = 1 TO 4
   TOTALES[I] = 0
NEXT
M_TOTRETE = 0
DO WHILE !EOF()
       IF LINEAS > 63 .AND. IMPRE
             DO ENC_IVA
       ELSE
            IF LINEAS > 20 .AND. !IMPRE
                     DO ENC_IVA
            ENDIF
       ENDIF
       IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA
        IF MODO = 'V'
          IF TIPO  = 'FAC' .OR. TIPO = 'CDO' .OR. TIPO = 'NDB' .OR. TIPO = 'NCR' .OR. TIPO = 'NC2' .OR. TIPO = 'CON'
              IF !TODO .AND. PROVI <> M_PROVI
                   SKIP
                   LOOP
              ENDIF
              SELE 2
              SEEK COMPRO1->CLIENTE
              SELE 4
              IF !ANULADA
                 IF TIPO <>'NCR' .AND. TIPO <> 'NC2'
                    IF TIPO <> 'CDO'
                        M_T = TOTAL - BONIF
                        M_NETO = TRANSFORM(M_T,'###,###,###.##')
                        M_IVA = TRANSFORM(IVA,'####,###,###.##')
                        M_ADIC = TRANSFORM(REC_IVA,'####,###,###.##')
                        M_TOTAL = TRANSFORM(M_T + REC_IVA + IVA,'####,###,###.##')
                        TOTALES[1] = IIF(TIPO <> 'NCR'.AND. TIPO <> 'NC2',TOTALES[1] + M_T ,TOTALES[1] - M_T)
                        TOTALES[2] = IIF(TIPO <> 'NCR'.AND. TIPO <> 'NC2',TOTALES[2] + IVA ,TOTALES[2] - IVA)
                        TOTALES[3] = IIF(TIPO <> 'NCR'.AND. TIPO <> 'NC2',TOTALES[3] + REC_IVA ,TOTALES[3] - REC_IVA)
                        TOTALES[4] = IIF(TIPO <> 'NCR'.AND. TIPO <> 'NC2',TOTALES[4] + M_T + IVA + REC_IVA,TOTALES[4] -(M_T + IVA + REC_IVA))
                    ELSE
                        M_T = TOTAL-BONIF
                        M_T = M_T / 1.21
                        M_I = (TOTAL - BONIF) - M_T
                        M_NETO = TRANSFORM(M_T,'###,###,###.##')
                        M_IVA = TRANSFORM(M_I,'####,###,###.##')
                        M_ADIC = TRANSFORM(REC_IVA,'####,###,###.##')
                        M_TOTAL = TRANSFORM(M_T + REC_IVA + M_I,'####,###,###.##')
                        TOTALES[1] = IIF(TIPO <> 'NCR'.AND. TIPO <> 'NC2',TOTALES[1] + M_T ,TOTALES[1] - M_T)
                        TOTALES[2] = IIF(TIPO <> 'NCR'.AND. TIPO <> 'NC2',TOTALES[2] + M_I ,TOTALES[2] - M_I)
                        TOTALES[3] = IIF(TIPO <> 'NCR'.AND. TIPO <> 'NC2',TOTALES[3] + REC_IVA ,TOTALES[3] - REC_IVA)
                        TOTALES[4] = IIF(TIPO <> 'NCR'.AND. TIPO <> 'NC2',TOTALES[4] + M_T + M_I + REC_IVA,TOTALES[4] -(M_T + M_I + REC_IVA))
                    ENDIF
                 ELSE
                    M_T = TOTAL - BONIF
                    M_NETO = TRANSFORM(M_T,'-##,###,###.##')
                    M_IVA = TRANSFORM(IVA,'-###,###,###.##')
                    M_ADIC = TRANSFORM(REC_IVA,'-###,###,###.##')
                    M_TOTAL = TRANSFORM(M_T + REC_IVA + IVA,'-###,###,###.##')
                    TOTALES[1] = IIF(TIPO <> 'NCR'.AND. TIPO <> 'NC2',TOTALES[1] + M_T ,TOTALES[1] - M_T)
                    TOTALES[2] = IIF(TIPO <> 'NCR'.AND. TIPO <> 'NC2',TOTALES[2] + IVA ,TOTALES[2] - IVA)
                    TOTALES[3] = IIF(TIPO <> 'NCR'.AND. TIPO <> 'NC2',TOTALES[3] + REC_IVA ,TOTALES[3] - REC_IVA)
                    TOTALES[4] = IIF(TIPO <> 'NCR'.AND. TIPO <> 'NC2',TOTALES[4] + M_T + IVA + REC_IVA,TOTALES[4] -(M_T + IVA + REC_IVA))
                 ENDIF
                 @ LINEAS,1 SAY DTOC(FECHA) + '  ' + TIPO + ' ' + STR(NUMERO,5,0) + '   ' + SUBSTR(CLIENTES->NOMBRE,1,33) + ' ' + RTRIM(CLIENTES->CUIT)
                 @ LINEAS,74 SAY M_NETO + ' ' + M_IVA + ' ' + M_ADIC+ ' ' + M_TOTAL
                 LINEAS = LINEAS + 1
              ELSE
                    @ LINEAS,1 SAY DTOC(FECHA) + '  ' + TIPO + ' ' + STR(NUMERO,5,0) + '   ' + 'ANULADA'
                    LINEAS = LINEAS + 1
              ENDIF
          ENDIF
        ELSE
           IF TIPO = 'FAC' .OR. TIPO = 'NCR' .OR. TIPO = 'NDB'
               SELE 12
               SEEK COMPRAS->PROVEDOR
               SELE 4
               IF !ANULADA
                  @ LINEAS,1 SAY DTOC(FECHA) + '  ' + TIPO + STR(FACTURA,10,0) + '    ' + SUBSTR(PROVEDOR->NOMBRE,1,25) + ' ' + PROVEDOR->CUIT + ' ' + STR(IMP_BRUTO,12,2) + ' ' + STR(IVA,12,2) + ' ' + STR(ADIC+RETE,12,2) +  ' ' + STR(IMP_NETO,12,2)
                  LINEAS = LINEAS + 1
                  TOTALES[1] = IIF(TIPO <> 'NCR',TOTALES[1] + IMP_BRUTO ,TOTALES[1] - IMP_BRUTO)
                  TOTALES[2] = IIF(TIPO <> 'NCR',TOTALES[2] + IVA ,TOTALES[2] - IVA)
                  TOTALES[3] = IIF(TIPO <> 'NCR',TOTALES[3] + ADIC+RETE,TOTALES[3] - ADIC-RETE)
                  TOTALES[4] = IIF(TIPO <> 'NCR',TOTALES[4] + IMP_NETO,TOTALES[4] -IMP_NETO)
                  M_TOTRETE = M_TOTRETE + RETE
               ENDIF
           ENDIF
         ENDIF
       ENDIF
       SKIP
ENDDO
@ LINEAS + 2,0 SAY REPLICATE('=',136)
IF MODO = 'V'
     TOTALES[1] = TRANSFORM(TOTALES[1],'###,###,###.##')
     TOTALES[2] = TRANSFORM(TOTALES[2],'###,###,###.##')
     TOTALES[3] = TRANSFORM(TOTALES[3],'###,###,###.##')
     TOTALES[4] = TRANSFORM(TOTALES[4],'###,###,###.##')
     @ LINEAS + 3,0 SAY 'Totales:                                                                  ' + TOTALES[1] + '  ' + TOTALES[2] + '  ' + TOTALES[3] + '  ' + TOTALES[4]
ELSE
     TOTALES[1] = TRANSFORM(TOTALES[1],'#,###,###.##')
     TOTALES[2] = TRANSFORM(TOTALES[2],'#,###,###.##')
     TOTALES[3] = TRANSFORM(TOTALES[3],'#,###,###.##')
     TOTALES[4] = TRANSFORM(TOTALES[4],'##,###,###.##')
     @ LINEAS + 3,0 SAY 'Totales:                                                                   ' + TOTALES[1]+ ' ' + TOTALES[2] + '' + TOTALES[3]+ ' ' + TOTALES[4]
     @ LINEAS + 4,0 SAY 'Total de Retenciones : ' + TRANSFORM(M_TOTRETE,'###,###.##')
ENDIF
EJECT
SET DEVICE TO SCREEN

CLOSE ALL
ERASE AUXILIA0.NTX
RETURN

PROCEDURE ENC_IVA
*****************

*Encabezamiento del listado de IVA

IF PRIMERA
    PRIMERA = .F.
ELSE
    @ LINEAS + 1,0 SAY REPLICATE('=',136)
    IF MODO = 'V'
         M_T1 = TRANSFORM(TOTALES[1],'###,###,###.##')
         M_T2 = TRANSFORM(TOTALES[2],'###,###,###.##')
         M_T3 = TRANSFORM(TOTALES[3],'###,###,###.##')
         M_T4 = TRANSFORM(TOTALES[4],'###,###,###.##')
    ELSE
         M_T1 = TRANSFORM(TOTALES[1],'#,###,###.##')
         M_T2 = TRANSFORM(TOTALES[2],'#,###,###.##')
         M_T3 = TRANSFORM(TOTALES[3],'#,###,###.##')
         M_T4 = TRANSFORM(TOTALES[4],'##,###,###.##')
    ENDIF
    IF MODO = 'V'
         @ LINEAS + 2,0 SAY 'Totales:                                                                       ' + M_T1 + '' + M_T2 + '  ' + M_T3 + '  ' + M_T4
    ELSE
         @ LINEAS + 1,0 SAY 'Totales:                                                                   ' + M_T1 + ' ' + M_T2 + '' + M_T3 + ' ' + M_T4
    ENDIF
    EJECT
ENDIF
LINEAS = 1
IF MODO = 'V'
    @ LINEAS,30 SAY IIF(IMPRE,CHR(14),'         ')  + ' * LISTADO DE IVA VENTAS * '
    IF !TODO
       @ LINEAS + 1,1 SAY 'Provincia : ' + PROVI->NOMBRE
    ENDIF
    @ LINEAS + 2,1 SAY '                                                                                                    TOTALES'
    @ LINEAS + 3,1 SAY 'Fecha    Comprobante           CLIENTE                      C.U.I.T.             NETO GRAV.         IVA        REC.IVA           TOTAL'
ELSE
    @ LINEAS,30 SAY IIF(IMPRE,CHR(14),'         ')  + ' * LISTADO DE IVA COMPRAS * '
    @ LINEAS + 3,1 SAY 'Fecha         Comprobante        PROVEEDOR                CUIT                   BRUTO        IVA         ADIC. IVA      NETO'
ENDIF
@ LINEAS + 4,0 SAY REPLICATE('=',136)
LINEAS = 6
HOJA = HOJA + 1
RETURN


PROCEDURE ING_BRUTO
*******************
*Listado de ingresos brutos


SELE 1
USE COMPRO1 INDEX COMPRO1

SELE 2
USE DETALLE1 INDEX DETALLE1

SELE 3
USE ARTIC INDEX ARTIC

SELE 4
USE SUBCONJ INDEX SUBCONJ

SELE 5
USE CLIENTES INDEX CLIENTES

SELE 22
USE PROVI INDEX PROVI

@ 16,0 CLEAR TO 23,79
@ 16,0 TO 23,79
M_PROVI = 1
STOR M_FECHA TO M_DESDE,M_HASTA
@ 17,1 SAY 'Codigo de Provincia (99 = TODAS) ' GET M_PROVI PICT '##' VALID VALPROVI(M_PROVI,20,1)
@ 18,1 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
@ 19,1 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
READ
IF LASTKEY() = 27
   CLOSE ALL
   RETURN
ENDIF
IF M_PROVI <> 99
   M_COEFI = PROVI->COEFI
   M_COEFI1 = PROVI->COEFI1
   @ 20,1 SAY 'Coeficiente de P.Fabricacion : ' GET M_COEFI PICT '###.##'
   @ 21,1 SAY 'Coeficiente de P.Terminados  : ' GET M_COEFI1 PICT '###.##'
   READ
   IF LASTKEY() = 27
      CLOSE ALL
      RETURN
   ENDIF
ELSE
   STOR 0 TO M_COEFI,M_COEFI1
ENDIF

IMPRE = .F.
IF !APRUEBA(24,0,2)
    CLOSE ALL
    RETURN
ENDIF

IF APRUEBA(24,0,11)
    DO M_CARTEL WITH 10,24,0,.T.,.F.,.T.
    ESPERAR(0)
    IMPRE = .T.
ENDIF

SELE 2
IF IMPRE
    SET DEVI TO PRINT
ENDIF

M_PT = 0
M_AF = 0
LINEAS = 70
PRIMERA = .T.
DO WHILE !EOF()
      IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA
           IF LINEAS > 63 .AND. IMPRE
                 DO ENC_BRUTO
           ENDIF
           IF LINEAS > 20 .AND. !IMPRE
                 DO ENC_BRUTO
                 IF LASTKEY() = 27
                     GO BOTTOM
                     SKIP
                     LOOP
                 ENDIF
           ENDIF
           IF TIPO = 'FAC' .OR. TIPO = 'NCR' .OR. TIPO = 'CDO'
                SELE 1
                SEEK DETALLE1->TIPO + STR(DETALLE1->NUMERO,5,0)
                IF !ANULADA
                       M_DESCU = BONIF * 100 / TOTAL
                       SELE 5
                       SEEK COMPRO1->CLIENTE
                       SELE 1
                       IF M_PROVI <> 99
                            IF PROVI <> M_PROVI
                                SELE 2
                                SKIP
                                LOOP
                            ENDIF
                       ENDIF
                       SELE 4
                       SEEK DETALLE1->ARTICULO
                       IF !FOUND()
                            SELE 3
                            SEEK DETALLE1->ARTICULO
                            SELE 2
                            IF TIPO = 'CDO'
                                  M_PRE = PRECIO / 1.21
                                  M_IMP = (M_PRE * CANTIDAD) - ((M_PRE * CANTIDAD) * M_DESCU / 100)
                            ELSE
                                  M_IMP = (PRECIO * CANTIDAD) - ((PRECIO * CANTIDAD) * M_DESCU / 100)
                            ENDIF
                            IF TIPO = 'FAC' .OR. TIPO ='CDO'
                               M_PT = M_PT + M_IMP
                               @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + ' ' + TRANSFORM(M_IMP,'###,###.##')
                            ELSE
                               M_PT = M_PT - M_IMP
                               @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + ' ' + TRANSFORM(M_IMP,'-##,###.##')
                            ENDIF
                            LINEAS = LINEAS + 1
                       ELSE
                            SELE 2
                            IF TIPO = 'FAC' .OR. TIPO = 'CDO'
                                IF TIPO = 'CDO'
                                     M_PRE = PRECIO / 1.21
                                     M_IMP = (M_PRE * CANTIDAD) - ((M_PRE * CANTIDAD) * M_DESCU / 100)
                                ELSE
                                     M_IMP = (PRECIO * CANTIDAD) - ((PRECIO * CANTIDAD) * M_DESCU / 100)
                                ENDIF
                                M_AF = M_AF + M_IMP
                                @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + '                ' + TRANSFORM(M_IMP,'###,###.##')
                            ELSE
                                M_IMP = (PRECIO * CANTIDAD) - ((PRECIO * CANTIDAD) * M_DESCU / 100)
                                M_AF = M_AF - M_IMP
                                @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + '                ' + TRANSFORM(M_IMP,'-##,###.##')
                            ENDIF
                            LINEAS = LINEAS + 1
                       ENDIF
                ENDIF
           ENDIF
      ENDIF
      SELE 2
      SKIP
ENDDO
SELE 1
GO TOP
SEEK 'NC2'
DO WHILE !EOF()
     IF M_PROVI <> 99
          IF PROVI <> M_PROVI
              SKIP
              LOOP
          ENDIF
     ENDIF
     IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA .AND. !ANULADA
           IF LINEAS > 65 .AND. IMPRE
                 DO ENC_BRUTO
           ENDIF
           IF LINEAS > 20 .AND. !IMPRE
                 DO ENC_BRUTO
           ENDIF
           IF  TIPO = 'NC2'
               SET COLOR TO W+
               IF DISTRI = 'S'
                   M_PT = M_PT - TOTAL
                   @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + ' ' + TRANSFORM(TOTAL,'###,###.##')
                   LINEAS = LINEAS + 1
               ELSE
                   M_AF = M_AF - TOTAL
                   @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + '                ' + TRANSFORM(TOTAL,'###,###.##')
                   LINEAS = LINEAS + 1
               ENDIF
               SET COLOR TO
           ELSE
               IF TIPO = 'NDB'
                   IF DISTRI = 'S'
                      M_PT = M_PT + TOTAL
                      @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + ' ' + TRANSFORM(TOTAL,'###,###.##')
                      LINEAS = LINEAS + 1
                   ELSE
                      M_AF = M_AF + TOTAL
                      @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + '                ' + TRANSFORM(TOTAL,'###,###.##')
                      LINEAS = LINEAS + 1
                   ENDIF
               ENDIF
           ENDIF
     ENDIF
     SKIP
ENDDO
IF IMPRE
   EJECT
ELSE
   DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
   ESPERAR(0)
   CLEAR
   DO TITULO
   @ 1,0 TO 23,79 DOUBLE
   @ 5,1 TO 5,78
   SET COLOR TO I
ENDIF
@ 3,30 SAY 'RESUMEN DE VENTA P/INGRESOS BRUTOS'
SET COLOR TO
@ 8,3 SAY 'Desde Fecha : ' + DTOC(M_DESDE) + ' Hasta Fecha : ' + DTOC(M_HASTA)
IF M_PROVI = 99
   @ 10,3 SAY 'Provincia : TODAS'
ELSE
   @ 10,3 SAY 'Provincia : ' + PROVI->NOMBRE
ENDIF
M_SUMA = (M_AF*M_COEFI/100) + (M_PT*M_COEFI1/100)
IF M_PROVI <> 99
   @ 12,3 SAY 'Total Bruto de P.Fabricacion : ' + TRANSFORM(M_AF,'###,###.##') + ' por ' + TRANSFORM(M_COEFI,'###.##') + ' %   ==>' + TRANSFORM(M_AF*M_COEFI/100,'###,###.###')
   @ 13,3 SAY 'Total Bruto de P.Terminados  : ' + TRANSFORM(M_PT,'###,###.##') + ' por ' + TRANSFORM(M_COEFI1,'###.##') + ' %   ==>' + TRANSFORM(M_PT*M_COEFI1/100,'###,###.###')
ELSE
   @ 12,3 SAY 'Total Bruto de P.Fabricacion : ' + TRANSFORM(M_AF,'###,###.##')
   @ 13,3 SAY 'Total Bruto de P.Terminados  : ' + TRANSFORM(M_PT,'###,###.##')
ENDIF
SET COLOR TO W+
@ 15,3 SAY 'Total Bruto General vendido  : ' + TRANSFORM(M_AF + M_PT,'###,###.##') + '                   ' + IIF(M_PROVI <> 99,TRANSFORM(M_SUMA,'###,###.###'),'')
SET COLOR TO
IF IMPRE
   EJECT
   SET DEVI TO SCREEN
ELSE
   DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
   ESPERAR(0)
ENDIF
CLOSE ALL
RETURN


PROCEDURE ENC_BRUTO
********************
LINEAS = 1
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

@ LINEAS,30 SAY 'RESUMEN DE VENTA P/INGRESOS BRUTOS'
SET COLOR TO
@ LINEAS + 1,3 SAY 'Desde Fecha : ' + DTOC(M_DESDE) + ' Hasta Fecha : ' + DTOC(M_HASTA)
IF M_PROVI = 99
   @ LINEAS + 2,3 SAY 'Provincia : TODAS'
ELSE
   @ LINEAS + 2,3 SAY 'Provincia : ' + PROVI->NOMBRE
ENDIF
@ LINEAS + 3,1 SAY REPLICATE('=',79)
@ LINEAS + 4,1 SAY 'FECHA   COMPROBANTE  DISTRIBUCION    FABRICACION'
@ LINEAS + 5,1 SAY REPLICATE('=',79)
LINEAS = 7
RETURN


PROCEDURE FACOB
***************
*Listado de facturas cobradas
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
     @ 3,28 SAY 'LISTADO DE FACTURAS COBRADAS'
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
        USE &ARCHIVO INDEX &INDICE
        IF VAL(M_VEND) <> 9999999999
            SET FILTER TO CAJERO = M_VEND
        ENDIF
        GO TOP
        DO WHILE !EOF()
               IF LINEAS > 66 .AND. IMPRE
                      DO ENC_COB
               ENDIF
               IF LINEAS > 20 .AND. !IMPRE
                       DO ENC_COB
               ENDIF
               IF TIPO = 'FAC' .OR. TIPO = 'NDB' .OR. TIPO = 'AJD' .OR. TIPO = 'CDO'
                     IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA .AND. CANCELADA .AND. !ANULADA
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
                            M_TOTAL = TRANSFORM((TOTAL + IVA + REC_IVA) - BONIF,'###,###,###.##')
                            M_T = (TOTAL + IVA  + REC_IVA) - BONIF
                            IF M_T <> 0
                               @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + '       ' + SUBSTR(CLIENTES->NOMBRE,1,21) + ' ' + M_TOTAL
                               LINEAS = LINEAS + 1
                               M_ACOB = M_T + M_ACOB
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
         @ LINEAS + 2,1 SAY 'Total Cobrado  : '
         @ LINEAS + 2,48 SAY TRANSFORM(M_ACOB,'###,###,###.##')
         @ LINEAS + 3,1 SAY '                                            =================='
         EJECT
         SET DEVI TO SCREEN
     ELSE
         @ LINEAS + 1,1 SAY '                                            =================='
         @ LINEAS + 2,1 SAY 'Total Cobrado  : '
         @ LINEAS + 2,48 SAY TRANSFORM(M_ACOB,'###,###,###.##')
         @ LINEAS + 3,1 SAY '                                            =================='
         DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
         ESPERAR(0)
     ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE ENC_COB
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
@ LINEAS,20 SAY 'LISTADO DE FACTURAS COBRADAS'
@ LINEAS +2,2 SAY 'Desde Fecha : ' + DTOC(M_DESDE) + ' Hasta Fecha : ' + DTOC(M_HASTA)
@ LINEAS +3,2 SAY 'Hoja Nro: ' + STR(HOJA,3,0)
IF VAL(M_VEND) <> 9999999999
     @ LINEAS + 3,30 SAY 'Vendedor : ' + VENDEDOR->NOMBRE
ELSE
     @ LINEAS + 3,30 SAY 'Vendedor : ' + 'TODOS'
ENDIF
@ LINEAS + 4,1 SAY 'Zona : ' + IIF(M_ZONA = '9999999999','TODAS',M_ZONA)
@ LINEAS + 5,1 SAY REPLICATE('=',79)
@ LINEAS + 6,1 SAY 'Fecha  Comprob. Nro.      Cliente            Imp. Cobrado'
@ LINEAS + 7,1 SAY REPLICATE('=',79)
HOJA = HOJA + 1
LINEAS = 9
RETURN


PROCEDURE FAPAG
***************
*Listado de facturas pagadas
*
*
SELE 12
USE PROVEDOR INDEX PROVEDOR

M_DESDE = DATE()
M_HASTA = DATE()
M_PROV = SPACE(10)
DO WHILE .T.
     CLEAR
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     @ 1,0 TO 23,79 DOUBLE
     DO TITULO
     SET COLOR TO I
     @ 3,25 SAY 'LISTADO DE FACTURAS PAGADAS A PROVEEDORES'
     SET COLOR TO
     @ 5,1 TO 5,78
     @ 8,3 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
     @ 10,3 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA) .AND. M_HASTA >= M_DESDE
     @ 12,3 SAY 'Proveedor (999999999= Todos) : ' GET M_PROV PICT '@!' VALID VALPROV(12,45,M_PROV)
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
        INDICE = 'COMPRAS'
        USE &ARCHIVO INDEX &INDICE
        IF M_PROV <> '9999999999'
            SET FILTER TO PROVEDOR = M_PROV
        ENDIF
        GO TOP
        DO WHILE !EOF()
               IF LINEAS > 66 .AND. IMPRE
                      DO ENC_PAG
               ENDIF
               IF LINEAS > 20 .AND. !IMPRE
                       DO ENC_PAG
               ENDIF
               IF TIPO = 'REC'
                     IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA .AND. !ANULADA
                            SELE 12
                            SEEK &ARCHIVO->PROVEDOR
                            SELE 1
                            M_TOTAL = TRANSFORM(IMP_BRUTO,'###,###,###.##')
                            M_T = IMP_BRUTO
                            IF M_T <> 0
                               @ LINEAS,1 SAY DTOC(FECHA) + ' ' + TIPO + ' ' + STR(FACTURA,10,0) + '  ' + SUBSTR(PROVEDOR->NOMBRE,1,21) + ' ' + M_TOTAL
                               LINEAS = LINEAS + 1
                               M_ACOB = M_T + M_ACOB
                            ENDIF
                     ENDIF
               ENDIF
               SKIP
        ENDDO
        SET FILTER TO
     NEXT
     IF IMPRE
         @ LINEAS + 1,1 SAY '                                            =================='
         @ LINEAS + 2,1 SAY 'Total Pagado   : '
         @ LINEAS + 2,48 SAY TRANSFORM(M_ACOB,'###,###,###.##')
         @ LINEAS + 3,1 SAY '                                            =================='
         EJECT
         SET DEVI TO SCREEN
     ELSE
         @ LINEAS + 1,1 SAY '                                            =================='
         @ LINEAS + 2,1 SAY 'Total Pagado   : '
         @ LINEAS + 2,48 SAY TRANSFORM(M_ACOB,'###,###,###.##')
         @ LINEAS + 3,1 SAY '                                            =================='
         DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
         ESPERAR(0)
     ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE ENC_PAG
*****************

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
@ LINEAS,20 SAY 'LISTADO DE FACTURAS PAGADAS A PROVEEDORES'
@ LINEAS +2,2 SAY 'Desde Fecha : ' + DTOC(M_DESDE) + ' Hasta Fecha : ' + DTOC(M_HASTA)
@ LINEAS +3,2 SAY 'Hoja Nro: ' + STR(HOJA,3,0)
IF M_PROV <> '9999999999'
     @ LINEAS + 3,30 SAY 'Proveedor : ' + PROVEDOR->NOMBRE
ELSE
     @ LINEAS + 3,30 SAY 'Proveedor : ' + 'TODOS'
ENDIF
@ LINEAS + 5,1 SAY REPLICATE('=',79)
@ LINEAS + 6,1 SAY 'Fecha  Comprob. Nro.      Proveedor          Imp. Pagado'
@ LINEAS + 7,1 SAY REPLICATE('=',79)
HOJA = HOJA + 1
LINEAS = 9
RETURN
