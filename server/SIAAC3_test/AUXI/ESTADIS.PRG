*******************************************************************************
*Fuente : ESTADIS.PRG                                                         *
*                                                                             *
*******************************************************************************

DO WHILE .T.
   DECLARE MENPEE[3]
   DECLARE OPPEE[3]
   OPPEE[1]='VENTA de ARTICULOS por VENDEDOR'
   OPPEE[2]='VENTAS ENTRE FECHA POR VENDEDOR'
   OPPEE[3]='LISTADO de % DE UTILIDADES'
   MENPEE[1]='          º  Articulos y Montos'
   MENPEE[2]='          º  por facturas, etc'
   MENPEE[3]='          º  % Utilidades de los Articulos de Fabricacion'

   *    Displaya opciones y captura.
   OPPE=OPCIONES('SISTEMA DE VENTAS - ESTADISTICAS',OPPEE,MENPEE)
   *    Fin
   IF LASTKEY()=27
      EXIT
   ENDIF
   DO CASE
   CASE OPPE = 1
      DO ACUM_VTA
   CASE OPPE = 2
      DO VEN_ART
   CASE OPPE = 3
      DO UTILIDAD
   ENDCASE
ENDDO
RETURN

PROCEDURE ESTA_COMP
********* *********
*Listado de Articulos que Vendio un Determinado Cliente

SELE 9
USE VENDEDOR INDEX VENDEDOR

SELE 2
USE ARTIC INDEX ARTIC

SELE 11
USE CLIENTES INDEX CLIENTES

DO WHILE .T.
   CLEAR
   DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
   DO TITULO
   @ 1,0 TO 23,79 DOUBLE
   STOR DATE() TO M_DESDE,M_HASTA
   M_VEND = SPACE(10)
   M_ARTI = SPACE(10)
   SET COLOR TO I
   @ 3,20 SAY 'LISTADO DE VENTAS DE ARICULOS ENTRE FECHA POR VENDEDOR'
   SET COLOR TO
   @ 5,1 TO 5,78
   @ 8,3  SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
   @ 10,3 SAY 'Desde Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
   @ 12,3 SAY 'Vendedor (9999999999 = TODOS) : ' GET M_VEND PICT '@!' VALID VALVEND(14,3,M_VEND)
   READ
   IF LASTKEY() = 27
       EXIT
   ENDIF
   SELE 2
   @ 16,3 SAY 'Articulo (9999999999 = TODOS) : ' GET M_ARTI PICT '@!' VALID VALARTI(18,3,M_ARTI)
   READ
   IF LASTKEY() = 27
      LOOP
   ENDIF
   IF APRUEBA(24,0,2)
      @ 24,0 SAY SPACE(79)
      IMPRE = .F.
      IF APRUEBA(24,0,11)
         IMPRE = .T.
         SET DEVICE TO PRINT
      ENDIF
      HOJA = 1
      LINEAS = 66
      PRIMERA = .T.
      IMPRIMIO = .F.
      M_TOTAL = 0
      FOR LO = 1 TO 1
         SELE 4
         USE COMPRO1 INDEX COMPRO2
         SELE 5
         USE DETALLE1 INDEX DETALLE1
         SELE 4
         GO TOP
         DO WHILE !EOF()
            IF M_VEND <> '9999999999'
                 IF M_VEND <> CAJERO
                      SKIP
                      LOOP
                 ENDIF
            ENDIF
            IF  FECHA >= M_DESDE .AND. FECHA <= M_HASTA
               SELE 5
               SEEK COMPRO1->TIPO + STR(COMPRO1->NUMERO,5,0)
               DO WHILE .T. .AND. !EOF()
                  IF TIPO = COMPRO1->TIPO .AND. NUMERO = COMPRO1->NUMERO .AND. TIPO = 'FAC'
                     IF LINEAS > 65 .AND. IMPRE
                        DO ENC_ESTA1
                     ENDIF
                     IF LINEAS > 20 .AND. !IMPRE
                        DO ENC_ESTA1
                        IF LASTKEY() = 27
                            SELE 5
                            GO BOTTOM
                            SKIP
                            LOOP
                        ENDIF
                     ENDIF
                     SELE 2
                     SEEK DETALLE1->ARTICULO
                     SELE 9
                     SEEK COMPRO1->CAJERO
                     SELE 11
                     SEEK COMPRO1->CLIENTE
                     SELE 5
                     IF M_ARTI <> '9999999999'
                           IF DETALLE1->ARTICULO <> M_ARTI
                                SKIP
                                LOOP
                           ENDIF
                     ENDIF
                     @ LINEAS,0 SAY SUBSTR(CLIENTES->NOMBRE,1,10) + ' ' + SUBSTR(ARTIC->DESCR,1,45) + ' ' + STR(CANTIDAD,5,0) + ' ' + STR(PRECIO,8,2) + ' ' + STR(PRECIO * CANTIDAD,8,2)
                     M_TOTAL = M_TOTAL + (PRECIO * CANTIDAD)
                     LINEAS = LINEAS + 1
                     IMPRIMIO = .T.
                  ELSE
                     EXIT
                  ENDIF
                  SKIP
               ENDDO
            ENDIF
            SELE 4
            IF LASTKEY() = 27
               GO BOTTOM
            ENDIF
            SKIP
         ENDDO
      NEXT
      @ LINEAS + 1,1 SAY 'Total Vendido : ' + TRANSFORM(M_TOTAL,'###,###.##')
      IF IMPRE
         IF IMPRIMIO
            EJECT
         ENDIF
         SET DEVICE TO SCREEN
      ELSE
         DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
         ESPERAR(0)
         @ 24,0 SAY SPACE(79)
      ENDIF
   ENDIF
ENDDO
CLOSE ALL
RETURN

PROCEDURE ENC_ESTA1
********* *********

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
@ LINEAS,18 SAY ' * E S T A D I S T I C A S   D E   V E N T A S * '
@ LINEAS + 3,1 SAY 'Ventas entre el ' + DTOC(M_DESDE) + ' y el ' + DTOC(M_HASTA)
@ LINEAS + 4,50 SAY 'Hoja Nro : ' + STR(HOJA,2,0)
IF M_VEND <> '9999999999'
    @ LINEAS + 5,1 SAY 'Vendedor : ' + VENDEDOR->NOMBRE
ELSE
    @ LINEAS + 5,1 SAY 'Vendedor : ' + VENDEDOR->NOMBRE
ENDIF
@ LINEAS + 6,1 SAY 'Cliente            Articulo                              Cant.   Precio   Total'
@ LINEAS + 7,1 SAY REPLICATE('=',79)
LINEAS = 10
HOJA = HOJA + 1
RETURN

PROCEDURE VEN_ART
********* *******
*Ventas por Fecha POR VENDEDOR

SELE 1
USE ARTIC INDEX ARTIC

SELE 4
USE COMPRO1 INDEX COMPRO1

SELE 9
USE VENDEDOR INDEX VENDEDOR

SELE 5
USE CLIENTES INDEX CLIENTES

M_ARTI = SPACE(10)
R5 = .F.
DO WHILE .T.
   CLEAR
   DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
   DO TITULO
   @ 1,0 TO 23,79 DOUBLE
   SET COLOR TO I
   @ 3,30 SAY 'VENTAS POR FECHAS POR VENDEDOR'
   SET COLOR TO
   @ 5,1 TO 5,78
   STOR DATE() TO M_DESDE,M_HASTA
   M_VEND = SPACE(10)
   @ 11,3 SAY 'Desde Que Fecha Desea El Listado: ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
   @ 13,3 SAY 'Hasta Que Fecha Desea El Listado: ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
   @ 15,3 SAY 'Vendedor (9999999999= TODOS)    : ' GET M_VEND PICT '@!' VALID VALVEND(16,3,M_VEND)
   READ
   IF LASTKEY() = 27
      EXIT
   ENDIF
   IF APRUEBA(24,0,2)
      SELE 4
      GO TOP
      LINEAS = 70
      HOJA = 1
      PRIMERA = .T.
      IMPRE = .F.
      @ 24,0 SAY SPACE(79)
      IF APRUEBA(24,0,11)
         SET DEVI TO PRINT
         IMPRE = .T.
      ENDIF
      M_ACUM = 0
      DO WHILE !EOF()
         IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA .AND. !ANULADA
            IF TIPO = 'FAC' .OR. TIPO = 'CDO'
               IF LINEAS > 66 .AND. IMPRE
                  DO ENC_VART
               ENDIF
               IF LINEAS > 20 .AND. !IMPRE
                  DO ENC_VART
                  IF LASTKEY() = 27
                      SELE 4
                      GO BOTTOM
                      SKIP
                      LOOP
                  ENDIF
               ENDIF
               IF M_VEND <> '9999999999'
                    IF CAJERO <> M_VEND
                        SKIP
                        LOOP
                    ENDIF
               ENDIF
               SELE 9
               SEEK COMPRO1->CAJERO
               SELE 5
               SEEK COMPRO1->CLIENTE
               SELE 4
               @ LINEAS,1 SAY DTOC(FECHA) + ' ' + STR(NUMERO,5,0) + '      ' + SUBSTR(CLIENTES->NOMBRE,1,20) + ' ' + SUBSTR(VENDEDOR->NOMBRE,1,20) + ' ' + TRANSFORM(TOTAL + IVA + REC_IVA - BONIF,'###,###.##')
               LINEAS = LINEAS + 1
               M_ACUM = M_ACUM + (TOTAL + IVA + REC_IVA - BONIF)
            ENDIF
         ENDIF
         SKIP
      ENDDO
      IF IMPRE
         @ LINEAS + 1,1 SAY 'Total de Ventas : ' + transform(m_acum,'###,###.##')
         EJECT
         SET DEVI TO SCREEN
      ELSE
         @ LINEAS + 1,1 SAY 'Total de Ventas : ' + transform(m_acum,'###,###.##')
         DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
         ESPERAR(0)
      ENDIF
   ENDIF
   @ 24,0 SAY SPACE(79)
ENDDO
CLOSE ALL
RETURN

PROCEDURE ENC_VART
********* ********
*Encabezamiento

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
@ LINEAS,25 SAY 'RESUMEN DE VENTAS '
@ LINEAS + 2,2 SAY 'Desde Fecha : ' + DTOC(M_DESDE) + '  Hasta Fecha: ' + DTOC(M_HASTA)
@ LINEAS + 3,60 SAY 'Hoja Nro: ' + STR(HOJA,3,0)
@ LINEAS + 4,1 SAY REPLICATE('=',79)
@ LINEAS + 5,1 SAY 'FECHA    FACTURA NRO.    CLIENTE            VENDEDOR           TOTAL VENDIDO'
@ LINEAS + 6,1 SAY REPLICATE('=',79)
HOJA = HOJA + 1
LINEAS = 9
RETURN


PROCEDURE UTILIDAD
******************
*Utilidad de Ventas

SELE 1
USE SUBCONJ INDEX SUBCONJ

SELE 2
USE ARTIC INDEX ARTIC
M_LISTA = 1

DO WHILE .T.
    CLEAR
    DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
    DO TITULO
    @ 1,0 TO 23,79 DOUBLE
    SET COLOR TO I
    @ 3,18 SAY 'LISTADO DE UTILIDADES DE PRODUCTOS DE FABRICACION'
    SET COLOR TO
    @ 5,1 TO 5,78
    M_PORB = 0
    @ 8,3 SAY 'Numero de Lista de Venta : ' GET M_LISTA PICT '#' VALID M_LISTA >= 1 .AND. M_LISTA <= 5
    @ 10,3 SAY '% de Bonificacion        : ' GET M_PORB PICT '###.##'
    READ
    IF LASTKEY() = 27
        EXIT
    ENDIF
    IMPRE = .F.
    IF APRUEBA(24,0,11)
         DO M_CARTEL WITH 10,24,0,.T.,.F.,.T.
         ESPERAR(0)
         IF LASTKEY() = 27
             LOOP
         ENDIF
         SET DEVI TO PRINT
         IMPRE = .T.
    ENDIF
    LINEAS = 70
    HOJA = 1
    PRIMERA = .T.
    SELE 1
    GO TOP
    DO WHILE !EOF()
         IF LINEAS > 65 .AND. IMPRE
              DO ENC_UTI
         ENDIF
         IF LINEAS > 20 .AND. !IMPRE
              DO ENC_UTI
              IF LASTKEY() = 27
                  SELE 1
                  GO BOTTOM
                  SKIP
                  LOOP
              ENDIF
         ENDIF
         SELE 2
         SEEK SUBCONJ->CODIGO
         SELE 1
         M_L = 'LISTA' + STR(M_LISTA,1,0)
         M_L = ARTIC->&M_L - (ARTIC->&M_L * M_PORB / 100)
         M_DIFE = (M_L - COSTO) / COSTO * 100
         @ LINEAS,1 SAY CODIGO + ' ' + SUBSTR(ARTIC->DESCR,1,30) + ' ' + TRANSFORM(COSTO,'###,###.##') + ' ' + TRANSFORM(M_L,'###,###.##') + ' ' + TRANSFORM(M_DIFE,'######.##')
         LINEAS = LINEAS + 1
         SKIP
     ENDDO
     IF IMPRE
         EJECT
         SET DEVI TO SCREEN
     ELSE
         DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
         ESPERAR(0)
     ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE ENC_UTI
*****************

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

@ LINEAS,20 SAY 'LISTADO DE UTILIDADES DE PRODUCTOS DE FABRICACION'
@ LINEAS + 2,1 SAY 'Fecha : ' + DTOC(M_FECHA)
@ LINEAS + 2,50 SAY 'Hoja : ' + STR(HOJA,3,0)
@ LINEAS + 3,1 SAY REPLICATE('=',79)
@ LINEAS + 4,1 SAY 'CODIGO ART.    DESCRIPCION                          COSTO      VENTA  %UTILIDAD'
@ LINEAS + 5,1 SAY REPLICATE('=',79)
LINEAS = 7
HOJA = HOJA + 1
RETURN

PROCEDURE ACUM_VTA
******************
*Acumulado de ventas de articulos por fechas.

SELE 1
USE DETALLE1

SELE 2
USE ARTIC INDEX ARTIC

SELE 3
USE COMPRO1 INDEX COMPRO1

SELE 9
USE VENDEDOR INDEX VENDEDOR

DO WHILE .T.
      CLEAR
      @ 1,0 TO 23,79 DOUBLE
      DO TITULO
      DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
      SET COLOR TO I
      @ 3,30 SAY 'ACUMULADOS DE VENTA DE ARTICULOS'
      SET COLOR TO
      @ 5,1 TO 5,78
      STOR M_FECHA TO M_DESDE,M_HASTA
      M_VEND = SPACE(10)
      @ 8,3 SAY  'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
      @ 10,3 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
      @ 12,3 SAY 'Vendedor    : ' GET M_VEND PICT '@!' VALID VALVEND(12,30,M_VEND)
      READ
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
                          LOOP
                     ENDIF
              ENDIF
              DO M_CARTEL WITH 119,24,0,.T.,.F.,.T.
              IF IMPRE
                   SET PRINT ON
                   SET PRINT TO LPT1
                   IF ERROR_PRINT()
                        LOOP
                   ENDIF
                   SET DEVI TO PRINT
                   @ PROW(),PCOL() SAY CHR(27) + CHR(120) + '0'
                   @ PROW(),PCOL() SAY CHR(18)
              ENDIF
              SELE 1
              INDEX ON ARTICULO TO AUXILI0
              V_ARTICULO = ARRAY(2000,2)
              FOR I = 1 TO 2000
                    V_ARTICULO[I,1] = 0
                    V_ARTICULO[I,2] = ' '
              NEXT
              GO TOP
              M_TOTAL = 0
              I = 1
              DO WHILE !EOF()
                      M_ARTANT = ARTICULO
                      DO WHILE !EOF() .AND. M_ARTANT = ARTICULO
                           SELE 3
                           SEEK DETALLE1->TIPO + STR(DETALLE1->NUMERO,5,0)
                           SELE 1
                           IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA .AND. !COMPRO1->ANULADA .AND. COMPRO1->CAJERO = M_VEND
                                IF TIPO = 'FAC'
                                     V_ARTICULO[I,1] = (CANTIDAD * PRECIO) + V_ARTICULO[I,1]
                                     V_ARTICULO[I,2] = ARTICULO
                                     M_TOTAL = M_TOTAL + (PRECIO * CANTIDAD)
                                ELSEIF TIPO = 'NCR'
                                     V_ARTICULO[I,1] = V_ARTICULO[I,1] - (CANTIDAD * PRECIO)
                                     V_ARTICULO[I,2] = ARTICULO
                                     M_TOTAL = M_TOTAL - (PRECIO * CANTIDAD)
                                ENDIF
                           ENDIF
                           SKIP
                      ENDDO
                      I = I + 1
                      IF I > 2000
                           GO BOTTOM
                           SKIP
                      ENDIF
              ENDDO
              ASORT(V_ARTICULO,,,{|x,y| x[1] > y[1]})
              LINEAS = 66
              PRIMERA = .T.
              HOJA = 1
              FOR I = 1 TO LEN(V_ARTICULO)
                      IF LINEAS > 62 .AND. IMPRE
                             DO ENC_ACUM
                      ELSEIF LINEAS > 20 .AND. !IMPRE
                             DO ENC_ACUM
                      ENDIF
                      IF V_ARTICULO[I,1] > 0
                          SELE 2
                          SEEK V_ARTICULO[I,2]
                          @ LINEAS,1 SAY COD_ART + ' ' + SUBSTR(DESCR,1,45) + ' ' + TRANSFORM(V_ARTICULO[I,1],'###,###.##') + '    ' + IIF(M_TOTAL <> 0,TRANSFORM(V_ARTICULO[I,1] / M_TOTAL * 100,'###.##'),'')
                          LINEAS = LINEAS + 1
                      ENDIF
                      IF LASTKEY() = 27
                           I = 4000
                      ENDIF
              NEXT
              @ LINEAS ,57 SAY '------------'
              @ LINEAS + 1,58 SAY TRANSFORM(M_TOTAL,'###,###.##')
              IF IMPRE
                   EJECT
                   SET DEVI TO SCREEN
                   SET PRINT OFF
              ELSE
                   DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
                   ESPERAR(0)
              ENDIF
      ENDIF
ENDDO
CLOSE ALL
ERASE AUXILI0.NTX
RETURN



PROCEDURE ENC_ACUM
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
@ LINEAS,20 SAY 'LISTADO DE ACUMULADO DE VENTAS DE ARTICULOS'
@ LINEAS + 2,1 SAY 'Desde Fecha : ' + DTOC(M_DESDE) + ' Hasta Fecha : ' + DTOC(M_HASTA)
@ 3,1 SAY 'Vendedor : ' + VENDEDOR->NOMBRE
@ LINEAS + 3,60 SAY 'Hoja : ' + STR(HOJA,3,0)
@ LINEAS + 4,0 SAY REPLICATE('=',80)
@ LINEAS + 5,0 SAY 'CODIGO ARTICULO              DESCRIPCION                      VENTAS   % S/TOTAL'
@ LINEAS + 6,0 SAY REPLICATE('=',80)
LINEAS = 8
HOJA = HOJA + 1
RETURN
