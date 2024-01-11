*******************************************************************************
*Fuente : FACTURA.PRG                                                         *
*======                                                                       *
*                                                                             *
*Funcion : Facturacion, cambios y devoluciones de mercaderia e impresion de   *
*=======   los mismos.                                                        *
*                                                                             *
*******************************************************************************

*IF !SEGURIDAD(MM_CLAVE,'L')
*       DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*       ESPERAR(0)
*       RETURN
*ENDIF

DO WHILE .T.
   DO PANT_FACTU
   DO PIDE_FACTU
   IF LASTKEY() = 27
      EXIT
   ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE PANT_FACTU
********************
*Pantalla de Facturacion

CLEAR
DO TITULO
@ 1,0 TO 8,79 DOUBLE
@ 8,0 TO 18,79 DOUBLE
@ 2,3 SAY 'N£mero de Cliente     :                                                   '
@ 3,3 SAY 'C¢digo de Vendedor    :                                                   '
@ 4,3 SAY 'Provincia:                                                                '
@ 5,3 SAY 'C¢digo de Comprobante :                   '
@ 6,3 SAY 'Comp.N£mero    :                                      '
@ 6,35 SAY 'Fecha :              '
@ 6,53 SAY 'Pedido (0=Ninguno):      '
@ 7,20 SAY 'Remito (0=Ninguno | -1=Lista de Remitos Pendientes):      '
@ 9,2 SAY 'ITEM   %Bon.  ARTICULO   DESCRIP.     CANTIDAD           PRECIO         TOTAL'
@ 10,2 SAY REPLICATE('=',77)
@ 11,2 CLEAR TO 17,78
RETURN

PROCEDURE PANT_F2
*****************
*2da Pantalla de Facturaci¢n

@ 19,0 TO 23,79 DOUBLE
@ 20,1 SAY 'Item -1 FIN:'
@ 20,20 SAY 'Articulo :              '
@ 20,55 SAY 'Cantidad :          '
@ 21,1  SAY 'Lista Nro :   '
@ 21,20 SAY 'Precio:                                                  '
@ 22,1 SAY SPACE(60)
RETURN

PROCEDURE PIDE_FACTU
********************
*Pide datos del  comprobante

DECLARE V_COMPRO[7]
V_COMPRO[1] = 'FACTURA TIPO A'
V_COMPRO[2] = 'FACTURA TIPO B'
V_COMPRO[3] = 'NOTA DE DEBITO'
V_COMPRO[4] = 'NOTA DE CREDITO'
V_COMPRO[5] = 'REMITO'
V_COMPRO[6] = 'RECIBO AUTORIZADO'
V_COMPRO[7] = 'NOTA DE CREDITO B'

DECLARE COD_COMP[7]
COD_COMP[1]='FAC'
COD_COMP[2]='CON'
COD_COMP[3]='NDB'
COD_COMP[4]='NCR'
COD_COMP[5]='REM'
COD_COMP[6]='REC'
COD_COMP[7]='NCB'

DECLARE V_ARTI[35]
DECLARE V_CANTIDAD[35]
DECLARE V_PRECIO[35]
DECLARE V_TOTAL[35]
DECLARE V_DESCUEN[35]
DECLARE V_DESCR[35]
DECLARE V_DESCU[4]
DECLARE V_DETALLE[35]
DECLARE V_PRELIS[35]

MES_D = VAL(SUBSTR(DTOC(M_FECHA),4,2))
DIA_D = VAL(SUBSTR(DTOC(M_FECHA),1,2))


R5 = .F.

PRIVATE M_IVA,ADIC,TOTNETO,REMITO,M_OC,PEPE,M_PANTA,COPIAS,M_BULTOS,M_COPREMI,M_EXPRES,M_DESCU,M_BONIF,M_PROVI,TOTALF,M_PAQUETES,M_LIOS,M_KILOS,M_CONDICIONES,M_ASEGURA
PEPE = 1
M_DESCU = 0
M_OC = SPACE(10)
PRIVATE M_COND1,M_COND2,M_COND3,M_COND4,M_COND5,M_FRASE
DECLARE V_PORC[15]
DO WHILE .T.
   DO WHILE .T.
       SELE 2
       USE ARTIC INDEX ARTIC,AR2

       SELE 9
       USE VENDEDOR INDEX VENDEDOR

       SELE 14
       USE PEDIDOS INDEX PEDIDOS

       SELE 15
       USE PEDIDOS2 INDEX PEDIDOS2

       SELE 20
       USE DOLAR INDEX DOLAR
       SEEK M_FECHA
       M_COTIZA = DOLAR->COTIZ

       SELE 21
       USE EXPRESO INDEX EXPRESO

       SELE 22
       USE PROVI INDEX PROVI

       SELE 25
       USE IVA

      @ 24,0 SAY SPACE(79)
      DO PANT_FACTU
      M_CLIENTE = SPACE(10)
      @ 2,28 GET M_CLIENTE PICT '@!'
      READ
      IF LASTKEY() = 27
         EXIT
      ENDIF
      SELE 11
      USE CLIENTES INDEX CLIENTES
      ARCHIVO = 'CLIENTES'
      SELE 19
      USE DOMICILI INDEX DOMICILI
      ARCHI2 = 'DOMICILI'
      SELE 11
      SEEK M_CLIENTE
      IF FOUND()
         SET COLOR TO I
         @ 2,40 SAY SUBSTR(NOMBRE,1,37)
         SET COLOR TO
         M_TIPOC = 1
         DECLARE DOM_ENT[CANTS]
         EXIT
      ELSE
         DO M_CARTEL WITH 40,24,0,.T.,.T.,.T.
         ESPERAR(0)
         @ 24,0 SAY SPACE(79)
      ENDIF
   ENDDO
   IF LASTKEY() = 27
      EXIT
   ENDIF
   DO WHILE .T.
      SELE 9
      M_VENDEDOR = &ARCHIVO->COD_VEND
      @ 3,28 GET M_VENDEDOR PICT '@!'
      READ
      IF LASTKEY() = 27
         EXIT
      ENDIF
      SEEK M_VENDEDOR
      IF FOUND()
         SET COLOR TO I
         @ 3,40 SAY SUBSTR(NOMBRE,1,37)
         SET COLOR TO
         EXIT
      ELSE
         DO M_CARTEL WITH 19,24,0,.T.,.T.,.T.
         ESPERAR(0)
         @ 24,0 SAY SPACE(79)
      ENDIF
   ENDDO
   IF LASTKEY() = 27
      EXIT
   ENDIF
   ELEGIDO = .T.
   M_PROVI = CLIENTES->TIPO_CLI
   @ 4,28 GET M_PROVI PICT '###' VALID VALPROVI(M_PROVI,4,40)
   READ
   IF LASTKEY() = 27
      LOOP
   ENDIF
   DO WHILE .T.
      IF  ELEGIDO
         IF CLIENTES->INSCRIP = 'M'
             C = 2
         ELSE
             C = 1
         ENDIF
         ELEGIDO = .F.
      ENDIF
      SAVE SCREEN TO M_PANTA
      C = VENTOPCION('CODIGO DE OPERACION',V_COMPRO,10,30,20,.T.,.T.,C)
      IF LASTKEY() <> 27
         CONTADO = .F.
         IF C = 2
            CONTADO = .T.
            M_COMPRO = COD_COMP[C]
*           C = C - 1
         ELSE
            M_COMPRO = COD_COMP[C]
         ENDIF
      ELSE
         RESTORE SCREEN FROM M_PANTA
         EXIT
      ENDIF
      RESTORE SCREEN FROM M_PANTA
      @ 5,28 SAY SPACE(15)
      SET COLOR TO I
      @ 5,28 SAY V_COMPRO[C]
      SET COLOR TO
      M_FECH = M_FECHA
      SELE 13
      USE CONTADO1 INDEX CONTADO1
      IF M_COMPRO = 'NDB' .OR. M_COMPRO = 'NCR' .OR. M_COMPRO = 'NCB'
          IF M_COMPRO = 'NCB'
               SEEK 'CON'
          ELSE
               SEEK 'FAC'
          ENDIF
      ELSE
          SEEK COD_COMP[C]
      ENDIF
      M_NUMERO = NUMERO
      @ 6,18 GET M_NUMERO PICT '#########'
      READ
      IF LASTKEY() = 27
         LOOP
      ENDIF
      SELE 4
      USE COMPRO1 INDEX COMPRO1,COMPRO2
      SET ORDER TO 1
      SEEK COD_COMP[C] + STR(M_NUMERO,5,0)
      IF FOUND()
           DO M_CARTEL WITH 112,24,0,.T.,.T.,.T.
           ESPERAR(0)
           LOOP
      ENDIF
      NUMCOMP = M_NUMERO
      I = 1
      M_PEDIDO = 0
      @ 6,43 GET M_FECH PICT '99/99/99' VALID VALFECH(M_FECH)
      DO WHILE .T.
         @ 24,0 SAY SPACE(79)
         @ 6,73 GET M_PEDIDO PICT '#####'
         READ
         IF LASTKEY() = 27 .OR. M_PEDIDO = 0
            EXIT
         ENDIF
         SELE 14
         SEEK M_PEDIDO
         IF !FOUND()
              DO M_CARTEL WITH 98,24,0,.T.,.T.,.T.
              ESPERAR(0)
              LOOP
         ELSE
              IF CLIENTE <> M_CLIENTE
                  DO M_CARTEL WITH 99,24,0,.T.,.T.,.T.
                  ESPERAR(0)
                  LOOP
              ELSE
                  IF PENDIENTE
                     DO M_CARTEL WITH 115,24,0,.T.,.T.,.T.
                     ESPERAR(0)
                     @ 24,0 SAY SPACE(79)
                  ENDIF
                  EXIT
              ENDIF
         ENDIF
      ENDDO
      IF LASTKEY() = 27
         LOOP
      ENDIF
      M_REMIAU = 0
      IF M_COMPRO <> 'REM'
            SELE 4
            USE COMPRO1 INDEX COMPRO1,COMPRO2
            DO WHILE .T.
               @ 24,0 SAY SPACE(79)
               @ 7,73 GET M_REMIAU PICT '#####'
               READ
               IF LASTKEY() = 27 .OR. M_REMIAU = 0
                  EXIT
               ENDIF
               IF M_REMIAU = -1
                    DO LIS_REMI
                    LOOP
               ENDIF
               SEEK 'REM' + STR(M_REMIAU,5,0)
               IF !FOUND()
                    DO M_CARTEL WITH 31,24,0,.T.,.T.,.T.
                    ESPERAR(0)
                    LOOP
               ELSE
                    IF CLIENTE <> M_CLIENTE
                        DO M_CARTEL WITH 106,24,0,.T.,.T.,.T.
                        ESPERAR(0)
                        LOOP
                    ELSE
                        IF FACTURADO
                            DO M_CARTEL WITH 107,24,0,.T.,.T.,.T.
                            ESPERAR(0)
                            IF LASTKEY() = 27
                               LOOP
                            ELSE
                               DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
                               EXIT
                            ENDIF
                        ELSE
                            EXIT
                        ENDIF
                    ENDIF
               ENDIF
            ENDDO
            IF LASTKEY() = 27
               LOOP
            ENDIF
      ENDIF
      DO BLANQ_VEC WITH .T.,M_PEDIDO,M_REMIAU
      DO CASE
      CASE COD_COMP[C] = 'NDB'
         M_CONDICIONES = SPACE(40)
         SAVE SCREEN TO MPANTA_44
         DO NOTA_DEB
         RESTORE SCREEN FROM MPANTA_44
         @ 9,2 SAY 'ITEM   ARTICULO   DESCRIP.     CANTIDAD           PRECIO         TOTAL'
         EXIT
      CASE COD_COMP[C] = 'ADL' .OR. COD_COMP[C] = 'REC'
         DO RECIBO
         EXIT
      ENDCASE
      TOTPARES = 0
      DOLAR = .F.
      DO WHILE .T.
         DO WHILE .T.
            TERMINO = .F.
            DO PANT_F2
            IF !R5
               @ 19,0 TO 23,79 DOUBLE
            ELSE
               @ 23,79 SAY '.'
            ENDIF
            SELE 2
            M_ARTI = SPACE(11)
            DO M_CARTEL WITH 113,24,0,.T.,.F.,.T.
            M_ITEM = I
            @ 20,13 GET M_ITEM PICT '##' VALID M_ITEM >=1 .AND. M_ITEM <= 35 .OR. M_ITEM = -1
            READ
            @ 24,0 SAY SPACE(79)
            IF LASTKEY() = 27
               EXIT
            ENDIF
            IF M_ITEM = -1
               SAVE SCREEN TO R_PANT
               DO MUESTRA
               DO PANT_TOT
               DO PIDE_DESCU
               DO PANT_TOT
               MENSAJE = .F.
               IF APRUEBA(24,0,41)
                  MENSAJE = .T.
               ENDIF
               @ 24,0 SAY SPACE(79)
               IF C = 1 .OR. C = 4 .OR. C = 2 .OR. C = 7
                  M_FACTU = .T.
                  M_COPREMI= 0
                  M_EXPRES = SPACE(10)
                  PEPE = 1
                  @ 20,1 CLEAR TO 21,78
                  M_OC = SPACE(10)
                  REMITO = .F.
               ELSE
                  REMITO = .F.
               ENDIF
               @ 20,1 CLEAR TO 21,78
               M_NROREM = STR(M_REMIAU,10,0)
               @ 22,1 SAY SPACE(60)
               IF M_COMPRO <> 'REM'
                  @ 20,2 SAY 'Obs: ' GET M_FRASE PICT '@!'
                  @ 21,2 SAY 'Rem.Nro: ' GET M_NROREM PICT '@!'
               ENDIF
               @ 21,25 say 'Paq.' GET M_PAQUETES PICT '###'
               @ 21,35 SAY 'Lios: ' GET M_LIOS PICT '###'
               @ 21,55 SAY 'Kg: ' GET M_KILOS PICT '####.##'
               READ
               IF C = 5
                  AFILL(V_DETALLE,SPACE(70))
                  DO PIDE_EXPRES
                  DO PIDE_DONDE
                  M_FACTU = .F.
               ENDIF
               DO PANT_ELEG
               IF APRUEBA(24,0,21)
                  RESTORE SCREEN FROM M_PANTA
                  @ 24,0 SAY SPACE(79)
                  DO M_CARTEL WITH 22,24,0,.T.,.F.,.T.
                  DO GRAB_ARCHI
                  IF M_COMPRO <> 'DEV'
                     IF M_COMPRO = 'REM'
                        M_CONDICIONES = SPACE(40)
                        COPIAS = 3
                     ELSE
                        COPIAS = 3
                     ENDIF
                     IF APRUEBA(24,0,49)
                        IF C = 5
                             DO IMPRNUEVO WITH .F.,.T.
                        ELSE
                             DO &RUTIMP WITH .F.,.T.
                        ENDIF
                     ENDIF
                  ENDIF
                  @ 24,0 SAY SPACE(79)
                  @ 11,2 CLEAR TO 17,78
                  TERMINO = .T.
                  RESTORE SCREEN FROM R_PANT
                  EXIT
               ELSE
                  RESTORE SCREEN FROM R_PANT
                  @ 19,0 CLEAR TO 23,79
                  @ 24,0 SAY SPACE(79)
                  LOOP
               ENDIF
            ENDIF
            IF M_ITEM < I
               DO M_CARTEL WITH 114,24,0,.T.,.F.,.T.
               ESPERAR(0)
               @ 24,0 SAY SPACE(79)
               RESTAR = V_TOTAL[M_ITEM]
            ENDIF
            IF LASTKEY() = 28
               IF M_ITEM < I
                  IF APRUEBA(24,0,23)
                     DO ANULA_IT
                     @ 11,1 CLEAR TO 17,78
                     DO MUESTRA
                     @ 24,0 SAY SPACE(79)
                     I = I - 1
                     LOOP
                  ENDIF
                  @ 24,0 SAY SPACE(79)
               ELSE
                  EXIT
               ENDIF
            ENDIF
            DO WHILE .T.
               DO M_CARTEL WITH 97,24,0,.T.,.F.,.T.
               @ 20,31 GET M_ARTI PICT '@!'
               READ
               IF LASTKEY() = 27
                    EXIT
               ENDIF
               IF AT('?',M_ARTI) <> 0
                    SAVE SCREEN TO M_LISART
                    M_ARTI = BUS_ARTI2(M_ARTI,'2')
                    RESTORE SCREEN FROM M_LISART
               ELSE
                    EXIT
               ENDIF
            ENDDO
            IF LASTKEY() = 27
                LOOP
            ENDIF
            SEEK M_ARTI
            IF FOUND()
               EXIT
            ELSE
               DO M_CARTEL WITH 15,24,0,.T.,.T.,.T.
               ESPERAR(0)
               @ 24,0 SAY SPACE(79)
            ENDIF
         ENDDO
         IF LASTKEY() = 27 .OR. M_ITEM = -1 .OR. TERMINO
            EXIT
         ENDIF
         IF LASTKEY() = 27
            EXIT
         ENDIF
         V_DESCR[M_ITEM] = DESCR
         @ 22,1 GET V_DESCR[M_ITEM] PICT '@!'
         M_CANT = 1
         M_LISTA = &ARCHIVO->QLIST
         @ 20,66 GET M_CANT PICT '####.###' VALID IIF(M_COMPRO = 'FAC' .OR. M_COMPRO = 'CON',VALCANT(M_CANT),M_CANT > 0)
         @ 21,14 GET M_LISTA PICT '#' VALID M_LISTA >= 1 .AND. M_LISTA <= 5
         READ
         IF LASTKEY() = 27
            LOOP
         ENDIF
         SELE 2
         DO CASE
         CASE M_LISTA = 1
            M_PRECIO = LISTA1
         CASE M_LISTA = 2
            M_PRECIO = LISTA2
         CASE M_LISTA = 3
            M_PRECIO = LISTA3
         CASE M_LISTA = 4
            M_PRECIO = LISTA4
         CASE M_LISTA = 5
            M_PRECIO = LISTA5
         ENDCASE
         @ 21,46 SAY IIF(ARTIC->TPRE = 'P',' $',' U$S')
         @ 21,31 GET M_PRECIO PICT '#########.###' VALID M_PRECIO >= 0
         READ
         IF LASTKEY() = 27
            LOOP
         ENDIF
         M_COTIZA = DOLAR->COTIZ
         IF ARTIC->TPRE = 'D'
            @ 21,55 SAY 'Cotizaci¢n :' GET M_COTIZA PICT '######.###' VALID M_COTIZA > 0
            READ
            IF !R5
               IF M_COMPRO = 'CON' .OR. M_COMPRO = 'NCB'
                  M_AUXI = (M_PRECIO * IVA->IVA /100) * M_COTIZA
                  M_PRECIO = (M_PRECIO * M_COTIZA) + M_AUXI
               ELSE
                  M_PRECIO = M_PRECIO * M_COTIZA
               ENDIF
            ELSE
               M_PRECIO = M_PRECIO * M_COTIZA
            ENDIF
            DOLAR = .T.
            M_PREDOLAR = M_COTIZA
         ENDIF
         IF LASTKEY() = 27
            LOOP
         ENDIF
         @ 22,1 SAY SPACE(78)
         M_DESART = ARTIC->DESCU
         @ 22,1 SAY 'Descuento :' GET M_DESART PICT '###.##'
         READ
         IF LASTKEY() = 27
             LOOP
         ENDIF
         IF APRUEBA(24,0,2)
            @ 24,0 SAY SPACE(79)
            @ 22,1 SAY SPACE(55)
            V_ARTI[M_ITEM] = M_ARTI
            V_DESCUEN[M_ITEM] = M_DESART
            V_CANTIDAD[M_ITEM] = M_CANT
            V_PRELIS[M_ITEM] = M_PRECIO
            IF V_DESCUEN[M_ITEM] = 0
               V_PRECIO[M_ITEM] = M_PRECIO
               V_TOTAL[M_ITEM] = M_PRECIO * M_CANT
            ELSE
               V_PRECIO[M_ITEM] = M_PRECIO - (M_PRECIO * M_DESART / 100)
               V_TOTAL[M_ITEM] =  M_PRECIO * M_CANT  -  M_PRECIO * M_CANT * M_DESART / 100
            ENDIF
            IF M_ITEM < I
               TOTALF = TOTALF - RESTAR
            ENDIF
            TOTALF = TOTALF + V_TOTAL[M_ITEM]
            DO MUESTRA
            IF M_ITEM = I
               I = I + 1
               IF I > 35
                  I = -1
               ENDIF
            ENDIF
            @ 24,0 SAY SPACE(79)
         ENDIF
         @ 21,2 CLEAR TO 22,77
         @ 24,0 SAY SPACE(79)
      ENDDO
      @ 19,0 CLEAR TO 23,79
      @ 11,2 CLEAR TO 17,78
      IF TERMINO
         EXIT
      ENDIF
   ENDDO
ENDDO
RETURN

PROCEDURE PIDE_DONDE
********************

@ 19,0 CLEAR TO 22,79
@ 19,0 TO 22,79

SELE 19
SEEK M_CLIENTE + '  1'
IF &ARCHIVO->CANTS <> 0
   FOR HA = 1 TO &ARCHIVO->CANTS
      DOM_ENT[HA] = DOMENT
      SKIP
   NEXT
ENDIF
@ 20,2 SAY 'Domicilio de Entrega : ' + IIF(&ARCHIVO->CANTS = 0,'Mismo Domicilio del Cliente','')
IF &ARCHIVO->CANTS <> 0
   SAVE SCREEN TO M_PANTA
   PEPE = VENTOPCION('DOMICILIO DE ENTREGA',DOM_ENT,10,30,20,.T.,.F.,C)
   RESTORE SCREEN FROM M_PANTA
   @ 20,26 SAY DOM_ENT[PEPE]
   SELE 19
   SEEK M_CLIENTE + STR(PEPE,3,0)
ELSE
   PEPE = 1
ENDIF
M_OC = SPACE(10)
*@ 24,0 SAY SPACE(79)
*@ 21,2 SAY 'Orden de Compra  (ENTER = Ninguna) : ' GET M_OC PICT '@!'
*READ

RETURN

PROCEDURE MUESTRA
*****************
*Muestra en Pantalla Detalle de Factura

W = 1
SELE 2

FOR L = 1 TO 35
   IF !EMPTY(V_ARTI[L])
      SEEK V_ARTI[L]
      IF V_DESCUEN[L] <> 0
         SET COLOR TO I
         @ W+10,2 SAY 'D'
         SET COLOR TO
      ELSE
         @ W+10,2 SAY ' '
      ENDIF
      @ W+10,6 SAY STR(L,2,0) + ' ' + TRANSFORM(V_DESCUEN[L],'##.##') + ' ' + V_ARTI[L] + ' ' + SUBSTR(V_DESCR[L],1,8) + ' ' + STR(V_CANTIDAD[L],10,3) + '      ' + STR(V_PRELIS[L],11,4) + '   ' + STR(V_TOTAL[L],11,4)
      W = W + 1
      IF W = 7
         DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
         ESPERAR(0)
         @ 11,2 CLEAR TO 17,78
         W = 1
      ENDIF
   ENDIF
NEXT
RETURN

PROCEDURE BLANQ_VEC
*******************
*Blanquea Vectores de ITEMS

PARAMETERS DONDE,M_PEDI,M_REMIAUX

FOR T = 1 TO 35
   V_ARTI[T] = IIF(DONDE,' ',SPACE(11))
   V_CANTIDAD[T] = 0
   V_PRECIO[T] = 0
   V_TOTAL[T] = 0
   V_DESCUEN[T]=0
   V_DESCR[T] = ''
   V_PRELIS[T]=0
   TOTALF = 0
NEXT

IF M_REMIAUX <> 0
      SELE 4
      USE COMPRO1 INDEX COMPRO1
      SEEK 'REM' + STR(M_REMIAUX,5,0)
      M_PAQUETES = PAQUETES
      M_LIOS = LIOS
      M_KILOS = KILOS
      M_FRASE = FRASE
      SELE 5
      USE DETALLE1 INDEX DETALLE1
      SEEK 'REM' + STR(M_REMIAUX,5,0)
      T = 1
      I = 1
      TOTALF = 0
      DO WHILE !EOF() .AND. TIPO = 'REM' .AND. NUMERO = M_REMIAUX
         V_ARTI[T] = ARTICULO
         V_CANTIDAD[T] = CANTIDAD
         V_PRECIO[T] = ROUND(PRECIO,3)
         V_TOTAL[T] = ROUND(PRECIO,3) * CANTIDAD
         V_DESCUEN[T]=DESCUENTO
         V_DESCR[T] = DESCR
         V_PRELIS[T]= ROUND(PRELIS,3)
         TOTALF = TOTALF + V_TOTAL[T]
         T = T + 1
         I = I + 1
         SKIP
      ENDDO
      DO MUESTRA
      AFILL(V_PORC,0)
      RETURN
ELSE
      M_PAQUETES = 0
      M_LIOS = 0
      M_KILOS = 0
      M_FRASE = CLIENTES->FRASE
      AFILL(V_PORC,0)
      STOR 0 TO M_COND1,M_COND2,M_COND3,M_COND4,M_COND5,M_PAQUETES,M_KILOS,M_LIOS
ENDIF

IF M_PEDI <> 0
     SELE 15
     SEEK STR(M_PEDI,5,0)
     T = 1
     I = 1
     TOTALF = 0
     DO WHILE !EOF() .AND. NUMERO = M_PEDI
        IF CANTIDAD - ENTREGADO > 0
            V_ARTI[T] = ARTICULO + SPACE(1)
            V_CANTIDAD[T] = CANTIDAD - ENTREGADO
            IF CLIENTES->INSCRIP <> 'M'
                   V_PRECIO[T] = PRECIO - (PRECIO * DESCU / 100)
                   M_PRE = V_PRECIO[T]
            ELSE
                   M_PRE = PRECIO - (PRECIO * DESCU / 100)
                   M_PRE = M_PRE + (M_PRE * IVA->IVA / 100)
                   V_PRECIO[T] = M_PRE
            ENDIF
            V_TOTAL[T] = V_PRECIO[T] * (CANTIDAD - ENTREGADO)
            V_DESCUEN[T]=DESCU
            TOTALF = TOTALF + V_TOTAL[T]
            V_DESCR[T] = DESCR
            IF CLIENTES->INSCRIP <> 'M'
                  V_PRELIS[T] = PRECIO
            ELSE
                  V_PRELIS[T] = PRECIO + (PRECIO * IVA->IVA / 100)
            ENDIF
            T = T + 1
            I = I + 1
        ENDIF
        SKIP
     ENDDO
     DO MUESTRA
ELSE
     FOR T = 1 TO 35
        V_ARTI[T] = IIF(DONDE,' ',SPACE(11))
        V_CANTIDAD[T] = 0
        V_PRECIO[T] = 0
        V_TOTAL[T] = 0
        V_DESCUEN[T]=0
        V_DESCR[T] = ''
        V_PRELIS[T] = 0
        TOTALF = 0
     NEXT
     IF !DONDE
        FOR T = 1 TO 35
           V_ARTI2[T] = SPACE(11)
           V_CANTI2[T] =0
           V_PRECIO2[T] = 0
           V_TOTAL2[T] = 0
           V_DESCUEN[T]=0
           V_PRELIS[T] = 0
           TOTALF = 0
        NEXT
     ENDIF
ENDIF
RETURN

PROCEDURE GRAB_ARCHI
********************
*Graba Archivos de Facturas y e Incrementa el Numero de Comprobante
*Facturas


*Comprobante
SELE 13
IF M_COMPRO = 'NCR'
   SEEK 'FAC'
ELSE
   SEEK M_COMPRO
ENDIF
M_NUMERO = NUMERO
IF RLOCK()
    REPLACE NUMERO WITH M_NUMERO + 1
    UNLOCK
ENDIF
R5 = .F.


SELE 11
USE CLIENTES INDEX CLIENTES
SEEK M_CLIENTE

SELE 4
USE COMPRO1 INDEX COMPRO1,COMPRO2
SET ORDER TO 1

IF RLOCK()
APPEND BLANK
IF M_COMPRO <> 'NCB'
     REPLACE TIPO WITH IIF(!CONTADO,M_COMPRO,'CDO')
ELSE
     REPLACE TIPO WITH 'NCR'
ENDIF
REPLACE NUMERO WITH M_NUMERO
REPLACE CLIENTE WITH M_CLIENTE
REPLACE TOTAL WITH TOTALF
REPLACE IVA WITH M_IVA
REPLACE REC_IVA WITH ADIC
REPLACE FECHA WITH M_FECH
REPLACE CAJERO WITH M_VENDEDOR
REPLACE ANULADA WITH .F.
REPLACE COTIZA WITH M_COTIZA
REPLACE CONCEPTO WITH ''
REPLACE O_C WITH M_OC
REPLACE FRASE WITH M_FRASE
REPLACE BONIF WITH M_BONIF
REPLACE NROREM WITH M_NROREM
REPLACE FACTURADO WITH M_FACTU
REPLACE FVENC WITH M_FECH + M_COND1
REPLACE CANCELADA WITH IIF(AT('CONTADO',ALLTRIM(M_CONDICIONES)) <> 0,.T.,.F.)
REPLACE ACTA WITH 0
REPLACE MR5 WITH IIF(R5,.T.,.F.)
REPLACE COMISION WITH .F.
REPLACE PROVI WITH M_PROVI
REPLACE PAQUETES WITH M_PAQUETES
REPLACE LIOS WITH M_LIOS
REPLACE KILOS WITH M_KILOS
REPLACE COND1 WITH M_COND1
REPLACE COND2 WITH M_COND2
REPLACE COND3 WITH M_COND3
REPLACE COND4 WITH M_COND4
REPLACE COND5 WITH M_COND5
REPLACE CONDICIONES WITH M_CONDICIONES
FOR I = 1 TO 15
      IF I < 10
         M_POR = 'PORC' + STR(I,1,0)
      ELSE
         M_POR = 'PORC' + STR(I,2,0)
      ENDIF
      REPLACE &M_POR WITH V_PORC[I]
NEXT
IF M_COMPRO = 'REM'
     FOR I = 1 TO 10
           M_AUX = 'VDETALLE' + ALLTRIM(STR(I,2,0))
           REPLACE &M_AUX WITH V_DETALLE[I]
     NEXT
     REPLACE EXPRESO WITH M_EXPRES
ENDIF
REPLACE DIREC WITH PEPE
UNLOCK
ENDIF

IF AT('CONTADO',ALLTRIM(M_CONDICIONES)) <> 0
         SELE 13
         SEEK 'RE2'
         M_NROREC = NUMERO
         IF RLOCK()
             REPLACE NUMERO WITH NUMERO + 1
             UNLOCK
         ENDIF
         SELE 4
         IF RLOCK()
             REPLACE RELAC WITH M_NROREC
             UNLOCK
         ENDIF
         IF RLOCK()
           APPE BLANK
           REPLACE TIPO WITH 'RE2'
           REPLACE NUMERO WITH M_NROREC
           REPLACE CLIENTE WITH M_CLIENTE
           REPLACE TOTAL WITH TOTALF + M_IVA + ADIC
           REPLACE FECHA WITH M_FECH
           REPLACE CAJERO WITH M_VENDEDOR
           UNLOCK
         ENDIF
ENDIF

SELE 5
USE DETALLE1 INDEX DETALLE1

FOR J= 1 TO 35
   IF !EMPTY(V_ARTI[J])
    IF RLOCK()
      APPEND BLANK
      IF M_COMPRO <> 'NCB'
           REPLACE TIPO WITH IIF(!CONTADO,M_COMPRO,'CDO')
      ELSE
           REPLACE TIPO WITH 'NCR'
      ENDIF
      REPLACE NUMERO WITH NUMCOMP
      REPLACE ARTICULO WITH V_ARTI[J]
      REPLACE CANTIDAD WITH V_CANTIDAD[J]
      REPLACE PRECIO WITH V_PRECIO[J]
      REPLACE FECHA WITH M_FECH
      REPLACE DESCUENTO WITH V_DESCUEN[J]
      REPLACE DESCR WITH V_DESCR[J]
      REPLACE PRELIS WITH V_PRELIS[J]
      UNLOCK
    ENDIF
   ENDIF
NEXT

IF M_REMIAU <> 0
     SELE 4
     SEEK 'REM' + STR(M_REMIAU,5,0)
     IF RLOCK()
         REPLACE FACTURADO WITH .T.
         UNLOCK
     ENDIF
ENDIF

IF M_PEDIDO <> 0
     FOR I = 1 TO 35
          SELE 15
          SEEK STR(M_PEDIDO,5,0)
          DO WHILE !EOF() .AND. NUMERO = M_PEDIDO
                IF ALLTRIM(ARTICULO) = ALLTRIM(V_ARTI[I])
                        IF CANTIDAD - ENTREGADO > 0
                          IF RLOCK()
                            REPLACE ENTREGADO WITH V_CANTIDAD[I] + ENTREGADO
                            UNLOCK
                          ENDIF
                          GO BOTTOM
                          SKIP
                          LOOP
                        ENDIF
                ENDIF
                SKIP
          ENDDO
     NEXT
     SELE 14
     M_PENDI = BUSCA_PENDI(M_PEDIDO,'14','15')
     IF RLOCK()
        REPLACE PENDIENTE WITH M_PENDI
        UNLOCK
     ENDIF
ENDIF

RETURN

PROCEDURE ANULA_IT
******************
*Anula del vector un ITEM cargado

J = 1
M = 1
DO WHILE .T.
   IF J > 35
      EXIT
   ENDIF
   IF J <> M_ITEM
      V_ARTI[M] = V_ARTI[J]
      V_CANTIDAD[M] =V_CANTIDAD[J]
      V_PRECIO[M]=V_PRECIO[J]
      V_TOTAL[M]=V_TOTAL[J]
      V_DESCUEN[M] = V_DESCUEN[J]
      V_PRELIS[M] = V_PRELIS[J]
      M = M + 1
      J = J + 1
   ELSE
      TOTALF = TOTALF - V_TOTAL[J]
      J = J + 1
   ENDIF
ENDDO
RETURN

PROCEDURE PANT_TOT
******************
*Pone Total de Factura en Pantalla

M_D1 = TOTALF * V_PORC[1] / 100
M_S1 = TOTALF - M_D1
M_D2 = M_S1 * V_PORC[2] / 100
M_S2 = M_S1 - M_D2
M_D3 = M_S2 * V_PORC[3] / 100
M_S3 = M_S2 - M_D3
M_BONIF = TOTALF - M_S3

IF M_COMPRO <> 'CON' .AND. M_COMPRO <> 'NCB'
      M_IVA = (TOTALF - M_BONIF) * IVA->IVA / 100
      ADIC = IIF(&ARCHIVO->INSCRIP='N',(TOTALF - M_BONIF) * IVA->ADIC /100,0)
      TOTNETO = TOTALF - M_BONIF + M_IVA + IIF(&ARCHIVO->INSCRIP = 'N',ADIC,0)
ELSE
      M_IVA = 0
      ADIC = 0
      TOTNETO = TOTALF - M_BONIF
ENDIF
SET COLOR TO W+
@ 10,0 CLEAR TO 13,79
@ 10,0 TO 13,79
IF R5
   M_POIVA = 0
ENDIF

@ 11,2 SAY 'S. Total =>' + TRANSFORM(TOTALF,'###,###.####')
@ 11,30 SAY 'Bonif=>' + TRANSFORM(M_BONIF,'###,###.####')
@ 11,55 SAY 'I.V.A.=>' + TRANSFORM(M_IVA,'###,###.####')
@ 12,2 SAY 'Adic. I.V.A.==>' + IIF(&ARCHIVO->INSCRIP = 'N',TRANSFORM(ADIC,'###,###.####'),' 0')
@ 12,30 SAY 'Total=>' + TRANSFORM(TOTNETO,'###,###.####')
SET COLOR TO
RETURN

FUNCTION VALCANT
****************
*Valida Cantidad Ingresada para Venta
SELE 2
PARAMETERS M_CANTI

PARA_COMP = 0
FOR GOL = 1 TO 35
   IF M_ARTI = V_ARTI[GOL]
      PARA_COMP = V_CANTIDAD[GOL] + PARA_COMP
   ENDIF
NEXT

M_AUX = STOCK
IF M_CANTI > 0 .AND. M_CANTI <= STOCK - PARA_COMP
   RETURN(.T.)
ELSE
   SELE 2
   IF M_CANTI > 0 .AND. M_CANTI - M_AUX  <= STOCK - PARA_COMP
      RETURN(.T.)
   ELSE
      DO M_CARTEL WITH 24,24,0,.T.,.T.,.T.
      ESPERAR(0)
      @ 24,0 SAY SPACE(79)
      RETURN(.T.)
   ENDIF
ENDIF

PROCEDURE RECIBO
****************
*Pide Datos para confeccion del recibo e imprime comprobante
*Declaracion del Vector donde se guardan los numeros de factura cobradas

DECLARE COMP_REC[10]
DECLARE DESCUENTO[10]
DECLARE FACTURA[10]
DECLARE IMPORTE[10]

FOR M = 1 TO 10
   COMP_REC[M] = ' '
   DESCUENTO[M] = 0
   FACTURA[M] = 0
   IMPORTE[M] = 0
NEXT

SELE 4
USE COMPRO1 INDEX COMPRO1,COMPRO2
SET ORDER TO 1

DECLARE COMPROBAN[7]
COMPROBAN[1] = 'FACTURA TIPO B'
COMPROBAN[2] = 'FACTURA TIPO A'
COMPROBAN[3] = 'NOTA DE DEBITO'
COMPROBAN[4] = 'NOTA DE CREDITO'
COMPROBAN[5] = 'AJUSTE DEUDOR'
COMPROBAN[6] = 'AJUSTE ACREEDOR'
COMPROBAN[7] = 'IMPRIMIR RECIBO'

@ 9,2 SAY 'ITEM FACTURA IMPORTE DESCUENTO | ITEM FACTURA IMPORTE DESCUENTO'
@ 11,2 CLEAR TO 17,78
@ 19,0 TO 23,79 DOUBLE
TOT_REC = 0
M_IMPCREDI = 0
M_DISTRI = 'N'
ITEM = 1
ELECTO = .T.
M_CONC1 = ''
M_CONC2 = ''
DO WHILE .T.
   IF  ELECTO
      M_COMP = 1
      ELECTO = .F.
   ENDIF
   @ 20,2 SAY 'C¢digo de Comprobante: '
   SAVE SCREEN TO M_PANTA
   M_COMP = VENTOPCION('CODIGO DE COMPROBANTE',COMPROBAN,15,30,22,.T.,.T.,M_COMP)
   IF LASTKEY() = 27
      RESTORE SCREEN FROM M_PANTA
      EXIT
   ENDIF
   RESTORE SCREEN FROM M_PANTA
   IF M_COMP = 7
      M_DISTRI = 'N'
      @ 21,2 SAY 'El Descuento Es Para Distribucion S/N : ' GET M_DISTRI PICT '@A' VALID M_DISTRI = 'S' .OR. M_DISTRI = 'N'
      READ
      M_IMPCREDI = 0
      FOR I = 1 TO 10
            M_IMPCREDI = M_IMPCREDI + DESCUENTO[I]
      NEXT
      IF CLIENTES->INSCRIP = 'S'
         M_AUXI = '1.' + STR(IVA->IVA,2,0)
      ELSE
         M_AUXI = '1.' + STR(IVA->IVA,2,0)
      ENDIF
      M_IMPCREDI = M_IMPCREDI / &M_AUXI
      IF CLIENTES->INSCRIP = 'S'
         M_ADIC = 0
         M_IVA = M_IMPCREDI * IVA->IVA / 100
      ELSE
        M_ADIC = M_IMPCREDI * IVA->ADIC / 100
        M_IVA = M_IMPCREDI * IVA->IVA / 100
      ENDIF
      TOT_REC = TOT_REC - M_IMPCREDI - M_ADIC - M_IVA
      DO MUES_REC
      SI_IMPRE = .F.
      IF APRUEBA(24,0,49)
         SI_IMPRE = .T.
      ENDIF
      @ 24,0 SAY SPACE(79)
      IF APRUEBA(24,0,21)
         @ 24,0 SAY SPACE(79)
         DO M_CARTEL WITH 22,24,0,.T.,.F.,.T.
         M_REGI = 0
         DO GRAB_REC
         @ 11,2 CLEAR TO 17,78
         @ 24,0 SAY SPACE(79)
         STOR 0 TO M_IMPESOS,M_IMPDOC,M_IMPDOL,M_COBI,M_VARIOS
         M_NRORECI = M_NUMERO
         IF APRUEBA(24,0,118)
              CLOSE ALL
              STOR 0 TO M_IMPESOS,M_IMPDOC,M_IMPDOL,M_COBI,M_VARIOS
              M_NUMCAJA = 0
              DO ABMCAJA WITH .T.,.F.,M_CLIENTE
              CLOSE ALL
              SELE 11
              USE CLIENTES INDEX CLIENTES
              SEEK M_CLIENTE
              SELE 4
              USE COMPRO1 INDEX COMPRO1,COMPRO2
              GO M_REGI
              REPLACE NUMCAJA WITH M_NUMCAJA
              SELE 25
              USE IVA
         ENDIF
         IF SI_IMPRE
            DO M_CARTEL WITH 10,24,0,.T.,.T.,.T.
            ESPERAR(0)
            IF LASTKEY() = 27
                 LOOP
            ENDIF
            DO IMP_RECI
         ENDIF
         EXIT
      ENDIF
      @ 24,0 SAY SPACE(79)
      @ 20,1 CLEAR TO 22,78
      LOOP
   ENDIF
   @ 20,26 SAY COMPROBAN[M_COMP]
   M_NUM = 0
   @ 20,50 SAY 'N£mero : ' GET M_NUM PICT '#####' VALID M_NUM > 0
   READ
   SELE 4
   IF M_COMP = 1
      COMP_REC[ITEM] = 'CDO'
   ELSE
      IF M_COMP = 2
         COMP_REC[ITEM] = 'FAC'
      ELSE
         IF M_COMP = 3
            COMP_REC[ITEM] = 'NDB'
         ELSE
            IF M_COMP = 4
               COMP_REC[ITEM] = 'NCR'
            ELSE
               IF M_COMP = 6
                  COMP_REC[ITEM] = 'AJD'
               ELSE
                  IF M_COMP = 7
                     COMP_REC[ITEM] = 'AJA'
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   SEEK COMP_REC[ITEM] + STR(M_NUM,5,0)
   IF !FOUND() .OR. CANCELADA
      DO M_CARTEL WITH 43,24,0,.T.,.T.,.T.
      ESPERAR(0)
      @ 24,0 SAY SPACE(79)
      LOOP
   ENDIF
   IF M_CLIENTE <> CLIENTE
          DO M_CARTEL WITH 69,24,0,.T.,.T.,.T.
          ESPERAR(0)
          @ 24,0 SAY SPACE(79)
          LOOP
   ENDIF
   M_DESCU = BONIF
   M_DES = 0
   M_IMPREC = TOTAL + IVA + REC_IVA - ACTA - M_DESCU
   @ 21,2 SAY 'Importe Adeudado: ' GET M_IMPREC PICT '#######.##' VALID M_IMPREC >= 0
   @ 21,50 SAY 'Descuento : ' GET M_DES PICT '#######.##' VALID M_DES >= 0
   READ
   IF LASTKEY() = 27
      LOOP
   ENDIF
   IF APRUEBA(24,0,2)
      @ 24,0 SAY SPACE(79)
      FACTURA[ITEM] = M_NUM
      IMPORTE[ITEM] = M_IMPREC
      DESCUENTO[ITEM] = M_DES
      DO MUES_REC
      TOT_REC = IIF(COMP_REC[ITEM] <> 'NCR'.AND. COMP_REC[ITEM] <> 'AJA',TOT_REC + M_IMPREC,TOT_REC - M_IMPREC)
      ITEM = ITEM + 1
      @ 20,1 CLEAR TO 22,78
   ENDIF
   @ 24,0 SAY SPACE(79)
ENDDO
@ 11,2 CLEAR TO 17,78
@ 19,0 CLEAR TO 24,79
RETURN

PROCEDURE MUES_REC
******************
*Muestra Datos del Recibo por Pantalla
F= 11
CO = 2
FOR Q = 1 TO 10
   IF FACTURA[Q] <> 0
      @ F,CO SAY  COMP_REC[Q] + ' ' + STR(FACTURA[Q],5,0) + ' '  +  STR(IMPORTE[Q],8,2) + ' ' + STR(DESCUENTO[Q],5,2)
      F = F + 1
      IF Q = 5
         F = 11
         CO = 40
      ENDIF
   ENDIF
NEXT
RETURN

PROCEDURE GRAB_REC
******************
*Graba recibo
SELE 4

APPEND BLANK
REPLACE TIPO WITH M_COMPRO
REPLACE NUMERO WITH M_NUMERO
REPLACE CLIENTE WITH M_CLIENTE
REPLACE TOTAL WITH TOT_REC
REPLACE IVA WITH IIF(M_COMPRO <> 'NDB' .AND. M_COMPRO <> 'NCR',0,M_IVA)
REPLACE REC_IVA WITH IIF(M_COMPRO <> 'NDB' .AND. M_COMPRO <> 'NCR',0,ADIC)
REPLACE FECHA WITH M_FECH
REPLACE CAJERO WITH M_VENDEDOR
REPLACE ANULADA WITH .F.
REPLACE CANCELADA WITH .F.
REPLACE COTIZA WITH DOLAR->COTIZ
REPLACE ACTA WITH 0
REPLACE CONCEPTO WITH M_CONC1 + M_CONC2
REPLACE O_C WITH ''
REPLACE FVENC WITH M_FECH
REPLACE DISTRI WITH IIF(M_COMPRO = 'NCR' .OR. M_COMPRO = 'NDB',M_DISTRI,'')
REPLACE PROVI WITH CLIENTES->TIPO_CLI
M_REGI = RECNO()
IF M_COMPRO = 'REC'
     IF M_IMPCREDI <> 0
            APPE BLANK
            REPLACE TIPO WITH 'NC2'
            REPLACE NUMERO WITH M_NUMERO
            REPLACE CLIENTE WITH M_CLIENTE
            REPLACE FECHA WITH M_FECH
            REPLACE TOTAL WITH M_IMPCREDI
            REPLACE IVA WITH M_IVA
            REPLACE REC_IVA WITH M_ADIC
            REPLACE CAJERO WITH M_VENDEDOR
            REPLACE DISTRI WITH M_DISTRI
            REPLACE PROVI WITH CLIENTES->TIPO_CLI
     ENDIF
ENDIF

*Cancela Facturas o Notas de Debito o Nota de Credito
SELE 4

SELE 29
USE CANCELAR INDEX CANCELAR

SELE 4
IF M_COMPRO = 'REC'
   FOR A = 1 TO 10
      IF FACTURA[A] > 0
         SELE 4
         SEEK COMP_REC[A] + STR(FACTURA[A],5,0)
         M_DESCU = BONIF
         IF ROUND(IMPORTE[A],2) >= ROUND((TOTAL - ACTA + IVA + REC_IVA - M_DESCU),2)
            REPLACE CANCELADA WITH .T.
         ELSE
            REPLACE ACTA WITH IMPORTE[A] + ACTA
         ENDIF
         IF CLIENTES->INSCRIP = 'S'
            M_AUXI = '1.' + STR(IVA->IVA,2,0)
         ELSE
            M_AUXI = '1.' + STR(IVA->IVA + IVA->ADIC,2,0)
         ENDIF
         DESCUENTO[A] = DESCUENTO[A] / &M_AUXI
         REPLACE DESPAGO WITH DESCUENTO[A] + DESPAGO
         SELE 29
         APPEND BLANK
         REPLACE NUMERO WITH M_NUMERO
         REPLACE NROFACTU WITH FACTURA[A]
         REPLACE IMPORTE WITH IMPORTE[A]
      ENDIF
   NEXT
ENDIF

SELE 29
USE

*Contadores

SELE 13
IF M_COMPRO = 'NDB'
     SEEK 'FAC'
ELSE
     SEEK M_COMPRO
ENDIF
REPLACE NUMERO WITH NUMERO + 1
RETURN


PROCEDURE IMP_RECI
******************
SET DEVICE TO PRINT
MLINEAS = 1
FOR Q = 1 TO 1
   @ MLINEAS + 7,50 SAY DTOC(M_FECH)
   @ MLINEAS + 16,10 SAY CLIENTES->NOMBRE + ' (' + ALLTRIM(CLIENTES->COD_CLI) + ')'
   @ MLINEAS + 17,10 SAY CLIENTES->DIRECC
   @ MLINEAS + 18,10 SAY CLIENTES->LOC
   IF CLIENTES->INSCRIP <> 'M'
          @ MLINEAS + 21,15 SAY IIF(CLIENTES->INSCRIP = 'S','Responsable Inscripto','Responsable No Inscripto')
   ELSE
          @ MLINEAS + 21,15 SAY 'Responsable Monotributo'
   ENDIF
   @ MLINEAS + 21,60 SAY CLIENTES->CUIT
   @ PROW(),PCOL() SAY CHR(27) + CHR(48)
   MLINEAS = MLINEAS + 27
   I = 1
   M_TOTAL = 0
   DO WHILE I <= 5
      DO CASE
         CASE I = 1
             M_IMPO = M_IMPESOS
         CASE I = 2
             M_IMPO = M_IMPDOC
         CASE I = 3
             M_IMPO = M_COBI
         CASE I = 4
             M_IMPO = M_IMPDOL
         CASE I = 5
             M_IMPO = M_VARIOS
      ENDCASE
      @ MLINEAS,25 SAY TRANSFORM(M_IMPO,'###,###.##')
      IF FACTURA[I] <> 0
         @ MLINEAS,45 SAY COMP_REC[I] + '     ' + STR(FACTURA[I],5,0) + '   '  +  STR(IMPORTE[I],10,2)
         IF COMP_REC[I] <> 'NCR'
             M_TOTAL = M_TOTAL + IMPORTE[I]
         ELSE
             M_TOTAL = M_TOTAL - IMPORTE[I]
         ENDIF
      ENDIF
      MLINEAS = MLINEAS + 2
      I = I + 1
   ENDDO
   IF CLIENTES->INSCRIP = 'S'
      M_ADIC = 0
      M_IVA = M_IMPCREDI * IVA->IVA / 100
   ELSE
     M_ADIC = 0
     M_IVA = M_IMPCREDI * IVA->IVA / 100
   ENDIF
   M_LETRAS = CONVER_LE(TOT_REC)
   @ MLINEAS + 1,25 SAY TRANSFORM(TOT_REC,'###,###.##')
   @ MLINEAS + 1,68 SAY TRANSFORM(M_TOTAL,'###,###.##')
   @ MLINEAS + 3,5 SAY SUBSTR(M_LETRAS,1,25)
   @ MLINEAS + 3,68 SAY TRANSFORM(M_IMPCREDI,'###,###.##')
   @ MLINEAS + 4,5 SAY SUBSTR(M_LETRAS,26,25)
   @ MLINEAS + 5,5 SAY SUBSTR(M_LETRAS,51,25)
   @ MLINEAS + 5,68 SAY TRANSFORM(M_IVA,'###,###.##')
   @ MLINEAS + 7,68 SAY TRANSFORM(M_ADIC,'###,###.##')
   @ MLINEAS + 9,68 SAY TRANSFORM(TOT_REC,'###,###.##')
   @ PROW(),PCOL() SAY CHR(27) + CHR(50)
   EJECT
NEXT
SET DEVICE TO SCREEN
RETURN

PROCEDURE NOTA_DEB
******************
*Pide Datos para confeccion de nota de debito y/o credito
*Declaracion del Vector donde se guardan los numeros de factura cobradas

DECLARE FACTURA[10]
DECLARE COMP_REC[10]
DECLARE IMPORTE[10]
DECLARE DESCUENTO[10]

FOR M = 1 TO 10
   IMPORTE[M] = 0
   DESCUENTO[M] = 0
   FACTURA[M] = 0
   COMP_REC[M] = ' '
NEXT

DECLARE COMPROBAN[3]
COMPROBAN[1] = 'CONTADO'
COMPROBAN[2] = 'FACTURA'
COMPROBAN[3] = 'IMPRIMIR COMPROBANTE'

SELE 4
USE COMPRO1 INDEX COMPRO1,COMPRO2
SET ORDER TO 1

@ 9,2 SAY 'ITEM      FACTURA       IMPORTE   |   ITEM       FACTURA       IMPORTE'
@ 11,2 CLEAR TO 17,78
@ 19,0 TO 23,79 DOUBLE
TOT_REC = 0
TOTALF = 0
M_IVA = 0
ADIC = 0
TOTNETO = 0
ITEM = 1
ELECTO = .T.
PEPE = 1
DO WHILE .T.
   IF  ELECTO
      M_COMP = 1
      ELECTO = .F.
   ENDIF
   @ 20,2 SAY 'C¢digo de Comprobante: '
   SAVE SCREEN TO M_PANTA
   M_COMP = VENTOPCION('CODIGO DE COMPROBANTE',COMPROBAN,17,30,21,.T.,.T.,M_COMP)
   IF LASTKEY() = 27
      RESTORE SCREEN FROM M_PANTA
      EXIT
   ENDIF
   RESTORE SCREEN FROM M_PANTA
   IF M_COMP = 3
      DO MUES_REC
      @ 18,0 CLEAR TO 21,78
      @ 18,0 TO 23,79 DOUBLE
      M_CONC1 = '                                                   '
      M_CONC2 = '                ' + SPACE(43)
      M_DISTRI = 'S'
      @ 19,1 SAY 'Es Para Distribucion S/N : ' GET M_DISTRI PICT 'A' VALID M_DISTRI = 'S' .OR. M_DISTRI = 'N'
      @ 20,1 SAY 'Observaciones: ' GET M_CONC1 PICT '@!'
      @ 21,1 SAY '               ' GET M_CONC2 PICT '@!'
      READ
      DO PANT_TOT
      IF APRUEBA(24,0,21)
         @ 24,0 SAY SPACE(79)
         DO M_CARTEL WITH 22,24,0,.T.,.F.,.T.
         COPIAS = 3
         M_NROREM = SPACE(10)
         MENSAJE = .F.
         IF APRUEBA(24,0,49)
            DO &RUTIMP WITH .F.,.T.
         ENDIF
         DO GRAB_REC
         @ 11,2 CLEAR TO 17,78
         @ 24,0 SAY SPACE(79)
         EXIT
      ELSE
         @ 20,1 CLEAR TO 21,78
         @ 24,0 SAY SPACE(79)
         LOOP
      ENDIF
   ENDIF
   @ 20,26 SAY COMPROBAN[M_COMP]
   M_NUM = 0
   @ 20,50 SAY 'N£mero : ' GET M_NUM PICT '#####' VALID M_NUM > 0
   READ
   IF !R5
      SELE 4
   ELSE
      SELE 7
   ENDIF
   IF M_COMP = 1
      COMP_REC[ITEM] = 'CDO'
   ELSE
      COMP_REC[ITEM] = 'FAC'
   ENDIF
   SEEK COMP_REC[ITEM] + STR(M_NUM,5,0)
   IF !FOUND()
      DO M_CARTEL WITH 43,24,0,.T.,.T.,.T.
      ESPERAR(0)
      @ 24,0 SAY SPACE(79)
      LOOP
   ENDIF
   M_IMPREC = 0
   @ 21,2 SAY 'Importe Factura: ' + STR(TOTAL + IVA + REC_IVA-BONIF,12,2)
   @ 21,50 SAY IIF(C = 3,'Debito: ','Credito: ') GET M_IMPREC PICT '##########.##'
   READ
   IF LASTKEY() = 27
      LOOP
   ENDIF
   IF APRUEBA(24,0,2)
      @ 24,0 SAY SPACE(79)
      FACTURA[ITEM] = M_NUM
      IMPORTE[ITEM] = M_IMPREC
      DO MUES_REC
      TOT_REC = TOT_REC + M_IMPREC
      TOTALF = TOTALF + M_IMPREC
      ITEM = ITEM + 1
      @ 20,1 CLEAR TO 21,78
   ENDIF
   @ 24,0 SAY SPACE(79)
ENDDO
@ 11,2 CLEAR TO 17,78
@ 19,0 CLEAR TO 24,79
RETURN

PROCEDURE PANT_ELEG
*******************
*Displaya en Pantalla Opciones de Impresion Elegidas

SAVE SCREEN TO M_PANTA
@ 3,3 CLEAR TO 9,30
@ 3,3 TO 9,30 DOUBLE
@ 4,4 SAY 'Ord. Comp.:' + M_OC
@ 5,4 SAY 'Remito    :' + IIF(REMITO,'S','N')
@ 6,4 SAY 'Mensaje   :' + IIF(MENSAJE,'S','N')
@ 7,4 SAY 'Expreso   :' + IIF(EMPTY(ALLTRIM(M_EXPRES)),'Ninguno',SUBSTR(EXPRESO->NOMBRE,1,10))
RETURN


FUNCTION  PIDE_DESCU
********  **********
*Pide % de Bonificacion. Debe Estar declarada V_DESCU.

SAVE SCREEN TO M_PANTA44
DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
@ 15,0 CLEAR TO 23,79
@ 15,0 TO 23,79
SET COLOR TO W+
@ 16,30 SAY 'CONDICIONES DE PAGO'
SET COLOR TO
SELE 11
M_COND1 = COND1
M_COND2 = COND2
M_COND3 = COND3
M_COND4 = COND4
M_COND5 = COND5
M_CONDICIONES = SPACE(40)
FOR XI = 1 TO 15
    IF XI < 10
        M_PORC = 'PORC' + STR(XI,1,0)
    ELSE
        M_PORC = 'PORC' + STR(XI,2,0)
    ENDIF
    V_PORC[XI] = &M_PORC
NEXT

@ 17,2 SAY 'Dias  : ' GET M_COND1 PICT '###'
@ 17,40 SAY '% Bonif : '
@ 17,50 GET V_PORC[1] PICT '###.##'
@ 17,58 GET V_PORC[2] PICT '###.##'
@ 17,66 GET V_PORC[3] PICT '###.##'

@ 18,2 SAY 'Dias  : ' GET M_COND2 PICT '###'
@ 18,40 SAY '% Bonif : '
@ 18,50 GET V_PORC[4] PICT '###.##'
@ 18,58 GET V_PORC[5] PICT '###.##'
@ 18,66 GET V_PORC[6] PICT '###.##'

@ 19,2 SAY 'Dias  : ' GET M_COND3 PICT '###'
@ 19,40 SAY '% Bonif : '
@ 19,50 GET V_PORC[7] PICT '###.##'
@ 19,58 GET V_PORC[8] PICT '###.##'
@ 19,66 GET V_PORC[9] PICT '###.##'

@ 20,2 SAY 'Dias  : ' GET M_COND4 PICT '###'
@ 20,40 SAY '% Bonif : '
@ 20,50 GET V_PORC[10] PICT '###.##'
@ 20,58 GET V_PORC[11] PICT '###.##'
@ 20,66 GET V_PORC[12] PICT '###.##'

@ 21,2 SAY 'Dias  : ' GET M_COND5 PICT '###'
@ 21,40 SAY '% Bonif : '
@ 21,50 GET V_PORC[13] PICT '###.##'
@ 21,58 GET V_PORC[14] PICT '###.##'
@ 21,66 GET V_PORC[15] PICT '###.##'
@ 22,2 SAY 'Contado o Ctacte  : ' GET M_CONDICIONES PICT '@!'
READ
RESTORE SCREEN FROM M_PANTA44
RETURN

PROCEDURE IMPRIME2
******************
*Imprime Comprobante por Impresora
PARAMETERS M_SINUM,M_COPI

FRASE1= 'Equivale a U$S'
FRASE2= 'Base Dolar.'
FRASE3= 'El Valor en Pesos se Ajustara por N/D o N/C'
FRASE4= 'al momento de hacerse efectivo los valores.'
FRASE5= ''

SET DEVICE TO PRINT
@ PROW(),PCOL() SAY CHR(27) + CHR(120) + '0'
@ PROW(),PCOL() SAY CHR(18)
@ PROW(),PCOL() SAY CHR(27) + CHR(50)
MLINEAS = 0
IF M_COPI
    COPIAS = 1
ELSE
    COPIAS = M_COPIAS
ENDIF
FOR Q = 1 TO COPIAS
   IF M_COMPRO = 'FAC' .OR. M_COMPRO = 'CON'
      @ MLINEAS + 8,45 SAY 'FACTURA' + IIF(M_SINUM,STR(M_NUMERO,5,0),'')
   ELSE
      IF M_COMPRO = 'REM'
           @ MLINEAS + 8,45 SAY IIF(M_SINUM,'REMITO ' + STR(M_NUMERO,5,0),'')
      ELSE
          IF M_COMPRO = 'NDB'
              @ MLINEAS + 8,45 SAY 'N.DEBITO' + IIF(M_SINUM,STR(M_NUMERO,5,0),'')
          ELSE
              @ MLINEAS + 8,45 SAY 'N.CREDITO' + IIF(M_SINUM,STR(M_NUMERO,5,0),'')
          ENDIF
      ENDIF
   ENDIF
   @ MLINEAS + 9,45 SAY DTOC(M_FECH)
   @ MLINEAS + 16,3 SAY 'Sres.:  ' + CLIENTES->NOMBRE
   IF PEPE = 1
       @ MLINEAS + 17,11 SAY CLIENTES->DIRECC
   ELSE
       @ MLINEAS + 17,11 SAY DOMICILI->DOMENT
   ENDIF
   IF PEPE = 1
       @ MLINEAS + 18,1 SAY '          ' + '(' + STR(&ARCHIVO->CP,4,0) + ') ' + &ARCHIVO->LOC + ' ' + CHR(15) + PROVI->NOMBRE + CHR(18)
   ELSE
       @ MLINEAS + 18,1 SAY '          ' + '(' + STR(&ARCHI2->CDOMENT,4,0) + ') ' + &ARCHI2->SUCLOC + ' ' + CHR(15) + PROVI->NOMBRE + CHR(18)
   ENDIF
   IF CLIENTES->INSCRIP <> 'M'
         @ MLINEAS + 19,11 SAY IIF(CLIENTES->INSCRIP='S','Resp.Inscripto','No Inscripto')
   ELSE
         @ MLINEAS + 19,11 SAY 'Responsable Monotributo'
   ENDIF
   @ MLINEAS + 19,50 SAY CLIENTES->CUIT
   @ MLINEAS + 20,1 SAY REPLICATE('_',79)
   IF M_COMPRO = 'FAC'
      @ MLINEAS + 21,2 SAY 'REM Nro :'+ M_NROREM
   ENDIF
   @ MLINEAS + 21,30 SAY 'Paq: ' + STR(M_PAQUETES,3,0)
   @ MLINEAS + 21,45 SAY 'Lios : ' + STR(M_LIOS,3,0)
   @ MLINEAS + 21,60 SAY 'Kg : ' + STR(M_KILOS,6,2)
   IF M_COMPRO <> 'REM'
      @ MLINEAS + 22,1 SAY 'Condiciones : ' + M_CONDICIONES
   ENDIF
   @ MLINEAS + 23,1 SAY 'Cantidad        D E S C R I P C I O N             P.x uno   Bon.       SubTotal'
   @ MLINEAS + 24,1 SAY REPLICATE('-',79)
   MLINEAS =MLINEAS + 25
   M_LIN2 = MLINEAS + 50
   SUBT2 = TOTALF - M_BONIF
   @ PROW(),PCOL() SAY CHR(27) + CHR(48)
   IF M_COMPRO = 'FAC' .OR. M_COMPRO = 'REM' .OR. M_COMPRO = 'NCR' .OR. M_COMPRO = 'CON' .OR. M_COMPRO = 'CDO' .OR. M_COMPRO = 'NCB'
       FOR I = 1 TO 35
          IF !EMPTY(V_ARTI[I])
             SELE 2
             SEEK V_ARTI[I]
             @ MLINEAS+1,1 SAY STR(V_CANTIDAD[I],8,3) + '          ' + CHR(15)+V_DESCR[I]+CHR(18)+' '+IIF(C<>5,STR(V_PRELIS[I],8,3)+IIF(V_DESCUEN[I]=0,'         ',' ' + STR(V_DESCUEN[I],5,2)+SPACE(3)) +STR(V_PRECIO[I]*V_CANTIDAD[I],11,3),' ')
             MLINEAS = MLINEAS + 1
          ENDIF
       NEXT
   ELSE
       I = 1
       DO WHILE I <= 10
          IF FACTURA[I] <> 0
             @ MLINEAS+1,5 SAY COMP_REC[I] + '       ' + STR(FACTURA[I],5,0) + '      '  +  STR(IMPORTE[I],10,2) + '     ' + IIF(FACTURA[I+1] <> 0,COMP_REC[I+1] + '           ' + STR(FACTURA[I+1],5,0) + '         '  +  STR(IMPORTE[I+1],10,2),' ')
             MLINEAS = MLINEAS + 1
          ENDIF
          I = I + 2
       ENDDO
       @ MLINEAS + 2,5 SAY M_CONC1
       @ MLINEAS + 3,5 SAY M_CONC2
   ENDIF
   IF C <> 5
      MLINEAS = M_LIN2
      IF MENSAJE
          @ MLINEAS - 2,1 SAY 'Equivale a U$S : ' + TRANSFORM(TOTNETO/M_COTIZA,'###,###.####') + ' Base Dolar : ' + STR(M_COTIZA,10,3)
      ENDIF
      @ MLINEAS-1,0 SAY REPLICATE('-',80)
      IF M_COMPRO = 'FAC' .OR. M_COMPRO = 'NDB' .OR. M_COMPRO = 'NCR' .OR. M_COMPRO = 'CON' .OR. M_COMPRO = 'NCB'
         IF M_COMPRO <> 'CON'
              @ MLINEAS,48 SAY 'Subtotal             ' + TRANSFORM(TOTALF,'###,###.##')
         ENDIF
         @ MLINEAS,5 SAY 'CONDICIONES DE PAGO'
         @ MLINEAS + 1,3 SAY M_FRASE
         @ MLINEAS + 1,48 SAY 'Impuesto'
         IF V_PORC[1] <> 0
             @ MLINEAS + 2,1 SAY STR(M_COND1,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND1) + ' NETO'
         ENDIF
         IF M_BONIF <> 0
            @ MLINEAS + 2,48 SAY 'Des% ' + IIF(V_PORC[1]<>0,STR(V_PORC[1],5,2),'') + IIF(V_PORC[2]<>0,'+' + STR(V_PORC[2],5,2),'') + IIF(V_PORC[3]<>0,'+' + STR(V_PORC[3],5,2),'')
            @ MLINEAS + 2,69 SAY TRANSFORM(M_BONIF,'###,###.##')
         ENDIF
         IF M_COND2 <> 0
            @ MLINEAS + 3,1 SAY STR(M_COND2,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND2) + ' ' + IIF(V_PORC[4]<>0,STR(V_PORC[4],5,2)+'%','NETO') + IIF(V_PORC[5]<>0,'+'+STR(V_PORC[5],5,2)+'%','') + IIF(V_PORC[6]<>0,'+'+STR(V_PORC[6],5,2)+'%','')
         ENDIF
         IF M_COMPRO <> 'CON' .AND. M_COMPRO <> 'NCB'
               @ MLINEAS + 3,48 SAY 'Subtotal             ' + TRANSFORM(SUBT2,'###,###.##')
         ENDIF
         IF M_COND3 <> 0
            @ MLINEAS + 4,1 SAY STR(M_COND3,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND3) + ' ' + IIF(V_PORC[7]<>0,STR(V_PORC[7],5,2)+'%','NETO') + IIF(V_PORC[8]<>0,'+'+STR(V_PORC[8],5,2)+'%','') + IIF(V_PORC[9]<>0,'+'+STR(V_PORC[9],5,2)+'%','')
         ENDIF
         IF M_COMPRO <> 'CON' .AND. M_COMPRO <> 'NCB'
              @ MLINEAS + 4,48 SAY 'Iva  ' + STR(IVA->IVA,2,0) + '             ' + TRANSFORM(M_IVA,'####,###.##')
         ENDIF
         IF M_COND4 <> 0
         @ MLINEAS + 5,1 SAY STR(M_COND4,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND4) + ' ' + IIF(V_PORC[10]<>0,STR(V_PORC[10],5,2)+'%','NETO') + IIF(V_PORC[11]<>0,'+'+STR(V_PORC[11],5,2)+'%','') + IIF(V_PORC[12]<>0,'+'+STR(V_PORC[12],5,2)+'%','')
         ENDIF
         IF M_COMPRO <> 'CON' .AND. M_COMPRO <> 'NCB'
              @ MLINEAS + 5,48 SAY 'Adic ' + IIF(&ARCHIVO->INSCRIP = 'N', STR(IVA->ADIC,2,0) + '             ' + TRANSFORM(ADIC,'####,###.##'),'')
         ENDIF
         IF M_COND5 <> 0
            @ MLINEAS + 6,1 SAY STR(M_COND5,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND5) + ' NETO'
         ENDIF
         @ MLINEAS + 6,48 SAY 'TOTAL                ' + TRANSFORM(TOTNETO,'###,###.##')
      ENDIF
   ELSE
      MLINEAS = M_LIN2 - 10
      FOR LK = 1 TO 10
          @ MLINEAS,50 SAY CHR(15) + CHR(27) + CHR(71) + ALLTRIM(V_DETALLE[LK]) + CHR(27) + CHR(72) + CHR(18)
          MLINEAS = MLINEAS + 1
      NEXT
      @ MLINEAS + 1,50 SAY IIF(!EMPTY(ALLTRIM(M_EXPRES)),CHR(15) + CHR(27) + CHR(71) + IIF(M_ASEGURA=0,'VALOR ASEGURADO: ' + STR(TOTNETO,12,2),'VALOR ASEGURADO: ' + STR(M_ASEGURA,10,2)) + CHR(27) + CHR(72),'')
      @ MLINEAS + 5,85 SAY IIF(!EMPTY(ALLTRIM(M_EXPRES)),'DESPACHAR POR EXPRESO : ','')
      @ MLINEAS + 6,85 SAY IIF(!EMPTY(ALLTRIM(M_EXPRES)),TRIM(EXPRESO->NOMBRE) + ' --  ' + EXPRESO->DIREC,'')
      @ MLINEAS + 7,85 SAY IIF(!EMPTY(ALLTRIM(M_EXPRES)),'CUIT : ' + EXPRESO->CUIT,'') + CHR(18)
   ENDIF
   MLINEAS = MLINEAS + 12
   @ PROW(),PCOL() SAY CHR(27) + CHR(50)
NEXT
EJECT
SET DEVICE TO SCREEN
RETURN

PROCEDURE PIDE_EXPRES
*********************
*Pide datos del expreso y remitos
DECLARE V_EXPRESO[21]
DECLARE V_CODEXP[21]
FOR J = 1 TO 20
    V_EXPRESO[J] = SPACE(15)
    V_CODEXP[J] = SPACE(10)
NEXT
V_EXPRESO[21] = 'OTRO'

SELE 21
M_A=''
AS = 1
FOR J = 1 TO 20
    IF SUBSTR(CLIENTES->EXPRES,J,1) <> ' '
          M_A = M_A + SUBSTR(CLIENTES->EXPRES,J,1)
    ELSE
          M_A = M_A + SPACE(10 - LEN(M_A))
          SEEK M_A
          IF FOUND()
             V_EXPRESO[AS] = NOMBRE
             V_CODEXP[AS] = NUMERO
          ELSE
             V_EXPRESO[AS] = 'NINGUNO'
          ENDIF
          AS = AS + 1
          M_A = ''
    ENDIF
NEXT

SAVE SCREEN TO M_PANTA20
M_EXPR = VENTOPCION('EXPRESO',V_EXPRESO,16,30,20,.T.,.F.,1)
RESTORE SCREEN FROM M_PANTA20
IF ALLTRIM(V_EXPRESO[M_EXPR]) = 'NINGUNO'
    M_EXPRES = SPACE(10)
    RETURN
ENDIF

DO WHILE .T.
   SELE 21
   IF ALLTRIM(V_EXPRESO[M_EXPR]) = 'OTRO'
        M_EXPRES = SPACE(10)
        @ 22,2 SAY 'Cod.de Expreso - (ENTER = NINGUNO) : ' GET M_EXPRES PICT '@!'
        READ
        IF EMPTY(ALLTRIM(M_EXPRES))
           M_COPREMI = 1
           RETURN
        ENDIF
        SEEK M_EXPRES
        IF FOUND()
           EXIT
        ENDIF
    ELSE
        @ 22,2 SAY 'Expreso : ' + SUBSTR(V_EXPRESO[M_EXPR],1,23)
        M_EXPRES = V_CODEXP[M_EXPR]
        EXIT
    ENDIF
ENDDO
SEEK M_EXPRES
M_COPREMI = 1
SAVE SCREEN TO M_PANTA39
CLEAR
DO TITULO
@ 1,0 TO 23,79 DOUBLE
SET COLOR TO I
@ 3,30 SAY 'DETALLE DE BULTOS DE MERCADERIA'
SET COLOR TO
@ 5,1 TO 5,78
M_ASEGURA = 0
AFILL(V_DETALLE,SPACE(50))
V_DETALLE[1] = 'PAQUETES: ' + STR(M_PAQUETES,5,0) + SPACE(35)
V_DETALLE[2] = 'LIOS    : ' + STR(M_LIOS,5,0) + SPACE(35)
V_DETALLE[8] = 'KILOS   : ' + STR(M_KILOS,8,2) + SPACE(35)
@ 6,1 GET V_DETALLE[1]
@ 7,1 GET V_DETALLE[2]
@ 8,1 GET V_DETALLE[3]
@ 9,1 GET V_DETALLE[4]
@ 10,1 GET V_DETALLE[5]
@ 11,1 GET V_DETALLE[6]
@ 12,1 GET V_DETALLE[7]
@ 13,1 GET V_DETALLE[8]
@ 14,1 GET V_DETALLE[9]
@ 15,1 GET V_DETALLE[10]
@ 16,1 SAY 'Valor Asegurado: ' get m_asegura pict '######.##'
READ
RESTORE SCREEN FROM M_PANTA39
RETURN


PROCEDURE LIS_REMI
******************
*Lista Remitos Pendientes de Facturacion

SELE 4
SEEK 'REM'
LINEAS = 70
PRIMERA = .T.
SAVE SCREEN TO M_PANTA45
DO WHILE !EOF() .AND. TIPO = 'REM'
       IF LINEAS > 20
            DO ENC_LREMI
       ENDIF
       IF !FACTURADO
           SELE 11
           SEEK COMPRO1->CLIENTE
           SELE 4
           @ LINEAS,1 SAY STR(NUMERO,5,0) + ' ' + CLIENTES->NOMBRE
           LINEAS = LINEAS + 1
       ENDIF
       SKIP
ENDDO
DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
ESPERAR(0)
RESTORE SCREEN FROM M_PANTA45
RETURN


PROCEDURE ENC_LREMI
*******************
IF PRIMERA
   CLEAR
   PRIMERA = .F.
ELSE
   DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
   ESPERAR(0)
   CLEAR
ENDIF
LINEAS = 1
SET COLOR TO I
@ LINEAS,25 SAY 'REMITOS PENDIENTES DE FACTURACION'
SET COLOR TO
@ LINEAS + 1,1 SAY REPLICATE('=',79)
@ LINEAS + 2,1 SAY 'NUMERO      CLIENTE'
@ LINEAS + 3,1 SAY REPLICATE('=',79)
LINEAS = 5
RETURN

FUNCTION BUSCA_PENDI
********************
*Busca Si un Pedido esta pendiente de entrega
PARAMETERS M_P,M_SELE1,M_SELE2

SELE &M_SELE1
IF PENDIENTE
   RETURN(.T.)
ELSE
   SELE &M_SELE2
   SEEK STR(M_P,5,0)
   TODO = .F.
   DO WHILE !EOF() .AND. NUMERO = M_P
        IF ENTREGADO < CANTIDAD
               SELE &M_SELE1
               RETURN(.F.)
        ENDIF
        SKIP
   ENDDO
ENDIF
SELE &M_SELE1
RETURN(.T.)

FUNCTION BUS_ARTI2
********************
PARAMETERS M_CL,M_SELE

SAVE SCREEN TO M_PANTA85
SELE &M_SELE
SET ORDER TO 1
SET EXACT OFF
M_LOG = LEN(ALLTRIM(M_CL)) - 1
SEEK SUBSTR(M_CL,2,M_LOG)
IF !FOUND()
    DO M_CARTEL WITH 15,24,0,.T.,.T.,.T.
    ESPERAR(0)
    RESTORE SCREEN FROM M_PANTA85
    SELE &M_SELE
    SET ORDER TO 1
    RETURN('                          ')
ENDIF
V_NOMBRE := {}
V_COD :={}
AFILL(V_NOMBRE,SPACE(40))
AFILL(V_COD,0)
KK = 1
DO WHILE !EOF() .AND. AT(SUBSTR(M_CL,2,M_LOG),COD_ART) <> 0
             AADD(V_COD,COD_ART)
             AADD(V_NOMBRE,SUBSTR(COD_ART,1,10) + ' ' + SUBSTR(DESCR,1,45) + ' ' + TRANSFORM(LISTA1,'###,###.##'))
             KK = KK + 1
             SKIP
             IF KK > 1000
                 GO BOTTOM
                 SKIP
             ENDIF
ENDDO
IF KK = 1
   DO M_CARTEL WITH 15,24,0,.T.,.T.,.T.
   ESPERAR(0)
   RESTORE SCREEN FROM M_PANTA85
   SELE &M_SELE
   SET ORDER TO 1
   RELEASE V_NOMBRE,V_COD
   RETURN('                          ')
ENDIF
V_NOM = ARRAY(KK-1)
V_CODI = ARRAY(KK-1)
FOR LL = 1 TO KK -1
    V_NOM[LL] = V_NOMBRE[LL]
    V_CODI[LL] = V_COD[LL]
NEXT

M_PL = VENTOPCION('CODIGO                    DESCRIPCION                         PRECIO',V_NOM,10,2,20,.T.,.T.,1)
IF LASTKEY() = 27
    RESTORE SCREEN FROM M_PANTA85
    SELE &M_SELE
    SET ORDER TO 1
    RELEASE V_NOMBRE,V_COD,V_CODI,V_NOM
    RETURN('                          ')
ENDIF
RESTORE SCREEN FROM M_PANTA85
SELE &M_SELE
SET ORDER TO 1
SEEK V_CODI[M_PL]
M_AUXI = V_CODI[M_PL]
RELEASE V_NOMBRE,V_COD,V_CODI,V_NOM
RETURN(M_AUXI)


PROCEDURE IMPRNUEVO
*******************
*Imprime Comprobante por Impresora
PARAMETERS M_SINUM,M_COPI

FRASE1= 'Equivale a U$S'
FRASE2= 'Base Dolar.'
FRASE3= 'El Valor en Pesos se Ajustara por N/D o N/C'
FRASE4= 'al momento de hacerse efectivo los valores.'
FRASE5= ''
SET PRINT TO REMI.TXT
SET DEVICE TO PRINT
MLINEAS = 0
IF M_COPI
    COPIAS = 1
ELSE
    COPIAS = M_COPIAS
ENDIF
FOR Q = 1 TO 1
   IF M_COMPRO = 'FAC'
      @ MLINEAS + 8,45 SAY 'FACTURA' + IIF(M_SINUM,STR(M_NUMERO,5,0),'')
   ELSE
      IF M_COMPRO = 'REM'
           @ MLINEAS + 8,45 SAY IIF(M_SINUM,'REMITO ' + STR(M_NUMERO,5,0),'')
      ELSE
          IF M_COMPRO = 'NDB'
              @ MLINEAS + 8,45 SAY 'N.DEBITO' + IIF(M_SINUM,STR(M_NUMERO,5,0),'')
          ELSE
              @ MLINEAS + 8,45 SAY 'N.CREDITO' + IIF(M_SINUM,STR(M_NUMERO,5,0),'')
          ENDIF
      ENDIF
   ENDIF
   @ MLINEAS + 11,60 SAY DTOC(M_FECH)
   @ MLINEAS + 21,3 SAY 'Sres.:  ' + CLIENTES->NOMBRE
   IF PEPE = 1
       @ MLINEAS + 22,11 SAY CLIENTES->DIRECC
   ELSE
       @ MLINEAS + 22,11 SAY DOMICILI->DOMENT
   ENDIF
   IF PEPE = 1
       @ MLINEAS + 23,1 SAY '          ' + '(' + STR(&ARCHIVO->CP,4,0) + ') ' + &ARCHIVO->LOC + ' ' + PROVI->NOMBRE
   ELSE
       @ MLINEAS + 23,1 SAY '          ' + '(' + STR(&ARCHI2->CDOMENT,4,0) + ') ' + &ARCHI2->SUCLOC + ' ' + PROVI->NOMBRE 
   ENDIF
   @ MLINEAS + 24,11 SAY IIF(CLIENTES->INSCRIP='S','Resp.Inscripto','No Inscripto')
   @ MLINEAS + 24,50 SAY CLIENTES->CUIT
   @ MLINEAS + 25,1 SAY REPLICATE('_',79)
   IF M_COMPRO = 'FAC'
      @ MLINEAS + 26,2 SAY 'REM Nro :'+ M_NROREM
   ENDIF
   @ MLINEAS + 27,30 SAY 'Paq: ' + STR(M_PAQUETES,3,0)
   @ MLINEAS + 27,45 SAY 'Lios : ' + STR(M_LIOS,3,0)
   @ MLINEAS + 27,60 SAY 'Kg : ' + STR(M_KILOS,6,2)
   IF M_COMPRO <> 'REM'
      @ MLINEAS + 28,1 SAY 'Condiciones : ' + M_CONDICIONES
   ENDIF
   @ MLINEAS + 29,1 SAY 'Cantidad        D E S C R I P C I O N             P.x uno   Bon.       SubTotal'
   @ MLINEAS + 30,1 SAY REPLICATE('-',79)
   MLINEAS =MLINEAS + 31
   M_LIN2 = MLINEAS + 50
   SUBT2 = TOTALF - M_BONIF
   IF M_COMPRO = 'FAC' .OR. M_COMPRO = 'REM' .OR. M_COMPRO = 'NCR'
       FOR I = 1 TO 35
          IF !EMPTY(V_ARTI[I])
             SELE 2
             SEEK V_ARTI[I]
             @ MLINEAS+1,1 SAY STR(V_CANTIDAD[I],8,3) + ' ' + V_DESCR[I]+' '+IIF(C<>5,STR(V_PRELIS[I],8,3)+IIF(V_DESCUEN[I]=0,'         ',' ' + STR(V_DESCUEN[I],5,2)+SPACE(3)) +STR(V_PRECIO[I]*V_CANTIDAD[I],11,3),' ')
             MLINEAS = MLINEAS + 1
          ENDIF
       NEXT
   ELSE
       I = 1
       DO WHILE I <= 10
          IF FACTURA[I] <> 0
             @ MLINEAS+1,5 SAY COMP_REC[I] + '       ' + STR(FACTURA[I],5,0) + '      '  +  STR(IMPORTE[I],10,2) + '     ' + IIF(FACTURA[I+1] <> 0,COMP_REC[I+1] + '           ' + STR(FACTURA[I+1],5,0) + '         '  +  STR(IMPORTE[I+1],10,2),' ')
             MLINEAS = MLINEAS + 1
          ENDIF
          I = I + 2
       ENDDO
       @ MLINEAS + 2,5 SAY M_CONC1
       @ MLINEAS + 3,5 SAY M_CONC2
   ENDIF
   IF C <> 5
      MLINEAS = M_LIN2
      IF MENSAJE
          @ MLINEAS - 2,1 SAY 'Equivale a U$S : ' + TRANSFORM(TOTNETO/M_COTIZA,'###,###.####') + ' Base Dolar : ' + STR(M_COTIZA,10,3)
      ENDIF
      @ MLINEAS-1,0 SAY REPLICATE('-',80)
      IF M_COMPRO = 'FAC' .OR. M_COMPRO = 'NDB' .OR. M_COMPRO = 'NCR'
         @ MLINEAS,48 SAY 'Subtotal             ' + TRANSFORM(TOTALF,'###,###.##')
         @ MLINEAS,5 SAY 'CONDICIONES DE PAGO'
         @ MLINEAS + 1,3 SAY M_FRASE
         @ MLINEAS + 1,48 SAY 'Impuesto'
         IF V_PORC[1] <> 0
             @ MLINEAS + 2,1 SAY STR(M_COND1,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND1) + ' NETO'
         ENDIF
         IF M_BONIF <> 0
            @ MLINEAS + 2,48 SAY 'Des% ' + IIF(V_PORC[1]<>0,STR(V_PORC[1],5,2),'') + IIF(V_PORC[2]<>0,'+' + STR(V_PORC[2],5,2),'') + IIF(V_PORC[3]<>0,'+' + STR(V_PORC[3],5,2),'')
            @ MLINEAS + 2,69 SAY TRANSFORM(M_BONIF,'###,###.##')
         ENDIF
         IF M_COND2 <> 0
            @ MLINEAS + 3,1 SAY STR(M_COND2,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND2) + ' ' + IIF(V_PORC[4]<>0,STR(V_PORC[4],5,2)+'%','NETO') + IIF(V_PORC[5]<>0,'+'+STR(V_PORC[5],5,2)+'%','') + IIF(V_PORC[6]<>0,'+'+STR(V_PORC[6],5,2)+'%','')
         ENDIF
         @ MLINEAS + 3,48 SAY 'Subtotal             ' + TRANSFORM(SUBT2,'###,###.##')

         IF M_COND3 <> 0
            @ MLINEAS + 4,1 SAY STR(M_COND3,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND3) + ' ' + IIF(V_PORC[7]<>0,STR(V_PORC[7],5,2)+'%','NETO') + IIF(V_PORC[8]<>0,'+'+STR(V_PORC[8],5,2)+'%','') + IIF(V_PORC[9]<>0,'+'+STR(V_PORC[9],5,2)+'%','')
         ENDIF
         @ MLINEAS + 4,48 SAY 'Iva  ' + STR(IVA->IVA,2,0) + '             ' + TRANSFORM(M_IVA,'####,###.##')
         IF M_COND4 <> 0
         @ MLINEAS + 5,1 SAY STR(M_COND4,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND4) + ' ' + IIF(V_PORC[10]<>0,STR(V_PORC[10],5,2)+'%','NETO') + IIF(V_PORC[11]<>0,'+'+STR(V_PORC[11],5,2)+'%','') + IIF(V_PORC[12]<>0,'+'+STR(V_PORC[12],5,2)+'%','')
         ENDIF
         @ MLINEAS + 5,48 SAY 'Adic ' + IIF(&ARCHIVO->INSCRIP = 'N', STR(IVA->ADIC,2,0) + '             ' + TRANSFORM(ADIC,'####,###.##'),'')
         IF M_COND5 <> 0
            @ MLINEAS + 6,1 SAY STR(M_COND5,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND5) + ' NETO'
         ENDIF
         @ MLINEAS + 6,48 SAY 'TOTAL                ' + TRANSFORM(TOTNETO,'###,###.##')
      ENDIF
   ELSE
      MLINEAS = M_LIN2 - 26
      FOR LK = 1 TO 8
          @ MLINEAS,50 SAY ALLTRIM(V_DETALLE[LK])
          MLINEAS = MLINEAS + 1
      NEXT
      @ MLINEAS + 1,50 SAY IIF(!EMPTY(ALLTRIM(M_EXPRES)),'VALOR ASEGURADO: ' + STR(m_asegura,12,2),'')
      @ MLINEAS + 2,50 SAY IIF(!EMPTY(ALLTRIM(M_EXPRES)),'DESPACHAR POR EXPRESO : ','')
      @ MLINEAS + 3,50 SAY IIF(!EMPTY(ALLTRIM(M_EXPRES)),TRIM(EXPRESO->NOMBRE) + ' --  ' + EXPRESO->DIREC,'')
      @ MLINEAS + 4,50 SAY IIF(!EMPTY(ALLTRIM(M_EXPRES)),'CUIT : ' + EXPRESO->CUIT,'') 
   ENDIF
   @ MLINEAS  + 5,1 SAY " " 
NEXT
SET DEVICE TO SCREEN
SET PRINT OFF
SET PRINT TO
RUN NODOSIMP REMI.TXT 96
RUN NODOSIMP REMI.TXT 96
RUN NODOSIMP REMI.TXT 96

RETURN



PROCEDURE IMPNUEVO
******************
*Imprime Comprobante por Impresora
PARAMETERS M_SINUM,M_COPI

FRASE1= 'Equivale a U$S'
FRASE2= 'Base Dolar.'
FRASE3= 'El Valor en Pesos se Ajustara por N/D o N/C'
FRASE4= 'al momento de hacerse efectivo los valores.'
FRASE5= ''

set print to i.txt
SET DEVICE TO PRINT
*@ PROW(),PCOL() SAY CHR(27) + CHR(120) + '0'
*@ PROW(),PCOL() SAY CHR(18)
*@ PROW(),PCOL() SAY CHR(27) + CHR(50)
MLINEAS = 0
IF M_COPI
    COPIAS = 1
ELSE
    COPIAS = M_COPIAS
ENDIF
FOR Q = 1 TO 1
   IF M_COMPRO = 'FAC'
      @ MLINEAS + 8,45 SAY 'FACTURA  ' + STR(M_NUMERO,5,0)
   ELSE
      IF M_COMPRO = 'REM'
           @ MLINEAS + 8,45 SAY IIF(M_SINUM,'REMITO ' + STR(M_NUMERO,5,0),'')
      ELSE
          IF M_COMPRO = 'NDB'
              @ MLINEAS + 8,45 SAY 'N.DEBITO' + IIF(M_SINUM,STR(M_NUMERO,5,0),'')
          ELSE
              @ MLINEAS + 8,45 SAY 'N.CREDITO' + IIF(M_SINUM,STR(M_NUMERO,5,0),'')
          ENDIF
      ENDIF
   ENDIF
   @ MLINEAS + 9,45 SAY DTOC(M_FECH)
   @ MLINEAS + 16,3 SAY 'Sres.:  ' + CLIENTES->NOMBRE
   IF PEPE = 1
       @ MLINEAS + 17,11 SAY CLIENTES->DIRECC
   ELSE
       @ MLINEAS + 17,11 SAY DOMICILI->DOMENT
   ENDIF
   IF PEPE = 1
       @ MLINEAS + 18,1 SAY '          ' + '(' + STR(&ARCHIVO->CP,4,0) + ') ' + &ARCHIVO->LOC + ' ' + PROVI->NOMBRE 
   ELSE
       @ MLINEAS + 18,1 SAY '          ' + '(' + STR(&ARCHI2->CDOMENT,4,0) + ') ' + &ARCHI2->SUCLOC + ' ' + PROVI->NOMBRE 
   ENDIF
   @ MLINEAS + 19,11 SAY IIF(CLIENTES->INSCRIP='S','Resp.Inscripto','No Inscripto')
   @ MLINEAS + 19,50 SAY CLIENTES->CUIT
   @ MLINEAS + 20,1 SAY REPLICATE('_',79)
   IF M_COMPRO = 'FAC'
      @ MLINEAS + 21,2 SAY 'REM Nro :'+ M_NROREM
   ENDIF
   @ MLINEAS + 21,30 SAY 'Paq: ' + STR(M_PAQUETES,3,0)
   @ MLINEAS + 21,45 SAY 'Lios : ' + STR(M_LIOS,3,0)
   @ MLINEAS + 21,60 SAY 'Kg : ' + STR(M_KILOS,6,2)
   IF M_COMPRO <> 'REM'
      @ MLINEAS + 22,1 SAY 'Condiciones : ' + M_CONDICIONES
   ENDIF
   @ MLINEAS + 23,1 SAY 'Cantidad        D E S C R I P C I O N             P.x uno   Bon.       SubTotal'
   @ MLINEAS + 24,1 SAY REPLICATE('-',79)
   MLINEAS =MLINEAS + 25
   M_LIN2 = MLINEAS + 50
   SUBT2 = TOTALF - M_BONIF
*   @ PROW(),PCOL() SAY CHR(27) + CHR(48)
   IF M_COMPRO = 'FAC' .OR. M_COMPRO = 'REM' .OR. M_COMPRO = 'NCR'
       FOR I = 1 TO 35
          IF !EMPTY(V_ARTI[I])
             SELE 2
             SEEK V_ARTI[I]
             @ MLINEAS+1,1 SAY STR(V_CANTIDAD[I],8,3) + '          ' + V_DESCR[I]+' '+IIF(C<>5,STR(V_PRELIS[I],8,3)+IIF(V_DESCUEN[I]=0,'         ',' ' + STR(V_DESCUEN[I],5,2)+SPACE(3)) +STR(V_PRECIO[I]*V_CANTIDAD[I],11,3),' ')
             MLINEAS = MLINEAS + 1
          ENDIF
       NEXT
   ELSE
       I = 1
       DO WHILE I <= 10
          IF FACTURA[I] <> 0
             @ MLINEAS+1,5 SAY COMP_REC[I] + '       ' + STR(FACTURA[I],5,0) + '      '  +  STR(IMPORTE[I],10,2) + '     ' + IIF(FACTURA[I+1] <> 0,COMP_REC[I+1] + '           ' + STR(FACTURA[I+1],5,0) + '         '  +  STR(IMPORTE[I+1],10,2),' ')
             MLINEAS = MLINEAS + 1
          ENDIF
          I = I + 2
       ENDDO
       @ MLINEAS + 2,5 SAY M_CONC1
       @ MLINEAS + 3,5 SAY M_CONC2
   ENDIF
   IF C <> 5
      MLINEAS = M_LIN2
      IF MENSAJE
          @ MLINEAS - 2,1 SAY 'Equivale a U$S : ' + TRANSFORM(TOTNETO/M_COTIZA,'###,###.####') + ' Base Dolar : ' + STR(M_COTIZA,10,3)
      ENDIF
      @ MLINEAS-1,0 SAY REPLICATE('-',80)
      IF M_COMPRO = 'FAC' .OR. M_COMPRO = 'NDB' .OR. M_COMPRO = 'NCR'
         @ MLINEAS,48 SAY 'Subtotal             ' + TRANSFORM(TOTALF,'###,###.##')
         @ MLINEAS,5 SAY 'CONDICIONES DE PAGO'
         @ MLINEAS + 1,3 SAY M_FRASE
         @ MLINEAS + 1,48 SAY 'Impuesto'
         IF V_PORC[1] <> 0
             @ MLINEAS + 2,1 SAY STR(M_COND1,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND1) + ' NETO'
         ENDIF
         IF M_BONIF <> 0
            @ MLINEAS + 2,48 SAY 'Des% ' + IIF(V_PORC[1]<>0,STR(V_PORC[1],5,2),'') + IIF(V_PORC[2]<>0,'+' + STR(V_PORC[2],5,2),'') + IIF(V_PORC[3]<>0,'+' + STR(V_PORC[3],5,2),'')
            @ MLINEAS + 2,69 SAY TRANSFORM(M_BONIF,'###,###.##')
         ENDIF
         IF M_COND2 <> 0
            @ MLINEAS + 3,1 SAY STR(M_COND2,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND2) + ' ' + IIF(V_PORC[4]<>0,STR(V_PORC[4],5,2)+'%','NETO') + IIF(V_PORC[5]<>0,'+'+STR(V_PORC[5],5,2)+'%','') + IIF(V_PORC[6]<>0,'+'+STR(V_PORC[6],5,2)+'%','')
         ENDIF
         @ MLINEAS + 3,48 SAY 'Subtotal             ' + TRANSFORM(SUBT2,'###,###.##')

         IF M_COND3 <> 0
            @ MLINEAS + 4,1 SAY STR(M_COND3,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND3) + ' ' + IIF(V_PORC[7]<>0,STR(V_PORC[7],5,2)+'%','NETO') + IIF(V_PORC[8]<>0,'+'+STR(V_PORC[8],5,2)+'%','') + IIF(V_PORC[9]<>0,'+'+STR(V_PORC[9],5,2)+'%','')
         ENDIF
         @ MLINEAS + 4,48 SAY 'Iva  ' + STR(IVA->IVA,2,0) + '             ' + TRANSFORM(M_IVA,'####,###.##')
         IF M_COND4 <> 0
         @ MLINEAS + 5,1 SAY STR(M_COND4,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND4) + ' ' + IIF(V_PORC[10]<>0,STR(V_PORC[10],5,2)+'%','NETO') + IIF(V_PORC[11]<>0,'+'+STR(V_PORC[11],5,2)+'%','') + IIF(V_PORC[12]<>0,'+'+STR(V_PORC[12],5,2)+'%','')
         ENDIF
         @ MLINEAS + 5,48 SAY 'Adic ' + IIF(&ARCHIVO->INSCRIP = 'N', STR(IVA->ADIC,2,0) + '             ' + TRANSFORM(ADIC,'####,###.##'),'')
         IF M_COND5 <> 0
            @ MLINEAS + 6,1 SAY STR(M_COND5,3,0) + ' Dias ' + 'Venc : ' + DTOC(M_FECH + M_COND5) + ' NETO'
         ENDIF
         @ MLINEAS + 6,48 SAY 'TOTAL                ' + TRANSFORM(TOTNETO,'###,###.##')
      ENDIF
   ELSE
      MLINEAS = M_LIN2 - 10
      FOR LK = 1 TO 8
          @ MLINEAS,50 SAY ALLTRIM(V_DETALLE[LK]) 
          MLINEAS = MLINEAS + 1
      NEXT
      @ MLINEAS + 1,50 SAY IIF(!EMPTY(ALLTRIM(M_EXPRES)),'VALOR ASEGURADO: ' + STR(TOTNETO,12,2) ,'')
      @ MLINEAS + 2,85 SAY IIF(!EMPTY(ALLTRIM(M_EXPRES)),'DESPACHAR POR EXPRESO : ','')
      @ MLINEAS + 3,85 SAY IIF(!EMPTY(ALLTRIM(M_EXPRES)),TRIM(EXPRESO->NOMBRE) + ' --  ' + EXPRESO->DIREC,'')
      @ MLINEAS + 4,85 SAY IIF(!EMPTY(ALLTRIM(M_EXPRES)),'CUIT : ' + EXPRESO->CUIT,'') 
   ENDIF
   MLINEAS = MLINEAS + 12
*   @ PROW(),PCOL() SAY CHR(27) + CHR(50)
NEXT
SET DEVICE TO SCREEN
set priNT off
set print to
for i = 1 to copias
    run nodosimp i.txt 120
next
RETURN
