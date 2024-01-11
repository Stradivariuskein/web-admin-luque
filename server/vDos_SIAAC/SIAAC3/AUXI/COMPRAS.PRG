*Compras de materias primas. - Programa para fabricas

DO WHILE .T.
      DECLARE MENPEE[10]
      DECLARE OPPEE[10]
      OPPEE[1]=  'ABM DE MATERIAS PRIMAS'
      OPPEE[2]=  'ABM DE PRODUCTOS DE FABRICACION'
      OPPEE[3]=  'CONSULTA DE COSTOS DE P.FABRICACION'
      OPPEE[4]=  'COMPRAS EN GENERAL'
      OPPEE[5]=  'STOCK M. P.'
      OPPEE[6]=  'PAGOS DE FACTURAS DE PROVEEDORES'
      OPPEE[7]=  'MANEJO DE PROVEEDORES'
      OPPEE[8] = 'AJUSTE de SALDOS PROVEEDORES'
      OPPEE[9]=  'AJUSTE de STOCK de MATERIAS PRIMAS'
      OPPEE[10] = 'PARTE DIARIO DE PRODUCCION'

      MENPEE[1]='          ºAltas, Bajas y Modificaciones de Materias Primas'
      MENPEE[2]='          ºAltas, Bajas y Modificaciones de P.Fabricacion'
      MENPEE[3]='          ºCostos'
      MENPEE[4]='          ºCompra de M. Prima a Proveedores - Factura y Carga IVA'
      MENPEE[5]='          ºStock de Materias Primas'
      MENPEE[6]='          ºPago de Facturas a Proveedores'
      MENPEE[7]='          ºSaldos de c/u de los Proveedores'
      MENPEE[8]='          ºAjustes de Saldos de los Proveedores'
      MENPEE[9]='          ºAjuste de Stock de M.P.'
      MENPEE[10]='          ºParte de Produccion'

      *Displaya opciones y captura.
       OPPE=OPCIONES('MANEJO DE PROVEEDORES',OPPEE,MENPEE)
      *Fin
      IF LASTKEY() = 27
           EXIT
      ENDIF
      DO CASE
          CASE OPPE = 1
               DO ABMMP
          CASE OPPE = 2
               DO ABMSUB
          CASE OPPE = 3
               DO CONS_COSTO
          CASE OPPE = 4
               DO INGMERC3
          CASE OPPE = 5
               DO STOCKMP
          CASE OPPE = 6
               DO PAGO_PRO
           CASE OPPE = 7
               DO CTAPRO
           CASE OPPE = 8
               DO AJUS_PRO
           CASE OPPE = 9
               DO BAJASTK
           CASE OPPE = 10
               DO PART_DI
      ENDCASE
ENDDO
CLOSE ALL
RETURN

PROCEDURE INGMERC3
******************
*Ingreso de Mercaderia de Proveedores.PARA FABRICAS QUE DETALLAN ARTICULO TIPO M.P.

*IF !SEGURIDAD(MM_CLAVE,'H')
*     DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*     ESPERAR(0)
*     RETURN
*ENDIF

SELE 25
USE IVA

SELE 4
USE COMPRAS INDEX COMPRAS

SELE 5
USE RUBROS INDEX RUBROS

SELE 6
USE CONTADO1 INDEX CONTADO1

SELE 12
USE PROVEDOR INDEX PROVEDOR

SELE 1
USE MPRIMA INDEX MPRIMA

SELE 2
USE ARTIC INDEX ARTIC

SELE 9
USE PEDPROV INDEX PEDPROV

SELE 10
USE PEDPROV2 INDEX PEDPROV2

SELE 8
USE CAJAIG INDEX CAJAIG,CAJAIG2,CAJAIG3
SET ORDER TO 1

PRIVATE M_PROV,M_ART,M_CANT,R5,PRIMERA,TOT_FPR,PROVE_ANT
PRIMERA = .T.

V_ARTI = ARRAY(35)
V_CANTIDAD = ARRAY(35)
V_MP = ARRAY(35)
V_DESCR = ARRAY(35)
V_PRECIO = ARRAY(35)

R5 = .F.
DO WHILE .T.
      CLEAR
      DO TITULO
      @ 1,0 TO 23,79 DOUBLE
      SET COLOR TO I
      @ 3,20 SAY ' * INGRESO DE MERCADERIA DE PROVEEDORES * '
      SET COLOR TO
      @ 6,1 TO 6,78
      DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
      DO WHILE .T.
          M_PROV = SPACE(10)
          IF R5
             @ 23,79 SAY '.'
          ENDIF
          M_PROV = SPACE(10)
          DO WHILE .T.
             @ 8,2 SAY 'C¢d.de Proveedor (ENTER = VENTANA | 9999999999 = ALTA PROV): ' GET M_PROV PICT '@!'
             READ
             IF LASTKEY() = 27
               EXIT
             ENDIF
             IF VAL(M_PROV) = 9999999999
                SAVE SCREEN TO M_PANTA
                DO ABMPROV WITH .F.
                RESTORE SCREEN FROM M_PANTA
                LOOP
             ENDIF
             EXIT
          ENDDO
          IF LASTKEY() = 27
              EXIT
          ENDIF
          IF EMPTY(ALLTRIM(M_PROV))
              M_PROV = SELE_PROV(8,40,20)
              IF EMPTY(M_PROV)
                 EXIT
              ENDIF
          ELSE
              M_PROV = M_PROV
          ENDIF
          SELE 12
          SEEK M_PROV
          IF FOUND()
               EXIT
          ELSE
               DO M_CARTEL WITH 13,24,0,.T.,.T.,.T.
               ESPERAR(0)
               @ 24,0 SAY SPACE(79)
          ENDIF
      ENDDO
      IF LASTKEY() = 27
            EXIT
      ENDIF
      DO WHILE .T.
           CLEAR
           DO TITULO
           DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
           @ 1,0 TO 23,79 DOUBLE
           @ 5,2 TO 7,34
           SET COLOR TO I
           @ 6,3 SAY SUBSTR(PROVEDOR->NOMBRE,1,30)
           SET COLOR TO
           IF R5
              @ 23,79 SAY '.'
           ENDIF
           SELE 6
           IF !R5
               SEEK 'INT'
           ELSE
               SEEK 'IR5'
           ENDIF
           M_INT = NUMERO
           M_FACTURA = 0
           M_IMPB = 0
           M_PAGA = 'N'
           M_FECHF = M_FECHA
           M_TIPO = 'FAC'
           M_VENC = M_FECHA
           M_PEDIDO = 0
           @  8,6 SAY 'Numero Interno de Comproban.: ' + STR(M_INT,5,0)
           @ 10,6 SAY 'Numero de Compro.: ' GET M_FACTURA PICT '##########' VALID M_FACTURA >=0
           @ 10,50 SAY 'Tipo (FAC,NDB,NCR) ' GET M_TIPO PICT 'AAA' VALID M_TIPO = 'FAC' .OR. M_TIPO = 'NDB' .OR. M_TIPO = 'NCR'
           @ 11,6 SAY 'Numero de Pedido (0=NINGUNO): ' GET M_PEDIDO VALID VALPEDI()
           @ 13,6 SAY 'Importe Neto                : ' GET M_IMPB PICT '##########.##' VALID M_IMPB >= 0
           READ
           IF LASTKEY() = 27
                 EXIT
           ENDIF
           M_IVA =  M_IMPB * IVA->IVA / 100
           M_ADIC = 0
           M_RETE = 0
           @ 14,6 SAY 'Importe IVA                 : ' GET M_IVA PICT  '##########.##'
           @ 15,6 SAY 'Adicional Iva               : ' GET M_ADIC PICT '##########.##'
           @ 16,6 SAY 'Retenciones                 : ' GET M_RETE PICT '##########.##'
           READ
           IF LASTKEY() = 27
                LOOP
           ENDIF
           M_NETO = M_IVA + M_IMPB + M_ADIC + M_RETE
           @ 17,6 SAY 'Importe Total               : ' GET M_NETO PICT '##########.##'
           @ 18,6 SAY 'Pagada (S)i o (N)o          : ' GET M_PAGA  VALID M_PAGA = 'S' .OR. M_PAGA = 'N'
           @ 20,6 SAY 'Fecha Factura               : ' GET M_FECHF PICT '99/99/99' VALID VALFECH(M_FECHF)
           @ 22,6 SAY 'Vencimiento                 : ' GET M_VENC PICT '99/99/99' VALID VALFECH(M_VENC)
           READ
           IF LASTKEY() = 27
                 EXIT
           ENDIF
           IF M_PAGA = 'S'
               M_RUBRO = SELE_RUB(5,58,22,1)
               SET COLOR TO W+
               @ 18,50 SAY SUBSTR(RUBROS->DESCR,1,20)
               SET COLOR TO
               M_NROREC = SPACE(10)
               @ 19,6 SAY 'Recibo Numero               : ' GET M_NROREC PICT '@!'
               READ
           ENDIF
           IF APRUEBA(24,0,2)
             DO PIDE_REST
             IF LASTKEY() = 27
                 LOOP
             ENDIF
             IF APRUEBA(24,0,53)
               FOR I = 1 TO 35
                    IF !EMPTY(ALLTRIM(V_ARTI[I]))
                          IF V_MP[I] = 'S'
                              SELE 1
                          ELSE
                              SELE 2
                          ENDIF
                          SEEK V_ARTI[I]
                          REPLACE STOCK WITH STOCK + V_CANTIDAD[I]
                          REPLACE COSTO WITH V_PRECIO[I]
                    ENDIF
               NEXT
               IF M_PEDIDO <> 0
                   FOR I = 1 TO 35
                       SELE 10
                       SEEK STR(M_PEDIDO,5,0)
                       DO WHILE !EOF() .AND. NUMERO = M_PEDIDO
                              IF ALLTRIM(ARTICULO) = ALLTRIM(V_ARTI[I])
                                    IF CANTIDAD - ENTREGADO > 0
                                       REPLACE ENTREGADO WITH ENTREGADO + V_CANTIDAD[I]
                                       GO BOTTOM
                                       SKIP
                                       LOOP
                                    ENDIF
                              ENDIF
                              SKIP
                       ENDDO
                   NEXT
                   SELE 9
                   SEEK M_PEDIDO
                   REPLACE PENDIENTE WITH BUSCA_PENDI(M_PEDIDO,'9','10')
               ENDIF
               SELE 4
               APPEND BLANK
               REPLACE N_INT WITH M_INT
               REPLACE FACTURA WITH M_FACTURA
               REPLACE FECHA WITH M_FECHF
               REPLACE IMP_BRUTO WITH M_IMPB
               REPLACE IVA WITH M_IVA
               REPLACE ADIC WITH M_ADIC
               REPLACE RETE WITH M_RETE
               REPLACE IMP_NETO WITH M_NETO
               REPLACE PROVEDOR WITH M_PROV
               REPLACE ESTADO WITH IIF(M_PAGA='S','P','I')
               REPLACE TIPO WITH M_TIPO
               REPLACE ANULADA WITH .F.
               REPLACE VENC WITH M_VENC
               IF M_PAGA = 'S'
                     APPEND BLANK
                     REPLACE N_INT WITH 0
                     REPLACE FACTURA WITH VAL(M_NROREC)
                     REPLACE FECHA WITH M_FECHF
                     REPLACE IMP_BRUTO WITH M_IMPB + M_IVA + M_RETE + M_ADIC
                     REPLACE IVA WITH 0
                     REPLACE IMP_NETO WITH 0
                     REPLACE PROVEDOR WITH M_PROV
                     REPLACE ESTADO WITH 'P'
                     REPLACE TIPO WITH 'REC'
                     REPLACE ANULADA WITH .F.
                     REPLACE VENC WITH M_VENC
                     SELE 6
                     REPLACE NUMERO WITH NUMERO + 1
                     SEEK 'ING'
                     SELE 8
                     APPE BLANK
                     REPLACE NRO WITH CONTADO1->NUMERO
                     REPLACE RUBRO WITH M_RUBRO
                     REPLACE DETALLE WITH 'PAGO A ' + PROVEDOR->NOMBRE
                     REPLACE IMPESOS WITH M_IMPB + M_IVA + M_RETE + M_ADIC
                     REPLACE IMPDOC WITH 0
                     REPLACE IMPDOL WITH 0
                     REPLACE CANCELA WITH 'S'
                     REPLACE FECHA WITH M_FECHF
                     REPLACE NROREC WITH M_NROREC
                     REPLACE VALES WITH 'N'
                     REPLACE TIPO WITH 'E'
                     SELE 6
                     REPLACE NUMERO WITH NUMERO + 1
               ELSE
                     SELE 6
                     REPLACE NUMERO WITH NUMERO + 1
               ENDIF
           ENDIF
         ENDIF
      ENDDO
ENDDO
CLOSE ALL
RETURN


PROCEDURE PIDE_REST
********* *********
*pide detalle de materias primas.

IF M_PEDIDO = 0
   AFILL(V_ARTI,SPACE(10))
   AFILL(V_CANTIDAD,0)
   AFILL(V_MP,'N')
   AFILL(V_DESCR,SPACE(20))
   AFILL(V_PRECIO,0)
   I = 1
ELSE
   AFILL(V_ARTI,SPACE(10))
   AFILL(V_CANTIDAD,0)
   AFILL(V_MP,'N')
   AFILL(V_DESCR,SPACE(20))
   AFILL(V_PRECIO,0)
   SELE 10
   SEEK STR(M_PEDIDO,5,0)
   IF PEDPROV->PENDIENTE
        DO M_CARTEL WITH 111,24,0,.T.,.T.,.T.
        ESPERAR(0)
        IF LASTKEY() = 27
             RETURN
        ENDIF
   ENDIF
   I = 1
   DO WHILE !EOF() .AND. NUMERO = M_PEDIDO
        IF CANTIDAD - ENTREGADO > 0
           V_ARTI[I] = ARTICULO
           V_CANTIDAD[I] = CANTIDAD - ENTREGADO
           V_MP[I] = MP
           V_DESCR[I] = DESCR
           V_PRECIO[I] = PRECIO
           I = I + 1
        ENDIF
        SKIP
   ENDDO
ENDIF
M_CUAL = 'P'
M_IT = I
M_ULT = M_IT
DO WHILE .T.
    CLEAR
    DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
    @ 1,0 TO 20,79 DOUBLE
    DO TITULO
    SET COLOR TO I
    @ 3,30 SAY '* DETALLE DE MERCADERIA INGRESADA * '
    SET COLOR TO
    @ 4,2 TO 4,78
    SET COLOR TO W+
    @ 5,1 SAY 'ITEM              ARTICULO                           CANTIDAD     PRECIO'
    SET COLOR TO
    @ 6,1 TO 6,78
    DO MUES_PEDI
    DO WHILE .T.
          @ 20,0 CLEAR TO 23,79
          @ 20,0 TO 23,79
          DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
          M_ULT = M_IT
          @ 21,1 SAY 'ITEM (-1 FIN): ' GET M_IT PICT '##' VALID M_IT <= M_ULT
          READ
          IF M_IT = -1
             EXIT
          ENDIF
          IF M_IT < M_ULT
               M_HACE = 'M'
               @ 24,0 SAY SPACE(79)
               @ 24,0 SAY 'Desdea (M)odificar el Item o (A)nularlo : ' GET M_HACE PICT  'A' VALID M_HACE = 'M' .OR. M_HACE = 'A'
               READ
               DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
               IF LASTKEY() = 27
                   LOOP
               ENDIF
               IF M_HACE = 'A'
                    V_ARTI[M_IT] = SPACE(10)
                    V_PRECIO[M_IT] = 0
                    V_CANTIDAD[M_IT] = 0
                    V_DESCR[M_IT] = SPACE(30)
                    V_MP[M_IT] = 'N'
                    DO ANULA_ITPE WITH M_IT
                    DO MUES_PEDI
                    M_IT = M_ULT - 1
                    LOOP
               ENDIF
          ENDIF
          @ 21,22 SAY 'M.Prima : ' GET V_MP[M_IT] PICT 'A' VALID V_MP[M_IT] = 'S' .OR. V_MP[M_IT] = 'N'
          READ
          IF LASTKEY() = 27
              LOOP
          ENDIF
          IF V_MP[M_IT] = 'S'
               SELE 1
          ELSE
               SELE 2
          ENDIF
          @ 21,38 SAY 'Art. : ' GET V_ARTI[M_IT] PICT '@!' VALID VALARTI(22,1,V_ARTI[M_IT])
          READ
          IF LASTKEY() = 27
              LOOP
          ENDIF
          V_DESCR[M_IT] = IIF(!EMPTY(ALLTRIM(V_DESCR[M_IT])),V_DESCR[M_IT],DESCR)
          V_PRECIO[M_IT] = IIF(V_PRECIO[M_IT] <> 0,V_PRECIO[M_IT],COSTO)
          @ 22,1 GET V_DESCR[M_IT] PICT '@!'
          @ 21,58 SAY 'Cantidad : ' GET V_CANTIDAD[M_IT] PICT '#####.###'
          @ 22,58 SAY 'Precio : ' GET V_PRECIO[M_IT] PICT '#######.####'
          READ
          IF LASTKEY() = 27
              LOOP
          ENDIF
          IF APRUEBA(24,0,2)
                DO MUES_PEDI
                IF M_IT = M_ULT
                   M_IT = M_IT + 1
                ELSE
                   M_IT = M_ULT
                ENDIF
                IF M_IT = 25
                   EXIT
                ENDIF
          ENDIF
    ENDDO
    EXIT
ENDDO
RETURN


PROCEDURE STOCKMP
*****************
SELE 1
USE MPRIMA INDEX MPRIMA

GO TOP
M_ART = SPACE(10)
@ 24,0 SAY SPACE(80)
@ 24,10 SAY 'Articulo: (9999999999 = Todos) : ' GET M_ART PICT '@!'
READ
IF LASTKEY() = 27
    RETURN
ENDIF

@ 24,0 SAY SPACE(79)
IMPRE = .F.
IF APRUEBA(24,0,11)
     SET DEVICE TO PRINT
     IMPRE = .T.
ENDIF


IF M_ART <> '9999999999'
     SEEK M_ART
ENDIF

LINEAS = 70
PRIMERA = .T.
HOJA = 1
M_TOTAL = 0
DO WHILE !EOF()
        IF LINEAS > 65 .AND. IMPRE
              DO ENC_SMP
        ENDIF
        IF LINEAS > 20 .AND. !IMPRE
              DO ENC_SMP
              IF LASTKEY() = 27
                 GO BOTTOM
                 SKIP
                 LOOP
              ENDIF
        ENDIF
        @ LINEAS,1 SAY CODIGO + ' ' + SUBSTR(DESCR,1,28) + ' ' + STR(STOCK,10,2)  + ' ' + UNIDAD + ' ' + TRANSFORM(COSTO,'#,###.####') + ' ' + TRANSFORM(COSTO * STOCK,'###,###.##')
        M_TOTAL = M_TOTAL + (COSTO * STOCK)
        LINEAS = LINEAS + 1
        IF M_ART = '9999999999'
                SKIP
        ELSE
                GO BOTTOM
                SKIP
        ENDIF

ENDDO
@ LINEAS + 1,1 SAY 'Total de Plata en Stock : ' + TRANSFORM(M_TOTAL,'###,###.##')
IF IMPRE
   EJECT
   SET DEVICE TO SCREEN
ELSE
   @ 22,3 SAY 'Pulse una Tecla Para Seguir...'
   ESPERAR(0)
   @ 24,0 SAY SPACE(79)
ENDIF
RETURN


PROCEDURE ENC_SMP
********* *******
*Encabeza Stock de M.P.
LINEAS = 1
IF PRIMERA
    IF IMPRE
        PRIMERA = .F.
    ELSE
        CLEAR
        PRIMERA = .F.
    ENDIF
ELSE
   IF IMPRE
         EJECT
   ELSE
         @ 22,3 SAY 'Pulse una Tecla para Seguir'
         ESPERAR(0)
         CLEAR
   ENDIF
ENDIF


@ LINEAS,20 SAY '* STOCK de MATERIAS PRIMAS *'
@ LINEAS + 2,60 SAY 'HOJA: ' + STR(HOJA,3,0)
@ LINEAS + 4,1 SAY 'Codigo       Descripcion                     Stock           Costo     Total'
@ LINEAS + 5,0 SAY REPLICATE('=',79)
HOJA = HOJA + 1
LINEAS = 7
RETURN


PROCEDURE PAGO_ACTA
*******************
*Pago a Cuenta de Proveedores


R5 = .F.

SELE 12
USE PROVEDOR INDEX PROVEDOR


DECLARE V_INT[20]
DECLARE V_IMP[20]

DO WHILE .T.
     CLEAR
     DO TITULO
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     IF !R5
         @ 1,0 TO 23,79 DOUBLE
     ELSE
         @ 1,0 TO 23,79 DOUBLE
         @ 23,79 SAY '.'
     ENDIF
     DO TITULO
     @ 3,30 SAY 'PAGO A CUENTA de PROVEEDORES'
     @ 4,1 TO 4,78
     SELE 12
     M_PROV = SELE_PROV(15,30,20)
     SEEK M_PROV
     @ 8,2 SAY 'Proveedor : ' + PROVEDOR->NOMBRE
     M_IMP = 0
     @ 10,2 SAY 'Importe Pagado a Cuenta: ' GET M_IMP PICT '############.##'
     READ
     IF LASTKEY() = 27
         EXIT
     ENDIF
     SELE 1
     USE COMPRAS INDEX COMPRAS
     GO TOP
     FOR I = 1 TO 20
           V_INT[I] = 0
           V_IMP[I] = 0
     NEXT
     I = 0
     DO WHILE !EOF() .AND. M_IMP <> 0
               IF ESTADO = 'I' .AND. PROVEDOR = M_PROV .AND. TIPO = 'FAC' .AND. !ANULADA
                    I = I + 1
                    V_INT[I] = N_INT
                    IF IMP_BRUTO + IVA <= M_IMP
                        V_IMP[I] =  IMP_BRUTO + IVA - ACTA
                    ELSE
                        V_IMP[I] = M_IMP
                    ENDIF
                    M_IMP = M_IMP - V_IMP[I]
               ENDIF
               SKIP
      ENDDO
      IF I = 0
          DO M_CARTEL WITH 69,24,0,.T.,.T.,.T.
          ESPERAR(0)
          LOOP
      ENDIF
      DO MUES_ACTA
      IF APRUEBA(24,0,21)
             SELE 1
             FOR Q = 1 TO 20
                  IF V_INT[Q] <> 0
                        SEEK V_INT[Q]
                        IF IMP_BRUTO + IVA - ACTA - V_IMP[Q] = 0
                               REPLACE ESTADO WITH 'P'
                        ELSE
                               REPLACE ACTA WITH ACTA + V_IMP[Q]
                        ENDIF
                  ENDIF
             NEXT
             DO IMP_RPRO
      ENDIF
      @ 24,0 SAY SPACE(79)
ENDDO
CLOSE ALL
RETURN


PROCEDURE MUES_ACTA
*******************
*Muestra Recibos Acta
F = 10
C = 2
@  9,2 CLEAR TO 22,78
@  9,1 TO 22,79
SELE 1
FOR A = 1 TO 20
    IF V_INT[A] <> 0
        SEEK V_INT[A]
        @ F,C SAY 'FACTURA  ...' + STR(N_INT,5,0) + ' ' + STR(FACTURA,10,0) + '...' + STR(V_IMP[A],14,2)
        F = F + 1
        IF F > 20
             DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
             ESPERAR(0)
             @ 10,2 CLEAR TO 22,78
             F = 10
        ENDIF
    ENDIF
NEXT
RETURN


PROCEDURE IMP_RPRO
******************
*Imprime Recibo de Proveedores
SELE 13
USE CONTADO1 INDEX CONTADO1
SEEK 'RPR'

SET DEVICE TO PRINT
@ PROW(),PCOL() SAY CHR(18)
FOR Q = 1 TO 2
       @ MLINEAS,2 SAY  CHR(14) + IIF(!R5,'DISTRIBUIDORA','MOSQUITO SHOES') + CHR(20)
       @ MLINEAS,30 SAY SUBSTR(PROVEDOR->NOMBRE,1,35)
       @ MLINEAS + 1,2 SAY CHR(14) + IIF(!R5,'GIOVANI  ','        ') + CHR(20)
       @ MLINEAS + 1,35 SAY PROVEDOR->DIRECC
       @ MLINEAS + 2,41 SAY PROVEDOR->LOC
       @ MLINEAS + 3,2 SAY IIF(!R5,'                                 ','')
       @ MLINEAS + 3,41 SAY 'Cod. de Proveedor: ' + STR(PROVEDOR->COD_PRO,5,0)
       @ MLINEAS + 4,2 SAY IIF(!R5,'Telefono : 653-7888','')
       @ MLINEAS + 9,3 SAY 'Buenos Aires  '
       @ MLINEAS + 9,36 SAY DTOC(DATE())
       @ MLINEAS + 9,47 SAY 'RECIBO'
       @ MLINEAS + 9,68 SAY CONTADOR->NUMERO
       @ MLINEAS + 13,3 SAY 'COMPROBANTE  NUMERO      IMPORTE  | COMPROBANTE     NUMERO         IMPORTE'
       MLINEAS =MLINEAS + 16
       M_LIN2 = MLINEAS + 23 - 2
       J = 1
       C = 3
       I = 1
       TOT_REC = 0
       DO WHILE J <= 20
               IF V_INT[I]  <> 0
                 FOR A = 1 TO 2
                     IF V_INT[I] <> 0
                           SELE 1
                           SEEK V_INT[I]
                           @ MLINEAS,C SAY 'FACTURA ' + STR(FACTURA,11,0) +  '   '  +  STR(V_IMP[I],13,2)
                           C = 39
                           TOT_REC = TOT_REC + V_IMP[I]
                           I = I + 1
                           IF A = 2
                              C = 3
                           ENDIF
                     ENDIF
                  NEXT
                  MLINEAS = MLINEAS + 1
               ENDIF
               J = J + 2
       ENDDO
       MLINEAS = M_LIN2
       @ MLINEAS + 6,49 SAY 'Total '
       @ MLINEAS + 6,55 SAY TOT_REC PICT '###,###,###,###.##'
       @ MLINEAS + 14,0 SAY SPACE(1)
       MLINEAS = MLINEAS + 14
NEXT
SET DEVICE TO SCREEN
DO GRAB_RPR
SELE 13
REPLACE NUMERO WITH NUMERO + 1
RETURN

PROCEDURE GRAB_RPR
******************
*Graba Recibo de Proveedores
SELE 1
APPEND BLANK
REPLACE N_INT WITH 0
REPLACE FACTURA WITH CONTADOR->NUMERO
REPLACE TIPO WITH 'RPR'
REPLACE IMP_BRUTO WITH TOT_REC
REPLACE IVA WITH 0
REPLACE ESTADO WITH 'I'
REPLACE PROVEDOR WITH PROVEDOR->COD_PRO
REPLACE FECHA WITH M_FECHA
RETURN


PROCEDURE CTAPRO
****************
*cuentas corrientes de proveedores

SELE 12
USE PROVEDOR INDEX PROVEDOR

SELE 4
USE COMPRAS
INDEX ON FECHA TO AUXILIAR

R5 = .F.
M_AUXI = 0

DO WHILE .T.
   CLEAR
   DO TITULO
   @ 1,0 TO 23,79 DOUBLE
   SET COLOR TO I
   @ 3,25 SAY ' * RESUMEN DE CUENTA DE PROVEEDORES * '
   SET COLOR TO
   @ 6,1 TO 6,78
   DO WHILE .T.
      DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
      SELE 12
      M_PROV = SELE_PROV(8,30,20)
      IF LASTKEY() = 27
         EXIT
      ENDIF
      SEEK M_PROV
      @ 8,3 SAY 'Codigo de Proveedor : ' + PROVEDOR->NOMBRE
      STOR M_FECHA TO M_DESDE,M_HASTA
      @ 10,3 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
      @ 12,3 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
      READ
      IF LASTKEY() = 27
         EXIT
      ENDIF
      IF ALLTRIM(PROVEDOR->NOMBRE) = 'TODOS'
           M_PROV = '9999999999'
      ENDIF
      IF VAL(M_PROV) = 9999999999
         SELE 4
         INDEX ON PROVEDOR TO AUX_CTE
         IF R5
            SELE 7
            INDEX ON PROVEDOR TO AUX_C
         ENDIF
         SET COLOR TO I
         @ 8,39 SAY 'SE IMPRIMEN TODOS'
         SET COLOR TO
         EXIT
      ENDIF
      SEEK M_PROV
      IF !FOUND()
         DO M_CARTEL WITH 13,24,0,.T.,.T.,.T.
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
   SELE 12
   IF VAL(M_PROV) = 9999999999
      GO TOP
   ENDIF
   M_AUXI = M_PROV
   HOJA = 1
   LINEAS = 70
   PRIMERA = .T.
   NO_IMPRE = .F.
   M_TOTAL = 0
   DO WHILE !EOF()
      IF VAL(M_AUXI) = 9999999999
         M_PROV = COD_PRO
      ENDIF
      TOT_DEUDA = 0
      LO = 1
      DO WHILE LO <= 1
         HACE = .T.
         IF LO = 1
            SELE 4
            IF VAL(M_AUXI) = 9999999999
               SEEK M_PROV
               IF !FOUND()
                  GO TOP
               ENDIF
            ELSE
               GO TOP
            ENDIF
         ELSE
            SELE 7
            IF VAL(M_AUXI) = 9999999999
               SEEK M_PROV
               IF !FOUND()
                  GO TOP
               ENDIF
            ELSE
               GO TOP
            ENDIF
         ENDIF
         DO WHILE !EOF() .AND. HACE
            IF LINEAS > 65 .AND. IMPRE
               DO ENC_RESP
               NO_IMPRE = .T.
            ENDIF
            IF LINEAS > 20 .AND. !IMPRE
               DO ENC_RESP
            ENDIF
            IF IMPRE
               IF !NO_IMPRE .AND. LO = 1
                  DO ENC_RES2P
                  NO_IMPRE = .T.
               ENDIF
            ENDIF
            IF M_PROV = PROVEDOR .AND. !ANULADA
               IF TIPO = 'FAC' .OR. TIPO = 'CDO'
                  M_FRASE = 'FACTURA '
               ELSE
                  IF TIPO = 'NDB'
                     M_FRASE = 'N.DEBITO '
                  ELSE
                     IF TIPO = 'ADP'
                        M_FRASE = 'N.CREDIT'
                     ELSE
                        IF TIPO = 'REC'
                           M_FRASE = 'RECIBO  '
                        ELSE
                           IF TIPO =  'APD' .OR. TIPO = 'APA'
                              M_FRASE =  'AJ.SALDO'
                           ELSE
                              SKIP
                              LOOP
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
               IF IMPRE
                  IF !NO_IMPRE
                     DO ENC_RES2P
                  ENDIF
               ENDIF
               IF LO = 1
                  M_IMPAUX = (IMP_BRUTO + IVA + ADIC + RETE)
               ELSE
                  M_IMPAUX = IMP_BRUTO
               ENDIF
               IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA
                   IF TIPO = 'REC' .OR. TIPO = 'ADP' .OR. TIPO = 'APA'
                      @ LINEAS,1 SAY DTOC(FECHA) + ' ' + '(' + STR(N_INT,5,0) + ') ' + M_FRASE + ' ' + STR(FACTURA,10,0) + IIF(TIPO = 'ADP'.OR. TIPO = 'REC',' ',' ') + ' ' + STR(M_IMPAUX,12,2)
                   ELSE
                      @ LINEAS,1 SAY DTOC(FECHA) + ' ' + '(' + STR(N_INT,5,0) + ') ' + M_FRASE + ' ' + STR(FACTURA,10,0) + '              ' + IIF(TIPO = 'ADP'.OR. TIPO = 'REC',' ',' ') + ' ' + STR(M_IMPAUX,12,2)
                   ENDIF
                   LINEAS = LINEAS + 1
               ENDIF
               IF TIPO <> 'REC'
                  TOT_DEUDA = IIF(TIPO = 'ADP'.OR. TIPO = 'APA',TOT_DEUDA - M_IMPAUX,TOT_DEUDA + M_IMPAUX)
               ELSE
                  TOT_DEUDA = TOT_DEUDA - M_IMPAUX
               ENDIF
               SKIP
            ELSE
               IF M_PROV <> PROVEDOR
                  IF VAL(M_AUXI) = 9999999999
                     GO BOTTOM
                     SKIP
                  ELSE
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
         @ LINEAS - 1,68 SAY STR(TOT_DEUDA,12,2)
         M_TOTAL = M_TOTAL + TOT_DEUDA
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
                  SELE 12
                  GO BOTTOM
               ENDIF
        ENDIF
      ENDIF
      SELE 12
      IF VAL(M_AUXI) <> 9999999999
         GO BOTTOM
      ENDIF
      SKIP
   ENDDO
   IF IMPRE
      @ 23,1 SAY 'Total de Deudas a Proveedores : ' + TRANSFORM(M_TOTAL,'###,###,###.##')
      EJECT
      SET DEVICE TO SCREEN
   ELSE
      @ 23,1 SAY 'Total de Deudas a Proveedores : ' + TRANSFORM(M_TOTAL,'###,###,###.##')
      DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
      ESPERAR(0)
      @ 24,0 SAY SPACE(79)
   ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE ENC_RESP
******************
*Encabezamiento del listado de RESUMEN DE CTA.
LINEAS = 1
IF PRIMERA
   IF IMPRE
      @ LINEAS,10 SAY IIF(IMPRE,CHR(14),'                  ') + ' * RESUMEN DE CUENTA DE PROVEEDORES * '
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
   @ LINEAS,10 SAY IIF(!IMPRE,'                  ' + ' * RESUMEN DE CUENTA DE PROVEEDORES * ','')
ENDIF
@ LINEAS + 1,1 SAY REPLICATE('=',79)
@ LINEAS + 2,1 SAY IIF(IMPRE,CHR(27) + CHR(71),'')  +  'Proveedor: ' + ' (' + PROVEDOR->COD_PRO + ' ) '  + RTRIM(PROVEDOR->NOMBRE) + IIF(IMPRE,CHR(27) + CHR(72),'')
@ LINEAS + 3,1 SAY 'FECHA        CONCEPTO       NUMERO         DEBE            HABER        SALDO'
@ LINEAS + 4,1 SAY REPLICATE('=',79)
LINEAS = 6
HOJA = HOJA + 1
RETURN


PROCEDURE ENC_RES2P
********* *********
@ LINEAS,1 SAY REPLICATE('=',79)
@ LINEAS + 1,1 SAY IIF(IMPRE,CHR(27) + CHR(71),'')  +  'Proveedor: ' + ' (' + PROVEDOR->COD_PRO + ' ) '  + RTRIM(PROVEDOR->NOMBRE) + IIF(IMPRE,CHR(27) + CHR(72),'')
LINEAS = LINEAS + 2
RETURN


PROCEDURE AJUS_PRO
******************
*:*********************************************************************
*AJUSTE de SALDOS en LA CUENTA CORRIENTE de PROVEEDORES
*******************************************************************************

SELE 11
USE PROVEDOR INDEX PROVEDOR

SELE 4
USE COMPRAS INDEX COMPRAS

SELE 12
USE DOLAR INDEX DOLAR
SEEK M_FECHA

SELE 13
USE CONTADO1 INDEX CONTADO1

R5 = .F.
M_PROV = SPACE(10)
DO WHILE .T.
   CLEAR
   IF !R5
      @ 1,0 TO 23,79 DOUBLE
   ELSE
      @ 1,0 TO 23,79 DOUBLE
      @ 23,79 SAY '.'
   ENDIF
   DO TITULO
   SET COLOR TO I
   @ 3,30 SAY 'AJUSTE de SALDOS de CUENTAS CORRIENTES'
   DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
   SET COLOR TO
   @ 5,1 TO 5,78
   DO WHILE .T.
      SELE 11
      @ 8,3 SAY 'Codigo de Proveedor:  ' GET M_PROV PICT '@!'
      READ
      IF LASTKEY() = 27
         EXIT
      ENDIF
      SEEK M_PROV
      IF !FOUND()
         DO M_CARTEL WITH 13,24,0,.T.,.T.,.T.
         ESPERAR(0)
         @ 24,0 SAY SPACE(79)
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
         SEEK IIF(M_TIPO = 'D','APD','APA')
         M_NUMERO = NUMERO
         REPLACE NUMERO WITH NUMERO + 1
         SEEK 'INT'
         M_NUM2 = NUMERO
         SELE 4
      ENDIF
      APPEND BLANK
      REPLACE N_INT WITH M_NUM2
      REPLACE TIPO WITH IIF(M_TIPO = 'D','APD','APA')
      REPLACE FACTURA WITH M_NUMERO
      REPLACE IMP_BRUTO WITH M_IMP
      REPLACE PROVEDOR WITH M_PROV
      REPLACE FECHA WITH M_FECHA
      SELE 13
      REPLACE NUMERO WITH NUMERO + 1
      SEEK IIF(M_TIPO = 'D','APD','APA')
      REPLACE NUMERO WITH NUMERO + 1
      SELE 4
      M_SALDO = 0
      GO TOP
      DO WHILE !EOF()
         IF M_PROV = PROVEDOR .AND. !ANULADA
            IF TIPO = 'FAC' .OR. TIPO = 'CDO'
               M_SALDO = M_SALDO + IMP_BRUTO + IVA + ADIC
            ELSE
               IF TIPO = 'REC' .OR. TIPO = 'NDB'
                  M_SALDO = M_SALDO - (IMP_BRUTO + IVA + ADIC)
               ELSE
                  IF TIPO = 'APD' .OR. TIPO = 'APA'
                     IF TIPO = 'APD'
                        M_SALDO = M_SALDO + IMP_BRUTO
                     ELSE
                        M_SALDO = M_SALDO - IMP_BRUTO
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         SKIP
      ENDDO
      SELE 11
      REPLACE SALDO WITH M_SALDO
      IF R5
         SELE 7
         GO TOP
         DO WHILE !EOF()
            IF M_PROV = PROVEDOR .AND. !ANULADA
               IF TIPO = 'FAC' .OR. TIPO = 'CDO'
                  M_SALDO = M_SALDO + IMP_BRUTO + IVA + ADIC
               ELSE
                  IF TIPO = 'REC' .OR. TIPO = 'NDB'
                     M_SALDO = M_SALDO - (IMP_BRUTO + IVA + ADIC)
                  ELSE
                     IF TIPO = 'APD' .OR. TIPO = 'APA'
                        IF TIPO = 'AJD'
                           M_SALDO = M_SALDO + IMP_BRUTO
                        ELSE
                           M_SALDO = M_SALDO - IMP_BRUTO
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
            SKIP
         ENDDO
      ENDIF
   ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE BAJASTK
******************
*Ajusta Stock de Matertia Primas

SELE 1
USE MPRIMA INDEX MPRIMA

M_CODIGO = SPACE(10)

DO WHILE .T.
    CLEAR
    @ 1,0 TO 23,79 DOUBLE
    DO TITULO
    DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
    SET COLOR TO I
    @ 3,25 SAY '* AJUSTE DE STOCK DE MATERIAS PRIMAS * '
    SET COLOR TO
    @ 5,2 TO 5,78
    @ 7,3 SAY 'Ingrese Codigo de Materia Prima : ' GET M_CODIGO PICT '@!'
    READ
    IF LASTKEY() = 27
          EXIT
    ENDIF
    SELE 1
    SEEK M_CODIGO
    IF !FOUND()
         DO M_CARTEL WITH 56,24,0,.T.,.T.,.T.
         ESPERAR(0)
         LOOP
    ENDIF
    SET COLOR TO I
    @ 9,3 SAY DESCR
    SET COLOR TO
    M_CANT = STOCK
    M_FEC = DATE()
    SET COLOR TO I
    @ 11,35 SAY UNIDAD
    SET COLOR TO
    @ 11,3 SAY 'Cantidad: ' GET M_CANT PICT '##########.##' VALID M_CANT >= 0
    @ 13,3 SAY 'Fecha   : ' GET M_FEC PICT '99/99/99' VALID VALFECH(M_FEC)
    READ
    IF LASTKEY() = 27
       LOOP
    ENDIF
    IF APRUEBA(24,0,2)
          SELE 1
          REPLACE STOCK WITH M_CANT
    ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE PAGO_PRO
******************
*Pago a Proveedores
@ 1,0 TO 23,79 DOUBLE
R5 = .F.
DO WHILE .T.
     SELE 1
     USE COMPRAS INDEX COMPRAS

     SELE 12
     USE PROVEDOR INDEX PROVEDOR

     SELE 13
     USE CONTADO1 INDEX CONTADO1
     SEEK 'INT'

     CLEAR
     DO TITULO
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     @ 3,20 SAY ' * PAGO DE FACTURAS DE PROVEEDORES * '
     @ 5,1 TO 5,78
     M_NRO = 1
     @ 7,3 SAY 'Ingrese Numero de Interno de Comprobante: ' GET M_NRO PICT '#####'
     READ
     IF LASTKEY() = 27
        EXIT
     ENDIF
     IF !R5
        SELE 1
     ELSE
        SELE 2
     ENDIF
     SEEK M_NRO
     IF !FOUND()
          DO M_CARTEL WITH 54,24,0,.T.,.T.,.T.
          ESPERAR(0)
          LOOP
     ENDIF
     M_PROV = PROVEDOR
     SELE 12
     SEEK M_PROV
     IF !R5
        SELE 1
     ELSE
        SELE 2
     ENDIF
     M_IMP = IMP_BRUTO + IVA - ACTA + ADIC + RETE
     @ 9,2 TO 20,78
     @ 10,4 SAY 'Comprobante : ' + TIPO
     @ 10,50 SAY 'Numero: ' + STR(FACTURA,10,0)
     IF ANULADA
        SET COLOR TO W+
        @ 11,4 SAY 'COMPROBANTE ANULADO'
        SET COLOR TO
     ENDIF
     @ 12,4 SAY 'Proveedor : ' + PROVEDOR->NOMBRE
     @ 14,4 SAY 'Importe Comprobante     : ' + STR(IMP_BRUTO + IVA+ADIC+RETE,14,2)
     @ 12,50 SAY 'Fecha Comprobante: ' + DTOC(FECHA)
     @ 16,4 SAY 'Importe Pagado a Cuenta : ' + STR(ACTA,14,2)
     MODO = 'C'
     @ 22,4 SAY 'Desea (C)onsultar, (A)nular, (P)agar ' GET MODO PICT 'A' VALID MODO = 'C' .OR. MODO = 'A' .OR. MODO = 'P'
     READ
     IF MODO = 'C'
         LOOP
     ENDIF
     IF MODO = 'A'
           IF APRUEBA(24,0,2)
                REPLACE ANULADA WITH .T.
                LOOP
           ENDIF
     ENDIF
     @ 22,4 SAY SPACE(60)
     IF ESTADO <> 'P'
         @ 18,4 SAY 'Importe a Cancelar      : ' GET M_IMP VALID M_IMP >= 0 .AND. M_IMP <= IMP_BRUTO + IVA - ACTA + ADIC + RETE
         READ
         IF LASTKEY() = 27
               LOOP
         ENDIF
     ELSE
          DO M_CARTEL WITH 55,24,0,.T.,.T.,.T.
          ESPERAR(0)
          LOOP
     ENDIF
     IF APRUEBA(24,0,2)
           REPLACE ESTADO WITH IIF(M_IMP + ACTA= IMP_BRUTO + IVA+ADIC,'P','I')
           REPLACE ACTA WITH IIF(M_IMP + ACTA < IMP_BRUTO + IVA+ADIC,ACTA+M_IMP,0)
           APPEND BLANK
           REPLACE N_INT WITH CONTADO1->NUMERO
           REPLACE TIPO WITH 'REC'
           REPLACE FACTURA WITH CONTADO1->NUMERO
           REPLACE IMP_BRUTO WITH M_IMP
           REPLACE PROVEDOR WITH M_PROV
           REPLACE FECHA WITH M_FECHA
           SELE 13
           REPLACE NUMERO WITH NUMERO + 1
           M_NRORECI = CONTADO1->NUMERO
           IF APRUEBA(24,0,118)
                CLOSE ALL
                DO ABMCAJA WITH .T.,.T.
                CLOSE ALL
           ENDIF
     ENDIF
ENDDO
CLOSE ALL
RETURN



PROCEDURE ABMMP
***************
*Abm De Materias Primas

SELE 2
USE MPRIMA INDEX MPRIMA

SELE 3
USE SUBCONJ2 INDEX SUBCONJ2

SELE 4
USE SUBCONJ INDEX SUBCONJ

SELE 5
USE CONJUNTO INDEX CONJUNTO

SELE 6
USE CONJUN2 INDEX CONJUN2

SELE 12
USE PROVEDOR INDEX PROVEDOR

SELE 13
USE AUXIACT INDEX AUXIACT
ZAP

SELE 15
USE AUXIACT2 INDEX AUXIACT2
ZAP


PRIVATE M_ART,LETRA,MARCA,M_DES,M_PRO,M_PCRI,M_UNID,M_DESCU,M_COSTO,M_LISTA1,M_LISTA2,M_LISTA3,M_LISTA4,M_LISTA5,M_TPRE,M_STOCK,M_MEDIDA
PRIVATE M_COSTOAN,M_COD,M_COD1,M_PROVE

SELE 2
SENIAL=.F.
DO WHILE .T.
   SELE 2
   CLEAR
   DO TITULO
   DO PANTPRIM
   M_ART=SPACE(10)
   @ 4,26 GET M_ART PICT '@!' VALID VALVACIO(M_ART)
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   SEEK M_ART
   IF .NOT. FOUND()
      IF APRUEBA (16,0,39)
         @ 16,0 SAY SPACE(79)
         MARCA=.T.
         DO BLANVPRI
         DO CARGA_PRI
         IF LASTKEY() = 27
            EXIT
         ENDIF
         IF APRUEBA  (16,0,2)
            @ 16,0 SAY SPACE(79)
            SELE 2
            APPEND BLANK
            DO GRABPRI
         ENDIF
      ENDIF
   ELSE
      MARCA=.F.
      DO BLANVPRI
      DO M_CARTEL WITH 35,16,0,.T.,.T.,.T.
      LETRA='M'
      @ 16,66 GET LETRA PICT 'A' VALID LETRA = 'B' .OR. LETRA = 'M'
      READ
      @ 16,0 SAY SPACE(79)
      IF LASTKEY()=27
         LOOP
      ENDIF
      IF LETRA='M'
         DO CARGA_PRI
         IF LASTKEY()=27
            LOOP
         ENDIF
         IF APRUEBA(16,0,36)
            IF SENIAL
               SELE 13
               APPEND BLANK
               REPLACE CODIGO WITH M_ART
               REPLACE COSTO_A WITH M_COSTO
               REPLACE COSTO_AN WITH M_COSTOAN
               SENIAL=.F.
            ENDIF
            @ 16,0 SAY SPACE(79)
            DO GRABPRI
         ENDIF
      ELSE
         IF APRUEBA(16,0,37)
            DO BORRAPRI
            LOOP
         ENDIF
      ENDIF
   ENDIF
ENDDO
SELE 13
IF .NOT. EOF()
   @ 16,0 SAY SPACE(79)
   do m_cartel with 94,16,0,.t.,.t.,.t.
   DO ACTUARCH
ENDIF
CLOSE ALL
RETURN


PROCEDURE PANTPRIM
********* ********

* Muestra la pantalla de articulos


@ 1,1 TO  15,79 DOUBLE
SET COLOR TO I
@ 2,27  SAY " - ABM de COMPONENTES - "
SET COLOR TO
@ 3,2 TO 3,78
@ 4,3 SAY  'Codigo de Componente :'
@ 6,3 SAY  'Descripci¢n          :'
@ 8,3 SAY  'Stock                :'
@ 10,3 SAY 'Unidad               :'
@ 12,3 SAY 'Precio de Costo      :'
@ 13,3 SAY 'Dolar o Pesos        :'
@ 14,3 SAY 'Proveedores          :'

DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
RETURN

PROCEDURE CARGA_PRI
*******************

* Carga de Datos del Articulo

DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
IF .NOT. MARCA
   SET COLOR TO I
   @ 4,26 SAY M_ART PICT '@!'
   SET COLOR TO
ENDIF
SELE 2
M_COSTOAN=M_COSTO
@ 6,30 GET M_DES
@ 8,30 GET M_STOCK PICT '#####.##'
@ 10,30 GET M_UNID
@ 12,30 GET M_COSTO PICT '##########.####'
@ 13,30 GET M_TPRE PICT 'A' VALID M_TPRE = 'D' .OR. M_TPRE = 'P'
@ 14,30 GET M_PROVE PICT '@!S45'
READ
IF M_COSTO <> M_COSTOAN .AND. !MARCA
    SENIAL=.T.
ENDIF
IF LASTKEY()=27
   RETURN
ENDIF
RETURN

PROCEDURE BLANVPRI
******************

* Realiza el Blanqueo de las Variables, en el caso que se trate de una
* Baja o una Modificacion se cargan las Variables con los Datos del Archivo.
IF MARCA
   M_DES=SPACE(30)
   M_PRO=0
   M_UNID=SPACE(5)
   M_COSTO = 0
   M_TPRE = 'D'
   M_STOCK = 0
   M_PROVE = SPACE(80)
ELSE
   M_ART=CODIGO
   M_DES=DESCR
   M_PRO=PROVED
   M_UNID=UNIDAD
   M_COSTO = COSTO
   M_TPRE = TPRE
   M_STOCK = STOCK
   M_PROVE = PROVE
ENDIF
RETURN


PROCEDURE GRABPRI
*****************
* Grabacion del Registro.

SELE 2
REPLACE CODIGO WITH M_ART
REPLACE DESCR WITH M_DES
REPLACE UNIDAD WITH M_UNID
REPLACE COSTO WITH M_COSTO
REPLACE TPRE WITH M_TPRE
REPLACE STOCK WITH M_STOCK
REPLACE PROVE WITH M_PROVE
RETURN


PROCEDURE MUESTPRI
*******************

* En Baja o Modificacion se Displayan los Datos del Articulo.
SET COLOR TO I
@ 6,26 SAY M_DES
SET COLOR TO
RETURN

PROCEDURE BORRAPRI
******************
* Borra el registro seleccionado en todos los archivos.
SELE 3
GO TOP
DO WHILE !EOF()
    IF M_PRIMA = M_ART
        DO M_CARTEL WITH 95,24,0,.T.,.T.,.T.
        ESPERAR(0)
        RETURN
    ENDIF
    SKIP
ENDDO
SELE 2
DELETE
PACK
RETURN

PROCEDURE LIS_PRI
*****************
*Listado de Articulos
SELE 2
USE MPRIMA INDEX MPRIMA

IMPRE = .F.
@ 24,0 SAY SPACE(79)
IF APRUEBA(24,0,11)
   IF ERROR_PRINT()
      RETURN
   ENDIF
   SET DEVICE TO PRINT
   IMPRE = .T.
ENDIF

GO TOP
LINEAS = 70
PRIMERA = .T.
HOJA = 1
DO WHILE !EOF()
   IF LINEAS > 65 .AND. IMPRE
      DO ENCAPRI
   ELSE
      IF LINEAS > 20 .AND. !IMPRE
         DO ENCAPRI
         IF LASTKEY() = 27
            GO BOTTOM
            SKIP
            LOOP
         ENDIF
      ENDIF
   ENDIF
   @ LINEAS,5 SAY CODIGO + '' + DESCR + '     ' + STR(COSTO)
   LINEAS = LINEAS + 1
   SKIP
ENDDO
IF IMPRE
   EJECT
   SET DEVICE TO SCREEN
ELSE
   DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
   ESPERAR(0)
ENDIF
CLOSE ALL
RETURN


PROCEDURE ENCAPRI
****************

IF PRIMERA
   IF IMPRE
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
      @ 24,0 SAY SPACE(79)
   ENDIF
ENDIF
LINEAS = 1
@ LINEAS,15 SAY IIF(IMPRE,CHR(14),'         ') + ' * LISTADO DE COMPONENTES * '
@ LINEAS + 1,2 SAY 'Fecha: ' + DTOC(DATE())
@ LINEAS + 1,60 SAY 'Hoja Nro: ' + STR(HOJA,2,0)
@ LINEAS + 3,3 SAY 'Codigo             Descripcion                                   Costo'
@ LINEAS + 4,1 SAY REPLICATE('=',79)
LINEAS = 6
HOJA = HOJA + 1
RETURN

PROCEDURE ACTUARCH
******************

* Procedimiento de Actualizacion de los Archivos de Conjuntos y Subconjuntos


SELE 3
INDEX ON M_PRIMA TO PEPITO

sele 13

GO TOP
DO WHILE .NOT. EOF()
   M_COD=CODIGO
   SELE 3
   SEEK M_COD
   DO WHILE .NOT. EOF() .AND. M_PRIMA=M_COD
      M_COSTO=(AUXIACT->COSTO_A*CANTIDAD)
      M_COSTO1=(AUXIACT->COSTO_AN*CANTIDAD)
      M_COD1=CODIGO
      SELE 4
      SEEK M_COD1
      M_COSTOAN=COSTO
      REPLACE COSTO_CO WITH COSTO_CO - M_COSTO1 + M_COSTO
      REPLACE COSTO WITH ARMADO+COSTO_CO
      SELE 15
      APPEND BLANK
      REPLACE CODIGO WITH M_COD1
      REPLACE COSTO_A WITH SUBCONJ->COSTO
      REPLACE COSTO_AN WITH M_COSTOAN
      SELE 3
      SKIP
   ENDDO
 SELE 13
 SKIP
ENDDO

ERASE C:\SIAAC\PEPITO2.NTX
ERASE C:\SIAAC\PEPITO.NTX

RETURN


PROCEDURE CONS_COSTO
********************

SELE 1
USE SUBCONJ INDEX SUBCONJ

SELE 2
USE SUBCONJ2 INDEX SUBCONJ2

SELE 3
USE MPRIMA INDEX MPRIMA

M_CODIGO = SPACE(15)
DO WHILE .T.
    CLEAR
    @ 1,0 TO 23,79 DOUBLE
    DO TITULO
    SET COLOR TO I
    @ 3,30 SAY 'CONSULTA DE COSTOS DE ARTICULOS'
    SET COLOR TO
    @ 5,1 TO 5,78
    M_CODIGO = SPACE(15)
    DO WHILE .T.
         SELE 1
         @ 8,3 SAY 'Codigo de Articulo de Fabricacion : ' GET M_CODIGO PICT '@!'
         READ
         IF LASTKEY() = 27
              EXIT
         ENDIF
         SEEK M_CODIGO
         IF !FOUND()
              DO M_CARTEL WITH 101,24,0,.T.,.T.,.T.
              ESPERAR(0)
              LOOP
         ELSE
              SET COLOR TO I
              @ 9,3 SAY DESCR
              SET COLOR TO
              EXIT
         ENDIF
    ENDDO
    IF LASTKEY() = 27
          EXIT
    ENDIF
    IF APRUEBA(24,0,2)
          IMPRE = .F.
          IF APRUEBA(24,0,11)
               IMPRE = .T.
               DO M_CARTEL WITH 10,24,0,.T.,.F.,.T.
               ESPERAR(0)
               IF LASTKEY() = 27
                   RETURN
               ENDIF
               IF ERROR_PRINT()
                  RETURN
               ENDIF
               SET DEVI TO PRINT
               @ PROW(),PCOL() SAY CHR(18)
          ENDIF
          LINEAS = 70
          HOJA = 1
          PRIMERA = .T.
          M_TOTAL = 0
          SELE 2
          SEEK M_CODIGO
          DO WHILE !EOF() .AND. CODIGO = M_CODIGO
                    IF LINEAS > 65 .AND. IMPRE
                       DO ENC_COSTOS
                    ENDIF
                    IF LINEAS > 20 .AND. !IMPRE
                       DO ENC_COSTOS
                    ENDIF
                    SELE 3
                    SEEK SUBCONJ2->M_PRIMA
                    M_COSTO = COSTO
                    SELE 2
                    @ LINEAS,0 SAY M_PRIMA + ' ' + SUBSTR(MPRIMA->DESCR,1,20) + ' ' + STR(CANTIDAD,10,3) + ' ' + TRANSFORM(M_COSTO,'###,###.####') + ' ' + TRANSFORM(M_COSTO * CANTIDAD,'###,###.####')
                    LINEAS = LINEAS + 1
                    M_TOTAL = M_TOTAL + (M_COSTO * CANTIDAD)
                    SKIP
          ENDDO
          @ LINEAS + 1,1 SAY 'Costo de Armado              : ' + TRANSFORM(SUBCONJ->ARMADO,'###,###.####')
          @ LINEAS + 2,1 SAY 'Costo Total de este articulo : ' + TRANSFORM(M_TOTAL + SUBCONJ->ARMADO,'###,###.####')
          IF IMPRE
              EJECT
              SET DEVI TO SCREEN
          ELSE
              DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
              ESPERAR(0)
          ENDIF
    ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE ENC_COSTOS
********************
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
@ LINEAS,25 SAY 'COSTOS DE ARTICULOS DE FABRICACION'
@ LINEAS + 1,1 SAY 'Articulo: ' + SUBCONJ->DESCR
@ LINEAS + 2,50 SAY 'Hoja Nro: ' + STR(HOJA,3,0)
@ LINEAS + 2,1 SAY 'Fecha : ' + DTOC(M_FECHA)
@ LINEAS+3,0 SAY REPLICATE('=',80)
@ LINEAS + 4,0 SAY 'Cod.M.Prima      DESCRIPCION             CANTIDAD     P.COSTO     TOTAL'
@ LINEAS+5,0 SAY REPLICATE('=',80)
HOJA = HOJA + 1
LINEAS = 7
RETURN


PROCEDURE PART_DI
*****************
SELE 1
USE MPRIMA INDEX MPRIMA

SELE 2
USE SUBCONJ INDEX SUBCONJ

SELE 3
USE SUBCONJ2 INDEX SUBCONJ2

SELE 4
USE ARTIC INDEX ARTIC

DO WHILE .T.
     CLEAR
     DO TITULO
     @ 1,0 TO 23,79 DOUBLE
     SET COLOR TO I
     @ 3,30 SAY 'PARTE DIARIO DE PRODUCCION'
     SET COLOR TO
     @ 5,1 TO 5,78
     M_PT = SPACE(15)
     DO WHILE .T.
          DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
          SELE 2
          @ 8,3 SAY 'Codigo de Producto Terminado : ' GET M_PT PICT '@!'
          READ
          IF LASTKEY() = 27
               EXIT
          ENDIF
          SEEK M_PT
          IF !FOUND()
               DO M_CARTEL WITH 101,24,0,.T.,.T.,.T.
               ESPERAR(0)
               LOOP
          ELSE
               SET COLOR TO W+
               @ 9,3 SAY DESCR
               SET COLOR TO
               EXIT
          ENDIF
     ENDDO
     IF LASTKEY() = 27
          EXIT
     ENDIF
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     M_CANT = 0
     @ 11,3 SAY 'Cantidad Producida : ' GET M_CANT PICT '######.####'
     READ
     IF LASTKEY() = 27
          LOOP
     ENDIF
     IF APRUEBA(24,0,2)
            SELE 4
            SEEK SUBSTR(M_PT,1,10)
            REPLACE STOCK WITH STOCK + M_CANT
            SELE 3
            SEEK M_PT
            DO WHILE !EOF() .AND. CODIGO = M_PT
                   SELE 1
                   SEEK SUBSTR(SUBCONJ2->M_PRIMA,1,10)
                   REPLACE STOCK WITH STOCK - (SUBCONJ2->CANTIDAD * M_CANT)
                   SELE 3
                   SKIP
            ENDDO
     ENDIF
ENDDO
CLOSE ALL
RETURN


FUNCTION VALPEDI
****************
IF M_PEDIDO = 0
   RETURN(.T.)
ENDIF
SELE 9
SEEK M_PEDIDO
IF !FOUND()
   DO M_CARTEL WITH 98,24,0,.T.,.T.,.T.
   ESPERAR(0)
   DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
   RETURN(.F.)
ELSE
   RETURN(.T.)
ENDIF
