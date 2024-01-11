*******************************************************************************
*CAJA3.PRG. MOVIMIENTOS DE CAJA INGRESOS Y EGRESOS
*******************************************************************************
*MENU PRINCIPAL

*IF !SEGURIDAD(MM_CLAVE,'P')
*     DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*     ESPERAR(0)
*     RETURN
*ENDIF

DO WHILE .T.
    CLEAR
    DO TITULO
    DECLARE MENPEE[9]
    DECLARE OPPEE[9]
    OPPEE[1]='ABM DE DATOS A CAJA'
    OPPEE[2]='VISUALIZAR CAJA'
    OPPEE[3]='VISUALIZAR CAJA INGRESOS POR RUBRO'
    OPPEE[4]='VISUALIZAR CAJA EGRESOS POR RUBRO'
    OPPEE[5]='ADELANTOS A VENDEDORES'
    OPPEE[6]='CONSULTA DE DOCUMENTOS'
    OPPEE[7]='VISUALIZAR OPERACIONES DE CAJA'
    OPPEE[8]='CONSULTA DE CHEQUES POR NUMERO INTERNO'
    OPPEE[9]='LIBRO BANCOS'

    MENPEE[1]='          º  Entradas y Salidas de Valores Caja'
    MENPEE[2]='          º  Listado de Caja'
    MENPEE[3]='          º  Listado de Caja INGRESOS'
    MENPEE[4]='          º  Listado de Caja EGRESOS'
    MENPEE[5]='          º  Visualizar Operaciones de Caja'
    MENPEE[6]='          º  Listado de Documentos'
    MENPEE[7]='          º  Visualizar operaciones de caja'
    MENPEE[8]='          º  Visualizar operaciones de caja'
    MENPEE[9]='          º  Libro Bancos'

*    Displaya opciones y captura.
     OPPE=OPCIONES('SISTEMA DE VENTAS - MOVIMIENTOS DE CAJA',OPPEE,MENPEE)
*    Fin
     IF LASTKEY()=27
      EXIT
     ENDIF
        DO CASE
           CASE OPPE=1
             DO ABMCAJA WITH .F.,.T.
           CASE OPPE=2
             DO LIST_CAJA
           CASE OPPE = 3
             DO LIST_CAJA2 WITH 'I'
           CASE OPPE = 4
             DO LIST_CAJA2 WITH 'E'
           CASE OPPE = 5
              DO VALES
           CASE OPPE = 6
             DO LIST_DOC WITH .F.
           CASE OPPE = 7
             DO OPE_CAJA
           CASE OPPE = 8
             DO NROINTER
           CASE OPPE = 9
             DO MENBANCO
        ENDCASE
ENDDO
RETURN


PROCEDURE PANT_CAJA
********* *********
*Pnatalla de Caja
@ 1,0 TO 23,79 DOUBLE

@ 2,1 SAY 'Registro en Caja :               Nro:             Rubro :'
@ 3,1 SAY 'Detalle Operacion:'
@ 4,1 SAY 'Importe Doc.     :                 Importe en Pesos       :'
@ 5,1 SAY 'Importe Dolares  :            Cobinpro:                 Vs:'
@ 6,1 SAY 'Cod. Cliente     :                                           Fecha:'
@ 7,1 SAY '============================================================================'
@ 8,1 SAY 'INT.  NRO.DOC         FECHA        BANCO        SUCURSAL  ORDEN      IMPORTE'
@ 9,1 SAY '============================================================================'
RETURN


PROCEDURE ABMCAJA
*****************
*ABM de datos de Caja.
PARAMETERS M_FACTURA,M_DEFINE

SELE 1
USE CAJAIG INDEX CAJAIG,CAJAIG2,CAJAIG3
SET ORDER TO 3

SELE 13
USE CONTADO1 INDEX CONTADO1

SELE 11
USE CLIENTES INDEX CLIENTES

SELE 9
USE VENDEDOR INDEX VENDEDOR

SELE 4
USE COMPRO1 INDEX COMPRO1,COMPRO2
SET ORDER TO 1

SELE 5
USE RUBROS INDEX RUBROS

SELE 6
USE DOCUM INDEX DOCUM,DOCUM2
SET ORDER TO 1

SELE 10
USE DOLAR INDEX DOLAR
SEEK M_FECHA

SELE 14
USE COMPRAS INDEX COMPRAS

SELE 25
USE IVA

SELE 22
USE BANCOS INDEX BANCOS

SELE 23
USE RESUMEN INDEX RESUMEN,RESUMEN2
SET ORDER TO 1

DECLARE V_MOVI[2]
V_MOVI[1] = 'INGRESOS'
V_MOVI[2] = 'EGRESOS'

DECLARE M_INT[50]
DECLARE M_NRO[50]
DECLARE M_FDOC[13]
DECLARE M_BANCO[50]
DECLARE M_CLEARING[13]
DECLARE M_ORDEN[13]
DECLARE M_IMPORTE[50]

FOR I = 1 TO 50
    M_IMPORTE[I] = 0
NEXT

DECLARE FACTURA[10]
DECLARE VALOR[8]
DECLARE COMP_REC[10]
DECLARE IMPORTE[10]
DECLARE V_CLIENTE[10]
DECLARE V_ARTI[21]
DECLARE V_COMPRO[1]
V_COMPRO[1] = 'RECIBO AUTORIZADO'
FOR I = 1 TO 21
   V_ARTI[I] = ''
NEXT

DECLARE V_INT[20]
DECLARE V_IMP[20]
DECLARE ACTIVO[50]
DECLARE ELEGIDO[50]
DECLARE V_1[50]
DECLARE V_2[50]

ELIGIO = .F.
PRIVATE M_RUBRO,M_DETALLE,M_FOPE,M_CANCELA,M_VALES,M_TOPE,M_IMPROV,M_STOTAL,M_IMP,M_IMPCREDI,M_DISTRI
PRIVATE M_COMPRO,NUMCOMP,TOT_REC,M_IVA,ADIC,M_FECH,M_VENDEDOR,M_CONC1,M_CONC2,R5,M_INTERNOS,M_OPERA,M_NROREC,M_CREDITO,M_PROPIO
IF !M_FACTURA
     PRIVATE M_CLIENTE,M_PROV
     STOR SPACE(10) TO M_CLIENTE,M_PROV
ELSE
     M_PROV = SPACE(10)
ENDIF

IF M_DEFINE
     PRIVATE M_IMPDOC,M_IMPESOS,M_IMPDOL,M_COBI,M_VARIOS,M_NRORECI
     M_NRORECI = 0
ENDIF

DO WHILE .T.
    R5 = .F.
    M_INTERNOS = 0
    CLEAR
    DO TITULO
    DO PANT_CAJA
    IF !ELIGIO
        SL = 1
        ELIGIO = .T.
    ELSE
        SL = L
    ENDIF
    SAVE SCREEN TO M_PANTA
    L = ventopcion('REGISTRO EN CAJA',v_MOVI,5,5,23,.t.,.t.,SL)
    IF LASTKEY() = 27
         RESTORE SCREEN FROM M_PANTA
         EXIT
    ENDIF
    RESTORE SCREEN FROM M_PANTA
    SET COLOR TO I
    @ 2,19 SAY V_MOVI[L]
    SET COLOR TO
    SELE 13
    SEEK 'ING'
    SELE 1
    SET ORDER TO 3
    M_NUMERO = CONTADO1->NUMERO
    @ 2,39 GET M_NUMERO PICT '#####' VALID M_NUMERO <= CONTADO1->NUMERO
    READ
    IF LASTKEY() = 27
       LOOP
    ENDIF
    SEEK M_NUMERO
    IF !FOUND()
        IF APRUEBA(24,0,78)
             @ 24,0 SAY SPACE(79)
             DO ING_DATOS WITH .T.
        ELSE
             LOOP
        ENDIF
    ELSE
        IF TIPO = 'I'
            IF L = 2
               DO M_CARTEL WITH 88,24,0,.T.,.T.,.T.
               ESPERAR(0)
               LOOP
            ENDIF
        ELSE
             IF L = 1
                DO M_CARTEL WITH 88,24,0,.T.,.T.,.T.
                ESPERAR(0)
                LOOP
             ENDIF
        ENDIF
        DO M_CARTEL WITH 87,24,0,.T.,.T.,.T.
        M_DESEO = 'B'
        @ 24,75 GET M_DESEO PICT 'A' VALID M_DESEO = 'B'
        READ
        @ 24,0 SAY SPACE(79)
        IF LASTKEY() = 27
              LOOP
        ENDIF
        IF M_DESEO = 'M'
*            DO ING_DATOS WITH .F.
        ELSE
             IF APRUEBA(24,0,37)
                   DO BAJA_DATO
             ENDIF
        ENDIF
    ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE ING_DATOS
*******************
*Ingresa datos a caja
PARAMETERS M_ALTA

DECLARE V_DOCU[4]
V_DOCU[1] = 'POR NUMERO INTERNO'
V_DOCU[2] = 'POR RANGO DE NUMEROS INTERNOS'
V_DOCU[3] = 'POR FECHA DEL DOCUMENTO'
V_DOCU[4] = 'NO SE PAGA CON DOCUMENTOS'

IF M_ALTA
    DO BLAN_VCAJA WITH .T.
ELSE
    DO BLAN_VCAJA WITH .F.
ENDIF
DO WHILE .T.
        DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
        M_OPERA = 0
        M_IMPMAX = 0
        M_RUBRO = SELE_RUB(5,30,22,M_RUBRO)
        IF M_RUBRO = 0
           EXIT
        ENDIF
        SET COLOR TO I
        @ 2,60 SAY SUBSTR(RUBROS->DESCR,1,19)
        SET COLOR TO
        IF L = 1
            IF INGRES = 'E'
                DO M_CARTEL WITH 108,24,0,.T.,.T.,.T.
                ESPERAR(0)
                LOOP
            ENDIF
        ELSE
            IF INGRES = 'I'
                DO M_CARTEL WITH 108,24,0,.T.,.T.,.T.
                ESPERAR(0)
                LOOP
            ENDIF
        ENDIF
        IF L = 2
              @ 3,19 GET M_DETALLE PICT '@!'
              READ
              IF LASTKEY() = 27
                   LOOP
              ENDIF
              SAVE SCREEN TO M_PANTA2
              S = ventopcion('SALIDA DE DOCUMENTOS',v_DOCU,8,5,23,.t.,.t.,1)
              IF LASTKEY() = 27
                  RESTORE SCREEN FROM M_PANTA2
                  LOOP
              ENDIF
              IF S = 1
                 RESTORE SCREEN FROM M_PANTA2
                 M_IMPDOC = BUSCA_DOC2()
                 @ 4,19 SAY M_IMPDOC  PICT '###,###.##'
                 M_HACE = .F.
                 M_INTERNOS = 13
              ELSE
                 IF S = 2 .OR. S = 3
                    M_IMPDOC = BUSCA_DOCU(S)
                    @ 4,19 SAY M_IMPDOC  PICT '########.##'
                    M_HACE = .F.
                 ELSE
                    RESTORE SCREEN FROM M_PANTA2
                    M_IMPDOC = 0
                    @ 4,19 SAY M_IMPDOC PICT  '########.##'
                    M_HACE = .F.
                    M_INTERNOS = 0
                 ENDIF
              ENDIF
              @ 4,60 GET M_IMPESOS PICT '########.##' VALID M_IMPESOS >= 0
              @ 5,19 GET M_IMPDOL  PICT '########.##' VALID M_IMPDOL  >= 0
              @ 6,70 GET M_FOPE PICT '99/99/99' VALID VALFECH(M_FOPE)
              READ
              IF LASTKEY() = 27
                  LOOP
              ENDIF
        ELSE
              @ 3,19 GET M_DETALLE PICT '@!'
              READ
              IF LASTKEY() = 27
                   LOOP
              ENDIF
              DO WHILE .T.
                   @ 4,19 GET M_IMPDOC  PICT '########.##' VALID M_IMPDOC  >= 0
                   @ 4,60 GET M_IMPESOS PICT '########.##' VALID M_IMPESOS >= 0
                   @ 5,19 GET M_IMPDOL  PICT '########.##' VALID M_IMPDOL  >= 0
                   @ 5,40 GET M_COBI    PICT '########.##' VALID M_COBI >= 0
                   @ 5,60 GET M_VARIOS  PICT '########.##' VALID M_VARIOS >= 0
                   READ
                   EXIT
              ENDDO
              IF LASTKEY() = 27
                   LOOP
              ENDIF
              IF L = 1
                   M_CLIENTE = SPACE(10)
                   @ 6,19 GET M_CLIENTE PICT '@!' VALID VALCLI(6,31,M_CLIENTE)
              ELSE
                   M_PROV = SPACE(10)
                   @ 6,1 SAY 'Proveedor: '
                   @ 6,19 GET M_PROV PICT '@!' VALID VALPROV(6,31,M_PROV)
              ENDIF
              @ 6,70 GET M_FOPE PICT '99/99/99' VALID VALFECH(M_FOPE)
              READ
              IF LASTKEY() = 27
                  LOOP
              ENDIF
              M_INTERNOS = 13
              M_HACE = .T.
        ENDIF
        IF M_ALTA
           M_TOPE = 13
        ENDIF
        I = 1
        @ 24,0 SAY SPACE(79)
        DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
        M_IMPTOPE = 0
        M_ABANDONA = .F.
        SAVE SCREEN TO M_P17
        DO WHILE .T. .AND. I <= M_TOPE .AND. M_IMPDOC <> 0 .AND. M_HACE
           DO CARGA_ITEM WITH I
           IF LASTKEY() = 27
              @ 24,0 SAY SPACE(79)
*             IF M_IMPDOC > M_IMPTOPE
*                   IF APRUEBA(24,0,82)
*                        M_ABANDONA = .T.
*                        EXIT
*                   ENDIF
*                   @ 24,0 SAY SPACE(79)
*                   LOOP
*             ENDIF
              IF APRUEBA(24,0,81)
                 EXIT
              ENDIF
              @ 24,0 SAY SPACE(79)
              LOOP
           ENDIF
           M_IMPTOPE = M_IMPTOPE + M_IMPORTE[I]
           I = I + 1
        ENDDO
        @ 24,0 SAY SPACE(79)
        IF M_ABANDONA
            RESTORE SCREEN FROM M_P17
            LOOP
        ENDIF
        SAVE SCREEN TO M_P7
        @ 18,10 CLEAR TO 20,60
        @ 18,10 TO 20,60 DOUBLE
        @ 19,11 SAY 'Total : ' + TRANSFORM(M_IMPDOC + M_IMPESOS + M_IMPDOL + M_VARIOS + M_COBI,'###,###.##')
        @ 20,11 SAY 'Numero Recibo : ' GET M_NRORECI PICT '#####'
        READ
        ESPERAR(0)
        RESTORE SCREEN FROM M_P7
        GRAB_BAN = .F.
        IF L = 2
             @ 19,0 CLEAR TO 23,79
             @ 19,0 TO 23,79
             M_DESEO = 'O'
             @ 20,1 SAY '(D)eposito, (O)tras Operaciones : ' GET M_DESEO PICT '@A' VALID M_DESEO = 'D' .OR. M_DESEO ='O'
             READ
             IF M_DESEO = 'D'
                   @ 24,0 SAY SPACE(79)
                   M_NROCHEQ = SPACE(15)
                   M_BAN = 1
                   @ 21,1 SAY 'Banco de la Operacion : ' GET M_BAN PICT '###' VALID VALBANCO(M_BAN,21,30,'22')
                   READ
                   GRAB_BAN = .T.
             ENDIF
        ENDIF
        IF LASTKEY() = 27
           LOOP
        ENDIF

        IF APRUEBA(24,0,2)
             M_IMPRE = 'N'
             IF M_ALTA
                DO GRAB_CAJA WITH M_ALTA
                IF APRUEBA(24,0,49)
*                   DO IMP_COMPRO WITH L
                    M_IMPRE = 'S'
                ENDIF
             ENDIF
        ENDIF
        EXIT
ENDDO
RETURN


PROCEDURE BLAN_VCAJA
********************
PARAMETERS M_ALTA

IF M_ALTA
   M_RUBRO = 1
   M_IMPESOS = 0
   M_IMPDOC = 0
   M_DETALLE = SPACE(55)
   M_IMPDOL = 0
   M_FOPE = M_FECHA
   M_CANCELA = IIF(L = 1,'N','S')
   M_VALES = 'N'
   STOR 0 TO M_VARIOS,M_COBI
   IF !M_FACTURA
       M_CLIENTE = SPACE(10)
   ENDIF
   SELE 13
   IF L = 1
      SEEK 'DOC'
      M_NDOC = NUMERO
   ELSE
      M_NDOC = 0
   ENDIF
   FOR I = 1 TO 13
       M_INT[I] = M_NDOC
       M_NRO[I] = SPACE(15)
       M_FDOC[I] = M_FECHA
       M_BANCO[I] = SPACE(15)
       M_CLEARING[I] = SPACE(15)
       M_ORDEN[I] = SPACE(8)
       M_IMPORTE[I] = 0
       IF M_NDOC <> 0
          M_NDOC = M_NDOC + 1
       ENDIF
   NEXT
ELSE
   SELE 1
   M_RUBRO = RUBRO
   M_DETALLE = DETALLE
   M_IMPESOS = IMPESOS
   M_IMPDOC  = IMPDOC
   M_IMPDOL  = IMPDOL
   M_CANCELA = CANCELA
   M_VALES   = VALES
   M_FOPE = FECHA
   FOR I = 1 TO 13
        M_NRO[I] = SPACE(15)
   NEXT
   SELE 6
   SEEK STR(M_NUMERO,5,0)
   I = 1
   M_TOPE = 0
   DO WHILE NRO = M_NUMERO .AND. !EOF()
         M_INT[I] = NROINT
         M_NRO[I] = NRODOC
         M_FDOC[I] = FECHA
         M_BANCO[I] = BANCO
         M_CLEARING[I] = CLEARING
         M_ORDEN[I] = ORDEN
         M_IMPORTE[I] = IMPORTE
         SKIP
         I = I + 1
         M_TOPE = M_TOPE + 1
   ENDDO
   IF M_TOPE = 0
      M_INT[1] = 0
   ENDIF
ENDIF
RETURN


PROCEDURE CARGA_ITEM
********************
*Carga items de documentos

PARAMETERS M_ITEM
IF L = 1
   @ I + 9,1 SAY M_INT[M_ITEM] PICT '#####'
   @ I + 9,7 GET M_NRO[M_ITEM] PICT '@!'
   @ I + 9,23 GET M_FDOC[M_ITEM] PICT '99/99/99' VALID VALFECH(M_FDOC[M_ITEM])
   @ I + 9,32 GET M_BANCO[M_ITEM] PICT '@!S8'
   @ I + 9,49 GET M_CLEARING[M_ITEM] PICT '@!S8'
   @ I + 9,59 GET M_ORDEN[M_ITEM] PICT '@!'
   @ I + 9,69 GET M_IMPORTE[M_ITEM] PICT '#######.##' VALID INT(M_IMPORTE[M_ITEM]) <= INT(M_IMPDOC - M_IMPTOPE) .AND. M_IMPORTE[M_ITEM] > 0
   READ
ELSE
   DO WHILE .T.
       SELE 6
       @ I + 9,1 GET M_INT[M_ITEM] PICT '#####'
       READ
       IF LASTKEY() = 27
           EXIT
       ENDIF
       SET ORDER TO 2
       SEEK M_INT[M_ITEM]
       IF !FOUND()
            DO M_CARTEL WITH 79,24,0,.T.,.T.,.T.
            ESPERAR(0)
            @ 24,0 SAY SPACE(79)
       ELSE
            IF !EMPTY(ALLTRIM(DESTINO))
                 DO M_CARTEL WITH 80,24,0,.T.,.T.,.T.
                 ESPERAR(0)
                 @ 24,0 SAY SPACE(79)
                 LOOP
            ENDIF
            M_NRO[M_ITEM] = NRODOC
            M_FDOC[M_ITEM] = FECHA
            M_BANCO[M_ITEM] = BANCO
            M_CLEARING[M_ITEM] = CLEARING
            M_ORDEN[M_ITEM] = ORDEN
            M_IMPORTE[M_ITEM] = IMPORTE
            EXIT
       ENDIF
   ENDDO
   SET ORDER TO 1
   IF LASTKEY() = 27
       RETURN
   ENDIF
   @ I + 9,7 SAY M_NRO[M_ITEM] PICT '@!'
   @ I + 9,23 SAY M_FDOC[M_ITEM] PICT '99/99/99'
   @ I + 9,32 SAY M_BANCO[M_ITEM] PICT '@!S8'
   @ I + 9,49 SAY M_CLEARING[M_ITEM] PICT '@!S8'
   @ I + 9,59 SAY M_ORDEN[M_ITEM] PICT '@!'
   @ I + 9,69 GET M_IMPORTE[M_ITEM] PICT '#######.##' VALID M_IMPORTE[M_ITEM] <= M_IMPTOPE- M_IMPDOC .AND. M_IMPORTE[M_ITEM] > 0
   READ
ENDIF
RETURN

function sele_rub
*****************
*Selecciona Rubros
parameters f,c,t,R

sele 5
GO TOP
if eof()
   do m_cartel with 68,24,0,.t.,.t.,.t.
   esperar(0)
   return(0)
ELSE
   DECLARE V_COD[RECCOUNT()]
   DECLARE V_RUBROS[RECCOUNT()]
   I = 1
   DO WHILE !EOF()
       V_RUBROS[I] = DESCR
       V_COD[I] = COD_RUB
       I = I + 1
       SKIP
   ENDDO
ENDIF
save screen to m_panta
Q = ventopcion('RUBROS',v_RUBROS,f,c,t,.t.,.t.,R)
restore screen from m_panta
if lastkey()=27
   return(0)
endif
SEEK V_COD[Q]
return(v_cod[Q])

PROCEDURE GRAB_CAJA
********************
*Graba Datos de Caja

PARAMETERS M_ALTA
SELE 1
IF M_ALTA
   APPE BLANK
ENDIF

REPLACE NRO WITH M_NUMERO
REPLACE RUBRO WITH M_RUBRO
REPLACE DETALLE WITH M_DETALLE
REPLACE IMPESOS WITH M_IMPESOS + M_COBI + M_VARIOS
REPLACE IMPDOC WITH M_IMPDOC
REPLACE IMPDOL WITH M_IMPDOL
REPLACE COBI WITH M_COBI
REPLACE VARIOS WITH M_VARIOS
REPLACE CANCELA WITH M_CANCELA
REPLACE FECHA WITH M_FOPE
REPLACE VALES WITH M_VALES
REPLACE TIPO WITH IIF(L=1,'I','E')
REPLACE CLIENTE WITH M_CLIENTE
REPLACE PROVEDOR WITH M_PROV
REPLACE NROREC WITH STR(M_NRORECI,10,0)

IF L = 1
    FOR I = 1 TO 13
       IF M_IMPORTE[I] <> 0
             SELE 6
             IF M_ALTA
                 APPE BLANK
             ELSE
                 SEEK STR(M_NUMERO,5,0) + STR(M_INT[I],5,0)
             ENDIF
             REPLACE NRO WITH M_NUMERO
             REPLACE NROINT WITH M_INT[I]
             REPLACE NRODOC WITH M_NRO[I]
             REPLACE FECHA WITH M_FDOC[I]
             REPLACE BANCO WITH M_BANCO[I]
             REPLACE CLEARING WITH M_CLEARING[I]
             REPLACE ORDEN WITH M_ORDEN[I]
             REPLACE IMPORTE WITH M_IMPORTE[I]
             REPLACE CLIENTE WITH M_CLIENTE
             IF M_ALTA
                SELE 13
                SEEK 'DOC'
                REPLACE NUMERO WITH NUMERO + 1
             ENDIF
       ENDIF
    NEXT
ELSE
    FOR I = 1 TO M_INTERNOS
          IF M_IMPORTE[I] <> 0
                 SELE 6
                 SET ORDER TO 2
                 SEEK M_INT[I]
                 SET ORDER TO 1
                 IF M_ALTA
                      REPLACE DESTINO WITH IIF(!EMPTY(ALLTRIM(M_DETALLE)),M_DETALLE,'NO SE DETALLO')
                 ENDIF
                 SET ORDER TO 1
          ENDIF
    NEXT
ENDIF

*contadores
SELE 13
SEEK 'ING'
REPLACE NUMERO WITH NUMERO + 1

IF GRAB_BAN
     SELE 23
     GO BOTTOM
     M_NROOP = NUMERO + 1
     APPE BLANK
     REPLACE NUMERO WITH M_NROOP
     REPLACE BANCO WITH M_BAN
     REPLACE DETALLE WITH IIF(M_DESEO = 'D','DEPOSITO','PAGO C/CHEQ.PROPIO '+ M_NROCHEQ)
     REPLACE DOC WITH IIF(M_DESEO = 'D','C','D')
     REPLACE FECHA WITH M_FOPE
     REPLACE IMPORTE WITH M_IMPESOS + M_IMPDOL + M_IMPDOC
ENDIF
RETURN

PROCEDURE LIST_DOC
********* ********
*Listado de Documentos
PARAMETERS SOLO_CAJ
@ 24,0 SAY SPACE(79)

SELE 11
USE CLIENTES INDEX CLIENTES

IF !SOLO_CAJ
   M_DESDE = M_FECHA - 30
   M_HASTA = M_FECHA
   M_CLIENTE = SPACE(10)
   M_CUALES = 'C'
   @ 22,2 SAY '(T)odos o Los Que estan en (C)aja Solamente : ' GET M_CUALES PICT 'A' VALID M_CUALES = 'C' .OR. M_CUALES = 'T'
   @ 23,2 SAY 'Cliente (9999999999=TODOS): ' GET M_CLIENTE PICT '@!' VALID VALCLI(23,50,M_CLIENTE)
   @ 24,2 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
   @ 24,55 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
   READ
ELSE
   M_DESDE = M_FECHA - 365
ENDIF

IF LASTKEY() = 27
   RETURN
ENDIF
@ 24,0 SAY SPACE(80)

SELE 26
USE DOCUM INDEX DOCUM
SET FILTER TO FECHA >= M_DESDE

GO TOP
LINEAS = 70
HOJA = 1
PRIMERA = .T.
IMPRE = .F.
IF APRUEBA(24,0,11)
     IMPRE = .T.
     IF ERROR_PRINT()
          CLOSE ALL
          RETURN
     ENDIF
     SET DEVICE TO PRINT
ENDIF

DO WHILE !EOF()
     IF LINEAS > 65 .AND. IMPRE
          DO ENC_LDOC
     ENDIF
     IF LINEAS > 20 .AND. !IMPRE
          DO ENC_LDOC
     ENDIF
     IF VAL(M_CLIENTE) <> 9999999999
         IF M_CLIENTE <> CLIENTE
             SKIP
             LOOP
         ENDIF
     ENDIF
     SELE 11
     SEEK DOCUM->CLIENTE
     SELE 26
     IF M_CUALES = 'C'
         IF !EMPTY(ALLTRIM(DESTINO))
             SKIP
             LOOP
         ENDIF
     ENDIF
     IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA
         @ LINEAS,1 SAY STR(NROINT,5,0) + ' ' + NRODOC + ' ' + SUBSTR(BANCO,1,10) + ' ' + DTOC(FECHA) + ' ' + SUBSTR(CLIENTES->NOMBRE,1,10) + ' ' + SUBSTR(DESTINO,1,15) + ' ' + TRANSFORM(IMPORTE,'###,###.##')
         LINEAS = LINEAS + 1
     ENDIF
     SKIP
ENDDO

IF IMPRE
    @ PROW(),PCOL() SAY CHR(18)
    EJECT
    SET DEVICE TO SCREEN
ELSE
    DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
    ESPERAR(0)
    @ 24,0 SAY SPACE(79)
ENDIF
SET FILTER TO
CLOSE ALL
RETURN

PROCEDURE ENC_LDOC
******************
*Encabezamiento Listado de Documentos

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
    ENDIF
ENDIF

LINEAS = 1
@ LINEAS,10 SAY IIF(IMPRE,CHR(14) + '                 *LISTADO DE DOCUMENTO*','                ' + 'LISTADO DE DOCUMENTOS')
@ LINEAS +3,1 SAY 'Desde Fecha: ' + DTOC(M_DESDE)
@ LINEAS + 4,1 SAY 'INT.  NRO. DOC          BANCO      FECHA     CLIENTE      DESTINO      IMPORTE'
IF !IMPRE
   @ LINEAS + 5,1 SAY REPLICATE('=',79)
ELSE
   @ LINEAS + 5,1 SAY REPLICATE('=',135)
ENDIF
LINEAS = 7
HOJA = HOJA + 1
RETURN

FUNCTION BUSCA_DOCU
******** **********
*busca Documentos de acuerdo a la condicion elegida
PARAMETERS M_CONDI
IF M_CONDI = 2
    @ 9,35 CLEAR TO 9,78
    STOR 1 TO M_DESDE,M_HASTA
    @ 9,35 SAY '====> Desde Nro: ' GET M_DESDE PICT '#####'
    @ 9,60 SAY 'Hasta Nro: ' GET M_HASTA PICT '#####'
    READ
    RESTORE SCREEN FROM M_PANTA2
    SAVE SCREEN TO M_PANTA2
    IF LASTKEY() = 27
        RESTORE SCREEN FROM M_PANTA2
        RETURN(0)
    ENDIF
    M_CONDICION = '!EOF()'
    M_CONDI2 = 'NROINT >= M_DESDE .AND. NROINT <= M_HASTA'
ELSE
    @ 10,30 CLEAR TO 10,78
    STOR M_FECHA TO M_DESDE,M_HASTA
    @ 10,30 SAY '====> Desde Fecha: ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
    @ 10,59 SAY 'Hasta Fecha:' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
    READ
    RESTORE SCREEN FROM M_PANTA2
    SAVE SCREEN TO M_PANTA2
    IF LASTKEY() = 27
        RESTORE SCREEN FROM M_PANTA2
        RETURN(0)
    ENDIF
    M_CONDICION = '!EOF()'
    M_CONDI2 = 'FECHA >= M_DESDE .AND. FECHA <= M_HASTA'
ENDIF
SELE 6
SET ORDER TO 2
GO TOP
M_INTERNOS = 0
T = 0
M_IMPTOT = 0
DO WHILE &M_CONDICION
   IF EMPTY(ALLTRIM(DESTINO))
     IF &M_CONDI2
        T = T + 1
        V_1[T] = STR(NROINT,5,0) + '-' + STR(BANCO,3,0) + ' ' + NRODOC + ' ' + TRANSFORM(IMPORTE,'###,###.##')
        V_2[T] = STR(NROINT,5,0) + '-' + STR(BANCO,3,0) + ' ' + NRODOC + ' ' + TRANSFORM(IMPORTE,'###,###.##') + ' û'
        M_INT[T] = NROINT
        M_IMPORTE[T] = IMPORTE
        ACTIVO[T] = .T.
        ELEGIDO[T] = V_2[T]
        M_BANCO[T] = BANCO
        M_NRO[T] = NRODOC
        M_IMPTOT = M_IMPTOT + IMPORTE
        M_INTERNOS = M_INTERNOS + 1
     ENDIF
   ENDIF
   SKIP
ENDDO
IF T = 0
    DO M_CARTEL WITH 83,24,0,.T.,.T.,.T.
    ESPERAR(0)
    RESTORE SCREEN FROM M_PANTA2
    RETURN(0)
ELSE
    DECLARE ELEGIDO2[T]
    FOR D = 1 TO T
        ELEGIDO2[D] = ELEGIDO[D]
    NEXT
ENDIF

PRIMERA = .T.
DO WHILE .T.
*   DO PONE_TOT WITH .F.
    IF PRIMERA
         K = 1
         PRIMERA = .F.
    ENDIF
    K = VENTOPCION('INT.   BANCO     NRO.CHEQUE         IMPORTE',ELEGIDO2,15,0,20,.T.,.T.,K)
    IF LASTKEY() = 27
         EXIT
    ENDIF
    IF LASTKEY() = 13
           IF ACTIVO[K]
                 ACTIVO[K] = .F.
                 ELEGIDO2[K] = V_1[K]
                 M_INTERNOS = M_INTERNOS - 1
                 M_IMPTOT = M_IMPTOT - M_IMPORTE[K]
           ELSE
                 ACTIVO[K] = .T.
                 ELEGIDO2[K] = V_2[K]
                 M_INTERNOS = M_INTERNOS + 1
                 M_IMPTOT = M_IMPTOT + M_IMPORTE[K]
           ENDIF
    ENDIF
ENDDO
FOR E = 1 TO T
    IF !ACTIVO[E]
        M_IMPORTE[E] = 0
    ENDIF
NEXT
RESTORE SCREEN FROM M_PANTA2
RETURN(M_IMPTOT)


FUNCTION SELE_PAGOS
*******************
*Selecciona Pagos para cancelar y cargar en caja.

M_DETALLE = SPACE(55)
M_IMPDOC = 0
M_IMPMAX = 999999999
RETURN(0)

FUNCTION BUSCA_DOC2
*******************
M_IMPTOPE = 999999999
M_IMPDOC = 0
I = 1
DO WHILE .T.
   DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
   DO CARGA_ITEM WITH I
   IF LASTKEY() = 27
      @ 24,0 SAY SPACE(79)
      IF APRUEBA(24,0,81)
         EXIT
      ENDIF
      @ 24,0 SAY SPACE(79)
      LOOP
   ENDIF
   M_IMPDOC = M_IMPDOC + M_IMPORTE[I]
   M_IMPTOPE = M_IMPTOPE + M_IMPORTE[I]
   I = I + 1
ENDDO
RETURN(M_IMPDOC)


PROCEDURE LIST_CAJA2
********************
*Listado de Caja.  POR RUBROS

PARAMETERS M_CAJA

CLEAR
@ 1,0 TO 23,79 DOUBLE
SET COLOR TO I
@ 3,25 SAY 'LISTADO DE CAJA POR RUBROS'
SET COLOR TO
@ 5,1 TO 5,78
M_DESDE = M_FECHA - 30
M_HASTA = M_FECHA
@ 8,3 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
@ 10,3 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
READ
IF LASTKEY() = 27
    RETURN
ENDIF

SELE 27
USE RUBROS INDEX RUBROS

SELE 26
USE CAJAIG INDEX CAJAIG

IMPRE = .F.
IF APRUEBA(24,0,11)
     SET DEVI TO PRINT
     @ PROW(),PCOL() SAY CHR(18)
     IMPRE = .T.
ENDIF

LINEAS = 70
HOJA = 1
PRIMERA = .T.
GO TOP
STOR 0 TO RUBRO_ANT,TOT_RUBRO,TOT_GEN
HACE = .F.
DO WHILE !EOF()
     DO INI_CAJA
     DO WHILE !EOF() .AND. RUBRO_ANT = RUBRO
        IF M_CAJA = TIPO .AND. HACE
          IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA
             IF LINEAS > 66 .AND. IMPRE
                    DO ENC2
             ENDIF
             IF LINEAS > 20 .AND. !IMPRE
                    DO ENC2
             ENDIF
             M_TOTAL = IMPDOC + IMPESOS + IMPDOL
             TOT_RUBRO = TOT_RUBRO + M_TOTAL
             TOT_GEN = TOT_GEN + M_TOTAL
             @ LINEAS,1 SAY DTOC(FECHA) + ' ' + DETALLE + ' ' + TRANSFORM(M_TOTAL,'###,###,###.##')
             LINEAS = LINEAS + 1
          ENDIF
        ENDIF
        SKIP
      ENDDO
      IF HACE
          IF IMPRE
             @ LINEAS + 1,0 SAY CHR(27) + CHR(71) + CHR(27) + CHR(45) + '1' + 'TOTAL DEL RUBRO :                                  ' +  TRANSFORM(TOT_RUBRO,'###,###,###.##') + CHR(27) + CHR(72) + CHR(27) + CHR(45) + '0'
          ELSE
             @ LINEAS + 1,0 SAY 'TOTAL DEL RUBRO :                                                 ' +  TRANSFORM(TOT_RUBRO,'###,###,###.##')
          ENDIF
          LINEAS = LINEAS + 2
      ENDIF
ENDDO
IF IMPRE
     @ LINEAS + 2,0 SAY CHR(14) + 'TOTAL GENERAL : ' + TRANSFORM(TOT_GEN,'###,###,###,###.##')
     EJECT
     SET DEVI TO SCREEN
ELSE
    @ LINEAS + 2,0 SAY 'TOTAL GENERAL : ' + TRANSFORM(TOT_GEN,'###,###,###,###.##')
    DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
    ESPERAR(0)
ENDIF
ERASE AUXILI00.NTX
CLOSE ALL
RETURN



PROCEDURE INI_CAJA
******************

SELE 27
SEEK CAJAIG->RUBRO
IF M_CAJA = INGRES
   HACE = .T.
ELSE
   HACE = .F.
ENDIF
SELE 26
RUBRO_ANT = RUBRO
IF HACE
   DO ENC_CAJA3
ENDIF
TOT_RUBRO = 0
RETURN


PROCEDURE ENC2
**************

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
@ LINEAS,25 SAY 'LISTADO DE CAJA POR RUBROS'
@ LINEAS + 2,2 SAY 'Desde Fecha : ' + DTOC(M_DESDE) + ' Hasta Fecha : ' + DTOC(M_HASTA)
@ LINEAS + 3,2 SAY 'Hoja Nro : ' + STR(HOJA,3,0)
@ LINEAS + 4,0 SAY REPLICATE('=',80)
@ LINEAS + 5,0 SAY 'Fecha                Detalle                                            Importe'
@ LINEAS + 6,0 SAY REPLICATE('=',80)
SELE 27
SEEK CAJAIG->RUBRO
SELE 26
IF IMPRE
   @ LINEAS + 7,1 SAY CHR(14) + CHR(27) + CHR(71) + CHR(27) + CHR(52) + RUBROS->DESCR + CHR(27) + CHR(53) + CHR(27) + CHR(72)
ELSE
   SET COLOR TO W+
   @ LINEAS + 7,1 SAY RUBROS->DESCR
   SET COLOR TO
ENDIF
LINEAS = 9
HOJA = HOJA + 1
RETURN

PROCEDURE ENC_CAJA3
*******************

IF LINEAS > 66 .AND. IMPRE
      DO ENC2
      RETURN
ENDIF
IF LINEAS > 20 .AND. !IMPRE
      DO ENC2
      RETURN
ENDIF

SELE 27
SEEK CAJAIG->RUBRO
SELE 26
@ LINEAS + 1,0 SAY REPLICATE('=',80)
IF IMPRE
   @ LINEAS + 2,1 SAY CHR(14) + CHR(27) + CHR(71) + CHR(27) + CHR(52) + RUBROS->DESCR + CHR(27) + CHR(53) + CHR(27) + CHR(72)
ELSE
   SET COLOR TO W+
   @ LINEAS + 2,1 SAY RUBROS->DESCR
   SET COLOR TO
ENDIF
LINEAS = LINEAS + 3
RETURN


PROCEDURE LIST_CAJA
*******************
*Listado de Caja.

PARAMETERS M_GOC,M_IOE

*M_GOC = Grande o Chica.
*M_IOE = Ingresos o Egresos

CLEAR
@ 1,0 TO 23,79 DOUBLE
SET COLOR TO I
@ 3,30 SAY 'LISTADO DE CAJA'
SET COLOR TO
DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
@ 5,1 TO 5,78
M_DESDE = M_FECHA
M_HASTA = M_FECHA
@ 8,3 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
@ 10,3 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
READ
IF LASTKEY() = 27
    RETURN
ENDIF

SELE 27
USE RUBROS INDEX RUBROS

SELE 26
USE CAJAIG INDEX CAJAIG2

IMPRE = .F.
IF APRUEBA(24,0,11)
     SET DEVI TO PRINT
     @ PROW(),PCOL() SAY CHR(18)
     IMPRE = .T.
ENDIF

LINEAS = 70
HOJA = 1
PRIMERA = .T.
GO TOP
STOR 0 TO M_TOTAL1,M_TOTAL2,M_TOTAL3,M_TOTAL4,M_TOTAL5,M_TOTAL6
STOR 0 TO M_T1,M_T2,M_T3,M_T4,M_T5,M_T6
DO WHILE !EOF()
             IF LINEAS > 66 .AND. IMPRE
                    DO ENC_CAJA
             ENDIF
             IF LINEAS > 20 .AND. !IMPRE
                    DO ENC_CAJA
             ENDIF
             IF TIPO = 'I'
                M_TOTAL1 = M_TOTAL1 + IMPESOS
                M_TOTAL2 = M_TOTAL2 + IMPDOC
                M_TOTAL5 = M_TOTAL5 + IMPDOL
             ELSE
                M_TOTAL3 = M_TOTAL3 + IMPESOS
                M_TOTAL4 = M_TOTAL4 + IMPDOC
                M_TOTAL6 = M_TOTAL6 + IMPDOL
             ENDIF
             IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA
                 IF TIPO = 'I'
                    @ LINEAS,0 SAY STR(NRO,5,0) + '-' + DTOC(FECHA) + ' ' + SUBSTR(DETALLE,1,20) + '  ' + TRANSFORM(IMPESOS + IMPDOL,'###,###.##') + '          ' + TRANSFORM(IMPDOC,'###,###.##')
                    LINEAS = LINEAS + 1
                 ELSE
                    @ LINEAS,0 SAY STR(NRO,5,0) + '-' + DTOC(FECHA) + ' ' + SUBSTR(DETALLE,1,20) + '            ' + TRANSFORM(IMPESOS + IMPDOL,'###,###.##') + '          ' + TRANSFORM(IMPDOC,'###,###.##')
                    LINEAS = LINEAS + 1
                 ENDIF
                 IF TIPO = 'I'
                    M_T1 = M_T1 + IMPESOS
                    M_T2 = M_T2 + IMPDOC
                    M_T5 = M_T5 + IMPDOL
                 ELSE
                    M_T3 = M_T3 + IMPESOS
                    M_T4 = M_T4 + IMPDOC
                    M_T6 = M_T6 + IMPDOL
                 ENDIF
             ENDIF
             SKIP
ENDDO
IF IMPRE
     @ LINEAS + 1,0 SAY REPLICATE('=',80)
     @ LINEAS + 2,0 SAY 'Totales del Periodo :                '  + TRANSFORM(M_T1+M_T5,'###,###.##') + TRANSFORM(M_T3+M_T6,'###,###.##') + TRANSFORM(M_T2,'###,###.##') + TRANSFORM(M_T4,'###,###.##')
     @ LINEAS + 3,0 SAY 'Totales Generales   :                '  + TRANSFORM(M_TOTAL1+M_TOTAL5,'###,###.##') + TRANSFORM(M_TOTAL3+M_TOTAL6,'###,###.##') + TRANSFORM(M_TOTAL2,'###,###.##') + TRANSFORM(M_TOTAL4,'###,###.##')
     DO PONE_SAL WITH .T.
     EJECT
     SET DEVI TO SCREEN
ELSE
    @ LINEAS + 1,0 SAY REPLICATE('=',80)
    @ LINEAS + 2,0 SAY 'Totales del Periodo  :               '  + TRANSFORM(M_T1+M_T5,'###,###.##') + TRANSFORM(M_T3+M_T6,'###,###.##') + TRANSFORM(M_T2,'###,###.##') + TRANSFORM(M_T4,'###,###.##')
    @ LINEAS + 3,0 SAY 'Totales Generales    :               '  + TRANSFORM(M_TOTAL1+M_TOTAL5,'###,###.##') + TRANSFORM(M_TOTAL3+M_TOTAL6,'###,###.##') + TRANSFORM(M_TOTAL2,'###,###.##') + TRANSFORM(M_TOTAL4,'###,###.##')
    DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
    ESPERAR(0)
    DO PONE_SAL WITH .F.
ENDIF
CLOSE ALL
RETURN


PROCEDURE ENC_CAJA
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
@ LINEAS,30 SAY 'LISTADO DE CAJA'
@ LINEAS + 2,2 SAY 'Desde Fecha : ' + DTOC(M_DESDE) + ' Hasta Fecha: ' + DTOC(M_HASTA)
@ LINEAS + 3,2 SAY 'Hoja Nro : ' + STR(HOJA,3,0)
@ LINEAS + 4,0 SAY REPLICATE('=',80)
@ LINEAS + 5,0 SAY 'Int.  Fecha          DETALLE                  CAJA             BANCOS'
@ LINEAS + 6,0 SAY '                                      |ENTRADAS| SALIDAS | ENTRADAS| SALIDAS|'
@ LINEAS + 7,0 SAY REPLICATE('=',80)
LINEAS = 9
HOJA = HOJA + 1
RETURN

PROCEDURE PONE_SAL
******************
*Dibujo de Saldos de Caja
PARAMETERS IMPRE
IF !IMPRE
    CLEAR
    DO TITULO
    SET COLOR TO W+
    @ 10,15 SAY  'RESUMEN DE CAJA ENTRE EL : ' + DTOC(M_DESDE) + ' Y EL ' + DTOC(M_HASTA)
    SET COLOR TO
    @ 13,2 SAY  'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
    @ 14,2 SAY  '³  CONCEPTO   ³  EFECTIVO   ³   BANCOS    ³   DOLARES   ³   TOTALES   ³'
    @ 15,2 SAY  'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
    @ 16,2 SAY  '³  Entradas   ³             ³             ³             ³             ³'
    @ 17,2 SAY  'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
    @ 18,2 SAY  '³  Salidas    ³             ³             ³             ³             ³'
    @ 19,2 SAY  'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
    @ 20,2 SAY  '³  Saldos     ³             ³             ³             ³             ³'
    @ 21,2 SAY  'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
    @ 16,20 SAY TRANSFORM(M_TOTAL1,'###,###.##')
    @ 16,34 SAY TRANSFORM(M_TOTAL2,'###,###.##')
    @ 16,48 SAY TRANSFORM(M_TOTAL5,'###,###.##')
    @ 16,62 SAY TRANSFORM(M_TOTAL1 + M_TOTAL2+M_TOTAL5,'###,###.##')
    @ 18,20 SAY TRANSFORM(M_TOTAL3,'###,###.##')
    @ 18,34 SAY TRANSFORM(M_TOTAL4,'###,###.##')
    @ 18,48 SAY TRANSFORM(M_TOTAL6,'###,###.##')
    @ 18,62 SAY TRANSFORM(M_TOTAL3 + M_TOTAL4 + M_TOTAL6,'###,###.##')
    @ 20,20 SAY TRANSFORM(M_TOTAL1-M_TOTAL3,'###,###.##')
    @ 20,34 SAY TRANSFORM(M_TOTAL2-M_TOTAL4,'###,###.##')
    @ 20,48 SAY TRANSFORM(M_TOTAL5-M_TOTAL6,'###,###.##')
    @ 20,62 SAY TRANSFORM((M_TOTAL1 - M_TOTAL3) + (M_TOTAL5 - M_TOTAL6) + (M_TOTAL2 - M_TOTAL4),'###,###.##')
    DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
    ESPERAR(0)
ELSE
    @ LINEAS + 4,2 SAY  'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
    @ LINEAS + 5,2 SAY  '³  CONCEPTO   ³  EFECTIVO   ³   BANCOS    ³  DOLARES    ³  TOTALES    ³'
    @ LINEAS + 6,2 SAY  'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
    @ LINEAS + 7,2 SAY  '³  Entradas   ³             ³             ³             ³             ³'
    @ LINEAS + 7,20 SAY TRANSFORM(M_TOTAL1,'###,###.##')
    @ LINEAS + 7,34 SAY TRANSFORM(M_TOTAL2,'###,###.##')
    @ LINEAS + 7,48 SAY TRANSFORM(M_TOTAL5,'###,###.##')
    @ LINEAS + 7,62 SAY TRANSFORM(M_TOTAL1 + M_TOTAL2 + M_TOTAL5,'###,###.##')
    @ LINEAS + 8,2 SAY  'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
    @ LINEAS + 9,2 SAY  '³  Salidas    ³             ³             ³             ³             ³'
    @ LINEAS + 9,20 SAY TRANSFORM(M_TOTAL3,'###,###.##')
    @ LINEAS + 9,34 SAY TRANSFORM(M_TOTAL4,'###,###.##')
    @ LINEAS + 9,48 SAY TRANSFORM(M_TOTAL6,'###,###.##')
    @ LINEAS + 9,62 SAY TRANSFORM(M_TOTAL3 + M_TOTAL4 + M_TOTAL6,'###,###.##')
    @ LINEAS + 10,2 SAY  'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
    @ LINEAS + 11,2 SAY  '³  Saldos     ³             ³             ³             ³             ³'
    @ LINEAS + 11,20 SAY TRANSFORM(M_TOTAL1-M_TOTAL3,'###,###.##')
    @ LINEAS + 11,34 SAY TRANSFORM(M_TOTAL2-M_TOTAL4,'###,###.##')
    @ LINEAS + 11,48 SAY TRANSFORM(M_TOTAL5-M_TOTAL6,'###,###.##')
    @ LINEAS + 11,62 SAY TRANSFORM((M_TOTAL1 - M_TOTAL3)  + (M_TOTAL2 - M_TOTAL4) + (M_TOTAL5 - M_TOTAL6),'###,###.##')
    @ LINEAS + 12,2 SAY  'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
ENDIF
RETURN


PROCEDURE IMP_COMPRO
********************
*Imprime comprobante de Caja

PARAMETERS M_IOG

SET DEVI TO PRINT
@ PROW(),PCOL() SAY CHR(18)
@ 1,1 SAY REPLICATE('=',79)
@ 2,1 SAY 'Movimiento de Caja Numero : ' + STR(M_NUMERO,5,0)
@ 3,1 SAY 'Movimiento de Caja        : ' + CHR(27) + CHR(71) + IIF(M_IOG = 1,'INGRESO','EGRESO') + CHR(27) + CHR(72)
@ 4,1 SAY 'Rubro                     : ' + RUBROS->DESCR
@ 5,1 SAY 'Detalle de la Operacion   : ' + M_DETALLE
@ 6,1 SAY 'Importe Total Operacion   : ' + TRANSFORM(M_IMPESOS+M_IMPDOL+M_IMPDOC,'###,###.##')
@ 7,1 SAY 'Fecha de la Operacion     : ' + DTOC(M_FOPE)
@ 8,1 SAY REPLICATE('=',79)
EJECT
SET DEVI TO SCREEN
RETURN


PROCEDURE BAJA_DATO
*******************
*Da de Baja al Movimiento de Caja. Si cancelo Facturas con este movimiento no
*se permite dar de baja. Debe Hacerlo Manualmente.

SELE 1
IF L = 2 .AND. IMPDOC <> 0
     DO M_CARTEL WITH 89,24,0,.T.,.T.,.T.
     ESPERAR(0)
     RETURN
ENDIF

IF CANCELA = 'S'
     DO M_CARTEL WITH 86,24,0,.T.,.T.,.T.
     ESPERAR(0)
     RETURN
ELSE
     DELETE
     PACK
ENDIF

IF L = 1
    SELE 6
    SEEK STR(M_NUMERO,5,0)
    DO WHILE !EOF()
        IF NRO = M_NUMERO
            DELETE
        ELSE
            GO BOTTOM
        ENDIF
        SKIP
    ENDDO
    PACK
ENDIF
RETURN


PROCEDURE MENBANCO
******************

DO WHILE .T.
     DECLARE MENPEE[2]
     DECLARE OPPEE[2]
     OPPEE[1]='ABM DE DATOS AL BANCO'
     OPPEE[2]='VISUALIZAR RESUMEN DE CUENTA'

     MENPEE[1]='          º  Datos de Debitos y Creditos Bancarios'
     MENPEE[2]='          º  Visualizar Resumen de Cuenta de un Banco'

*     Displaya opciones y captura.
      OPPE=OPCIONES('SISTEMA DE VENTAS - MOVIMIENTOS DE CAJA',OPPEE,MENPEE)
*     Fin
      IF LASTKEY()=27
       EXIT
      ENDIF
      DO CASE
            CASE OPPE=1
              DO ABMDBAN
            CASE OPPE=2
              DO LIS_RCTA
      ENDCASE
ENDDO
CLOSE ALL
RETURN


PROCEDURE ABMDBAN
*****************


SELE 1
USE BANCOS INDEX BANCOS

SELE 2
USE RESUMEN INDEX RESUMEN,RESUMEN2
SET ORDER TO 1
GO BOTTOM
M_NUMERO = NUMERO + 1

DO WHILE .T.
    CLEAR
    DO TITULO
    @ 1,0 TO 23,79 DOUBLE
    SET COLOR TO I
    @ 3,30 SAY 'ABM de DATOS a UN BANCO'
    SET COLOR TO
    DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
    @ 5,1 TO 5,78
    @ 8,3 SAY 'Numero Interno de Operacion : ' GET M_NUMERO PICT '#####'
    READ
    IF LASTKEY() = 27
        EXIT
    ENDIF
    SELE 2
    SEEK M_NUMERO
    IF !FOUND()
          M_BANCO = 1
          M_DETALLE = SPACE(30)
          M_IMPORTE = 0
          M_DOC = 'D'
          M_FEC = M_FECHA
    ELSE
          DO M_CARTEL WITH 35,24,0,.T.,.F.,.T.
          M_DESEO = 'M'
          @ 24,70 GET M_DESEO PICT 'A' VALID M_DESEO = 'M' .OR. M_DESEO = 'B'
          READ
          IF LASTKEY() = 27
              LOOP
          ENDIF
          IF M_DESEO = 'B'
               IF APRUEBA(24,0,3)
                    DELETE
                    PACK
               ENDIF
               LOOP
          ENDIF
          M_BANCO = BANCO
          M_DETALLE = DETALLE
          M_IMPORTE = IMPORTE
          M_DOC = DOC
          M_FEC = FECHA
    ENDIF
    @ 10,3 SAY 'Codigo de Banco      : ' GET M_BANCO PICT '###' VALID VALBANCO(M_BANCO,11,3,'1')
    @ 13,3 SAY 'Detalle Operacion    : ' GET M_DETALLE
    @ 15,3 SAY 'Importe Operacion    : ' GET M_IMPORTE PICT '########.##' VALID M_IMPORTE >= 0
    @ 17,3 SAY '(D)ebito o (C)redito : ' GET M_DOC PICT 'A' VALID M_DOC = 'D' .OR. M_DOC = 'C'
    @ 19,3 SAY 'Fecha Operacion      : ' GET M_FEC PICT '99/99/99' VALID VALFECH(M_FEC)
    READ
    IF LASTKEY() = 27
         LOOP
    ENDIF
    IF APRUEBA(24,0,2)
          SELE 2
          MARCA = .F.
          IF !FOUND()
              APPE BLANK
          ENDIF
          REPLACE NUMERO WITH M_NUMERO
          REPLACE BANCO WITH M_BANCO
          REPLACE DETALLE WITH M_DETALLE
          REPLACE IMPORTE WITH M_IMPORTE
          REPLACE DOC WITH M_DOC
          REPLACE FECHA WITH M_FEC
    ENDIF
ENDDO
CLOSE ALL
RETURN

PROCEDURE VALBANCO
******************
PARAMETERS M_BAN,M_FI,M_CO,M_SELE

SELE &M_SELE
SEEK M_BAN
IF !FOUND()
    DO M_CARTEL WITH 120,24,0,.T.,.T.,.T.
    ESPERAR(0)
    DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
    RETURN(.F.)
ELSE
    SET COLOR TO I
    @ M_FI,M_CO SAY NOMBRE
    SET COLOR TO
    RETURN(.T.)
ENDIF


PROCEDURE LIS_RCTA
******************

SELE 1
USE BANCOS INDEX BANCOS

STOR M_FECHA TO M_DESDE,M_HASTA
M_BANCO = 1
@ 19,0 CLEAR TO 23,79
@ 19,0 TO 23,79
@ 20,1 SAY 'Codigo de Banco a Listar : ' GET M_BANCO PICT '###' VALID VALBANCO(M_BANCO,21,1,'1')
@ 22,1 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
@ 22,55 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
READ
IF LASTKEY() = 27
    CLOSE ALL
    RETURN
ENDIF


IMPRE = .F.
IF APRUEBA(24,0,11)
     IMPRE = .T.
     DO M_CARTEL WITH 10,24,0,.T.,.F.,.T.
     ESPERAR(0)
     IF LASTKEY() = 27
          CLOSE ALL
          RETURN
     ENDIF
     IF ERROR_PRINT()
         RETURN
     ENDIF
     SET PRINT ON
     SET PRINT TO LPT1
     SET DEVI TO PRINT
ENDIF

PRIMERA = .T.
HOJA = 1
LINEAS = 70
M_SALDO = 0
IMPSAL = .F.
IMPRIMIO = .F.
SELE 2
USE RESUMEN INDEX RESUMEN2
SEEK M_BANCO

DO WHILE !EOF() .AND. BANCO = M_BANCO
          IF LINEAS > 65 .AND. IMPRE
               DO ENC_RCTA
          ENDIF
          IF LINEAS > 20 .AND. !IMPRE
               DO ENC_RCTA
          ENDIF
          IF FECHA < M_DESDE
              IF DOC = 'D'
                 M_SALDO = M_SALDO - IMPORTE
              ELSE
                 M_SALDO = M_SALDO + IMPORTE
              ENDIF
          ENDIF
          IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA
                IF !IMPSAL
                     SET COLOR TO W+
                     @ LINEAS,1 SAY 'SALDO ANTERIOR'
                     @ LINEAS,68 SAY TRANSFORM(M_SALDO,'###,###.##')
                     IMPSAL = .T.
                     LINEAS = LINEAS + 1
                ENDIF
                IF DOC = 'D'
                     M_SALDO = M_SALDO - IMPORTE
                ELSE
                    M_SALDO = M_SALDO + IMPORTE
                ENDIF
                @ LINEAS,1 SAY STR(NUMERO,5,0) + ' ' + DTOC(FECHA) + ' ' + DETALLE + ' ' + IIF(DOC='D',TRANSFORM(IMPORTE,'###,###.##') + SPACE(10),SPACE(10) + TRANSFORM(IMPORTE,'###,###.##')) + ' ' + TRANSFORM(M_SALDO,'###,###.##')
                LINEAS = LINEAS + 1
                IMPRIMIO = .T.
          ENDIF
          SKIP
ENDDO
IF !IMPSAL
    IF IMPRIMIO
        SET COLOR TO W+
        @ LINEAS,1 SAY 'SALDO ANTERIOR'
        @ LINEAS,68 SAY TRANSFORM(M_SALDO,'###,###.##')
        IMPSAL = .T.
        LINEAS = LINEAS + 1
    ENDIF
ENDIF
IF IMPRE
   EJECT
   SET DEVI TO SCREEN
   SET PRINT OFF
ELSE
   DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
   ESPERAR(0)
ENDIF
RETURN



PROCEDURE ENC_RCTA
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
SET COLOR TO I
@ LINEAS,30 SAY 'RESUMEN DE CUENTA BANCARIO'
SET COLOR TO
@ LINEAS+1,1 SAY 'Banco : ' + BANCOS->NOMBRE
@ LINEAS+1,50 SAY 'Hoja : ' + STR(HOJA,3,0)
@ LINEAS+2,1 SAY 'Desde Fecha : ' + DTOC(M_DESDE) + ' Hasta Fecha : ' + DTOC(M_HASTA)
@ LINEAS + 3,1 SAY REPLICATE('=',79)
@ LINEAS + 4,1 SAY 'INTERNO  FECHA    DETALLE OPERACION                 DEBE     HABER     SALDO'
@ LINEAS + 5,1 SAY REPLICATE('=',79)
LINEAS = 7
HOJA = HOJA + 1
RETURN


PROCEDUR ABMBANCO
*****************
*ABM de BANCOS

if !seguridad(mm_clave,'J')
   do m_cartel with 4,24,0,.t.,.t.,.t.
   esperar(0)
   return
endif
PARAMETERS CIERRA

sele 1
use BANCOS INDEX BANCOS

private M_COD,M_NOM

M_COD =1
do while .t.
   clear
   do titulo
   do panTBAN
   @ 5,22 get M_COD pict '###'
   read
   if lastkey()=27
      exit
   endif
   seek M_COD
   if .not. found()
      @ 24,0 say space(79)
      if aprueba (24,0,25)
         @ 24,0 say space(79)
         marca=.t.
         do blanBAN
         do carga_BAN
         if aprueba  (24,0,2)
            @ 24,0 say space(79)
            do grabBAN
         endif
      endif
   else
      marca=.f.
      do blanBAN
      do m_cartel with 35,24,0,.t.,.t.,.t.
      letra='M'
      @ 24,66 get letra pict 'A' valid letra = 'B' .or. letra = 'M'
      read
      @ 24,0 say space(79)
      if lastkey()=27
         loop
      endif
      if letra='M'
         do carga_BAN
         if lastkey()=27
            loop
         endif
         if aprueba(24,0,36)
            @ 24,0 say space(79)
            do graBBAN
         endif
      else
         if aprueba(24,0,37)
            do borraBAN
            loop
         endif
      endif
   endif
enddo
close all
return

procedure pantBAN
********* *******

@ 1,1 to  15,79 double
set color to i
@ 2,30  say " - ABM de BANCOS - "
set color to
@ 3,2 to 3,78
@ 5,3 say 'Codigo de Banco :'
@ 7,3 say 'Nombre          :'
do m_cartel with 1,24,0,.t.,.f.,.t.
return

procedure carga_ban
*******************
@ 7,21 get m_nom pict '@!'
read
return

procedure blanBAN
******************

if marca
   M_NOM=space(30)
else
   M_NOM= NOMBRE
endif
return

procedure grabBAN
*****************
* Grabacion del Registro.

IF MARCA
   append blank
ENDIF
REPLACE NUMERO WITH M_COD
REPLACE NOMBRE WITH M_NOM
RETURN

procedure borraBAN
******************
* Borra el registro seleccionado en todos los archivos.

sele 1
delete
pack
return

procedure lis_BAN
*****************
*Listado de BANCOS

sele 1
use BANCOS INDEX BANCOS

impre = .f.
@ 24,0 SAY SPACE(79)
if aprueba(24,0,11)
   impre = .t.
endif
if lastkey() = 27
   return
endif
do m_cartel with 10,24,0,.t.,.t.,.t.
esperar(0)
if lastkey() = 27
   return
endif
if impre
   IF ERROR_PRINT()
       RETURN
   ENDIF
   SET PRINT ON
   SET PRINT TO LPT1
   set device to print
endif
go top
lineas = 66
primera = .t.
hoja = 1
do while !eof()
   if lineas > 65 .and. impre
      do enc_BAN
   else
      if lineas > 20 .and. !impre
         do enc_BAN
      endif
   endif
   @ lineas,0 say str(NUMERO,3,0)+'        ' + NOMBRE
   skip
   lineas = lineas + 1
enddo
if impre
   eject
   set device to screen
   SET PRINT OFF
else
   @ 22,3 say 'Pulse Cualquier Tecla Para Continuar ...'
   esperar(0)
endif
close all
return

procedure enc_BAN
******************
*Encabezamiento del Listado

if !primera
   if impre
      eject
   else
      @ 22,3 say 'Pulse Cualquier Tecla Para Continuar ...'
      esperar(0)
      @ 9,2 clear to 24,79
   endif
else
   primera = .f.
   if !impre
      @ 0,0 clear to 24,79
   endif
endif
lineas = 1
@ lineas,10 say iif(impre,chr(14),'                   ') + '* LISTADO DE BANCOS * '
@ lineas + 2,2 say 'Fecha: ' + dtoc(date())
@ lineas + 2,50 say 'Hoja Nro : ' + str(hoja,1,2)
@ lineas + 4,5 say 'Nro.      NOMBRE'
hoja = hoja + 1
@ lineas + 5,2 say replicate('=',77)
lineas = 7
return


PROCEDURE OPE_CAJA
******************
*Consulta de Operaciones de Caja


SELE 1
USE CAJAIG INDEX CAJAIG3

SELE 2
USE DOCUM INDEX DOCUM,DOCUM2
SET ORDER TO 1

SELE 3
USE RUBROS INDEX RUBROS

SELE 4
USE CLIENTES INDEX CLIENTES

SELE 5
USE PROVEDOR INDEX PROVEDOR


M_NUMERO = 1
DO WHILE .T.
    CLEAR
    DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
    DO TITULO
    @ 1,0 TO 23,79 DOUBLE
    SET COLOR TO I
    @ 3,25 SAY 'CONSULTA DE OPERACIONE DE CAJA'
    SET COLOR TO
    @ 5,1 TO 5,78
    @ 8,3 SAY 'Numero de Operacion : ' GET M_NUMERO PICT '#####'
    READ
    IF LASTKEY() = 27
        EXIT
    ENDIF
    SELE 1
    SEEK M_NUMERO
    IF !FOUND()
        DO M_CARTEL WITH 121,24,0,.T.,.T.,.T.
        ESPERAR(0)
        LOOP
    ENDIF
    IF TIPO = 'I'
       SELE 2
       SET ORDER TO 1
       SEEK STR(CAJAIG->NRO,5,0)
       M_CONDICION = '!EOF() .AND. NRO = M_NUMERO'
    ELSE
       SELE 2
       SET ORDER TO 2
       SEEK CAJAIG->NRO
       M_CONDICION = '!EOF() .AND. NROSALI = M_NUMERO'
    ENDIF
    SELE 3
    SEEK CAJAIG->RUBRO
    SELE 4
    SEEK CAJAIG->CLIENTE
    SELE 5
    SEEK CAJAIG->PROVEDOR
    SELE 1
    CLEAR
    @ 1,0 TO 23,79 DOUBLE
    DO TITULO
    @ 2,1 SAY 'Nro. Ope.: ' + TRANSFORM(M_NUMERO,'#####')
    @ 3,1 SAY 'Tipo     : ' + IIF(TIPO='I','INGRESO','EGRESO')
    @ 4,1 SAY 'Rubro    : ' + RUBROS->DESCR
    @ 5,1 SAY 'Detalle  : ' + DETALLE
    @ 6,1 SAY 'Pesos    : ' + TRANSFORM(IMPESOS-COBI-VARIOS,'###,###.##')
    @ 7,1 SAY 'Document.: ' + TRANSFORM(IMPDOC,'###,###.##')
    @ 8,1 SAY 'Dolares  : ' + TRANSFORM(IMPDOL,'###,###.##')
    @ 9,1 SAY 'Cobinpro : ' + TRANSFORM(COBI,'###,###.##')
    @ 10,1 SAY 'Varios   : ' + TRANSFORM(VARIOS,'###,###.##')
    @ 11,1 SAY 'Fecha    : ' + DTOC(FECHA)
    IF TIPO = 'I'
         @ 12,1 SAY 'Cliente : ' + CLIENTES->NOMBRE
         @ 13,1 SAY 'Numero Recibo : ' + NROREC
    ELSE
         @ 12,1 SAY 'Proveed.: ' + PROVEDOR->NOMBRE
    ENDIF
    SET COLOR TO W+
    @ 14,1 SAY 'Int.   Nro.Doc.        Fecha       Banco      Sucursal      Importe'
    SET COLOR TO
    SELE 2
    LINEAS = 15
    DO WHILE &M_CONDICION
         @ LINEAS,1 SAY STR(NROINT,5,0) + ' ' + NRODOC + ' ' + DTOC(FECHA) + ' ' + BANCO + ' ' + CLEARING + ' ' + TRANSFORM(IMPORTE,'###,###.##')
         LINEAS = LINEAS + 1
         SKIP
         IF LINEAS > 22
             DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
             ESPERAR(0)
             @ 12,1 CLEAR TO 22,78
             LINEAS = 15
         ENDIF
    ENDDO
    DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
    ESPERAR(0)
ENDDO
CLOSE ALL
RETURN

PROCEDURE NROINTER
******************
*Consulta de un cheque por numero Interno

SELE 1
USE DOCUM INDEX DOCUM2

SELE 2
USE CLIENTES INDEX CLIENTES

M_NUMERO = 1
DO WHILE .T.
    CLEAR
    DO TITULO
    @ 1,0 TO 23,79 DOUBLE
    SET COLOR TO I
    @ 3,25 SAY 'CONSULTA DE UN DOCUMENTO POR NUMERO INTERNO'
    SET COLOR TO
    DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
    @ 5,1 TO 5,78
    @ 8,3 SAY 'Numero Interno : ' GET M_NUMERO PICT '#####'
    READ
    IF LASTKEY() = 27
        EXIT
    ENDIF
    SELE 1
    SEEK M_NUMERO
    IF !FOUND()
         DO M_CARTEL WITH 79,24,0,.T.,.T.,.T.
         ESPERAR(0)
         LOOP
    ENDIF
    SELE 2
    SEEK DOCUM->CLIENTE
    SELE 1
    SET COLOR TO W+
    @ 10,3 SAY 'Numero de Operacion de Caja : ' + TRANSFORM(NRO,'#####')
    @ 11,3 SAY 'Numero de Documento         : ' + NRODOC
    @ 12,3 SAY 'Fecha del Documento         : ' + DTOC(FECHA)
    @ 13,3 SAY 'Banco                       : ' + BANCO
    @ 14,3 SAY 'Sucursal                    : ' + CLEARING
    @ 15,3 SAY 'Importe                     : ' + TRANSFORM(IMPORTE,'###,###.##')
    @ 16,3 SAY 'Cliente                     : ' + CLIENTES->NOMBRE
    @ 17,3 SAY 'Destino                     : ' + SUBSTR(DESTINO,1,40)
    SET COLOR TO
    DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
    ESPERAR(0)
ENDDO
CLOSE ALL
RETURN
