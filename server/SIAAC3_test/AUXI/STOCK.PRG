*Listados de Stock y Ajustes Por Inventario (Menu)

*IF !SEGURIDAD(MM_CLAVE,'I')
*     DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*     ESPERAR(0)
*     RETURN
*ENDIF


DO WHILE .T.
   DECLARE MENPEE[3]
   DECLARE OPPEE[3]
   OPPEE[1]='LISTADO de STOCK de MERCADERIAS EN GENERAL'
   OPPEE[2]='LISTADO de STOCK por PUNTO de PEDIDO'
   OPPEE[3]='AJUSTE de STOCK por INVENTARIO'
   MENPEE[1]='          º Stock de Articulos por N£mero, por Color y Por C¢digo'
   MENPEE[2]='          º Stock de Articulos que deben ser repuestos'
   MENPEE[3]='          º Ajuste de Saldos de Articulos por Inventario'


   *    Displaya opciones y captura.
   OPPE=OPCIONES('SISTEMA DE VENTAS - STOCK DE MERCADERIAS',OPPEE,MENPEE)
   *    Fin
   IF LASTKEY()=27
      EXIT
   ENDIF
   DO CASE
   CASE OPPE=1
      DO LIS_STOCK WITH .F.
   CASE OPPE=2
      DO LIS_STOCK WITH .T.
   CASE OPPE=3
      DO AJUSTE
   ENDCASE
ENDDO
RETURN

PROCEDURE LIS_STOCK
*******************
*Listado de Stock

*IF !SEGURIDAD(MM_CLAVE,'J')
*     DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*     ESPERAR(0)
*     RETURN
*ENDIF

PARAMETERS CRITICO

SELE 2
USE ARTIC INDEX ARTIC

SELE 12
USE PROVEDOR INDEX PROVEDOR

SELE 10
USE PEDIDOS2 INDEX PEDIDOS2

SELE 11
USE PEDIDOS INDEX PEDIDOS

R5 = .F.

DO WHILE .T.
   CLEAR
   DO TITULO
   DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
   @ 1,0 TO 23,79 DOUBLE
   IF R5
      @ 23,79 SAY '.'
   ENDIF
   SET COLOR TO I
   @ 3,30 SAY ' * LISTADO DE STOCK * '
   SET COLOR TO
   @ 10,2 TO 12,78
   M_DESDE = SPACE(11)
   M_PROV = SELE_PROV(5,30,15)
   IF LASTKEY() = 27
      EXIT
   ENDIF
   SELE 12
   SEEK M_PROV
   DESDE_N = 0
   HASTA_N = 0
   SET COLOR TO I
   @ 11,5 SAY 'Proveedor : ' + PROVEDOR->NOMBRE
   SET COLOR TO
   IMPRE = .F.
   IF APRUEBA(24,0,11)
      SET DEVICE TO PRINT
      IMPRE = .T.
   ENDIF
   LINEAS = 67
   SELE 2
   IF ALLTRIM(PROVEDOR->NOMBRE) <> 'TODOS'
       SET FILTER TO COD_PROV = M_PROV
   ENDIF
   SELE 2
   GO TOP
   PRIMERA = .T.
   HOJA = 1
   DO WHILE !EOF()
      IF LINEAS > 66 .AND. IMPRE
         DO ENC_STOCK
      ENDIF
      IF LINEAS > 20 .AND. !IMPRE
         DO ENC_STOCK
         IF LASTKEY() = 27
             GO BOTTOM
             SKIP
             LOOP
         ENDIF
      ENDIF
      TOTAL = STOCK
      SUMAR = .F.
      M_COMPRO = BUS_COM()
      SELE 2
      IF CRITICO
         IF TOTAL <= ARTIC->P_CRIT
            @ LINEAS,1 SAY COD_ART + ' ' + IIF(IMPRE,CHR(15) + DESCR + CHR(18),SUBSTR(DESCR,1,29))+  ' ' + STR(STOCK,10,3) + ' ' + STR(M_COMPRO,7,3) + ' ' + STR(STOCK - M_COMPRO,10,3) + ' ' + SUBSTR(UNIDAD,1,5)
            SUMAR = .T.
         ENDIF
      ELSE
         @ LINEAS,1 SAY COD_ART + ' ' + IIF(IMPRE,CHR(15) + DESCR + CHR(18),SUBSTR(DESCR,1,29))+  ' ' + STR(STOCK,10,3) + ' ' + STR(M_COMPRO,10,3) + ' ' + STR(STOCK - M_COMPRO,7,3) + ' ' + SUBSTR(UNIDAD,1,5)
         SUMAR = .T.
      ENDIF
      SKIP
      IF SUMAR
         LINEAS = LINEAS + 1
      ENDIF
   ENDDO
   SELE 2
   SET FILTER TO
   IF IMPRE
      EJECT
      SET DEVICE TO SCREEN
   ELSE
      DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
      ESPERAR(0)
      @ 24,0 SAY SPACE(79)
   ENDIF
ENDDO
CLOSE ALL
RETURN



*!*********************************************************************
*!
*!      Procedure: ENC_STOCK
*!
*!      Called by: LIS_STOCK      (procedure in STOCK.PRG)
*!
*!          Calls: M_CARTEL       (procedure in SIAAC1.PRG)
*!               : ESPERAR()      (function  in SIAAC1.PRG)
*!               : TITULO         (procedure in SIAAC1.PRG)
*!               : IIF()          (function  in ?)
*!               : CHR()          (function  in ?)
*!               : DTOC()         (function  in ?)
*!               : DATE()         (function  in ?)
*!               : STR()          (function  in ?)
*!
*!*********************************************************************
PROCEDURE ENC_STOCK
*******************

LINEAS = 1
IF !PRIMERA
   IF IMPRE
      EJECT
   ELSE
      DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
      ESPERAR(0)
      CLEAR
   ENDIF
ELSE
   PRIMERA = .F.
   IF !IMPRE
      CLEAR
   ENDIF
ENDIF

DO TITULO
@ LINEAS + 2,20 SAY  IIF(IMPRE,CHR(14),'       ') + ' * LISTADO DE STOCK * '
@ LINEAS + 3,3 SAY 'Fecha : ' + DTOC(DATE())
@ LINEAS + 3,60 SAY 'Hoja Nro. : ' + STR(HOJA,2,0)
@ LINEAS + 4,1 SAY 'Proveedor : ' + PROVEDOR->NOMBRE
IF !IMPRE
    @ LINEAS + 5,1 SAY 'CODIGO        ARTICULO                      CANTIDAD    COMPROM.    DISPON.'
ELSE
    @ LINEAS + 5,1 SAY 'CODIGO        ARTICULO                      CANTIDAD    COMPROM.    DISPON.'
ENDIF
@ LINEAS + 6,1 SAY REPLICATE('=',78)
HOJA = HOJA + 1
LINEAS = 9
RETURN

PROCEDURE AJUSTE
****************
*Ajuste de Stock Por Inventario

*IF !SEGURIDAD(MM_CLAVE,'K')
*     DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*     ESPERAR(0)
*     RETURN
*ENDIF

SELE 2
USE ARTIC INDEX ARTIC

R5 = .F.

DO WHILE .T.
   CLEAR
   DO TITULO
   @ 1,0 TO 23,79 DOUBLE
   IF R5
      @ 23,79 SAY '.'
   ELSE
      @ 1,0 TO 23,79 DOUBLE
   ENDIF
   SET COLOR TO I
   @ 3,25 SAY ' * AJUSTE DE STOCK POR INVENTARIO * '
   SET COLOR TO
   @ 6,1 TO 15,78
   DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
   DO WHILE .T.
      SELE 2
      M_ARTI = SPACE(11)
      SET COLOR TO I
      @ 7,25 SAY SPACE(11)
      SET COLOR TO
      @ 7,3 SAY 'C¢digo de Art¡culo :  '
      @ 7,25 GET M_ARTI PICT '@!'
      READ
      IF LASTKEY() = 27
          EXIT
      ENDIF
      SEEK M_ARTI
      IF FOUND()
         SET COLOR TO I
         @ 7,39 SAY SUBSTR(DESCR,1,35)
         SET COLOR TO
         EXIT
      ELSE
         DO M_CARTEL WITH 15,24,0,.T.,.T.,.T.
         ESPERAR(0)
         @ 24,0 SAY SPACE(79)
         @ 9,11 SAY SPACE(30)
      ENDIF
   ENDDO
   IF LASTKEY() = 27
      EXIT
   ENDIF
   V_CANTI = STOCK
   @ 11,33 SAY ARTIC->UNIDAD
   @  9,3 SAY 'Cantidad en Stock : ' + STR(STOCK,10,0)
   @ 11,3 SAY 'Cantidad Real     : ' GET V_CANTI PICT '######' VALID V_CANTI >= 0
   READ
   IF LASTKEY() = 27
      EXIT
   ENDIF
   IF APRUEBA(24,0,2)
      SELE 2
      REPLACE STOCK WITH V_CANTI
   ENDIF
ENDDO
CLOSE ALL
RETURN
*: EOF: STOCK.PRG


FUNCTION BUS_COM
****************
SELE 11
GO TOP
M_COM = 0
DO WHILE !EOF()
     IF !PENDIENTE
          SELE 10
          SEEK STR(PEDIDOS->NUMERO,5,0)
          DO WHILE !EOF() .AND. NUMERO = PEDIDOS->NUMERO
               IF ARTICULO = ARTIC->COD_ART
                  M_COM = M_COM + CANTIDAD - ENTREGADO
               ENDIF
               SKIP
          ENDDO
     ENDIF
     SELE 11
     SKIP
ENDDO
RETURN(M_COM)
