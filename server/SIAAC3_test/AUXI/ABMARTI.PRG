SELE 2
USE ARTIC INDEX ARTIC,AR2
GO BOTTOM
M_ART = COD_ART

SELE 12
USE PROVEDOR INDEX PROVEDOR

SELE 13
USE RUBROA INDEX RUBROA

PRIVATE M_ART,LETRA,MARCA,M_DES,M_PRO,M_PCRI,M_UNID,M_DESCU,M_COSTO,M_LISTA1,M_LISTA2,M_LISTA3,M_LISTA4,M_LISTA5,M_TPRE,M_STOCK,M_MEDIDA,M_RUB

SELE 2
DO WHILE .T.
   SELE 2
   CLEAR
   DO PANTARTI
   @ 4,25 GET M_ART PICT '@!' VALID VALVACIO(M_ART)
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   SEEK M_ART
   IF .NOT. FOUND()
      IF APRUEBA (24,0,39)
         @ 24,0 SAY SPACE(79)
         MARCA=.T.
         DO BLANVART
         DO CARGA_ART
         IF LASTKEY() = 27
            EXIT
         ENDIF
         IF APRUEBA  (24,0,2)
            @ 24,0 SAY SPACE(79)
            SELE 2
            APPEND BLANK
            DO GRABART
         ENDIF
      ENDIF
   ELSE
      MARCA=.F.
      DO BLANVART
      DO MUESTRART
      DO M_CARTEL WITH 35,24,0,.T.,.T.,.T.
      LETRA='M'
      @ 24,66 GET LETRA PICT 'A' VALID LETRA = 'B' .OR. LETRA = 'M'
      READ
      @ 24,0 SAY SPACE(79)
      IF LASTKEY()=27
         LOOP
      ENDIF
      IF LETRA='M'
         DO CARGA_ART
         IF LASTKEY()=27
            LOOP
         ENDIF
         IF APRUEBA(24,0,36)
            @ 24,0 SAY SPACE(79)
            DO GRABART
         ENDIF
      ELSE
         IF APRUEBA(24,0,37)
            DO BORRAREG
            LOOP
         ENDIF
      ENDIF
   ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE PANTARTI
********* ********
* Muestra la pantalla de articulos
@ 1,1 TO  23,79 DOUBLE
SET COLOR TO I
@ 2,30  SAY " - ABM de ARTICULOS - "
SET COLOR TO
@ 3,2 TO 3,78
@ 4,3 SAY 'Codigo de Articulo  :'
@ 6,3 SAY 'Descripci�n         :'
@ 8,3 SAY 'C�digo de Proovedor :'
@ 10,3 SAY 'Punto Critico       :'
@ 10,45 SAY 'Stock               :'
@ 12,3 SAY 'Unidad              :'
@ 12,45 SAY 'Medida:'
@ 14,3 SAY '% de Bonificacion   :'
@ 14,45 SAY 'Precio de Costo:'
@ 16,3 SAY 'Lista 1             :'
@ 16,45 SAY 'Lista 2 : '
@ 18,3 SAY 'Lista 3             :'
@ 18,45 SAY 'Lista 4 : '
@ 20,3 SAY 'Lista 5             :'
@ 20,45 SAY 'Dol. o Pesos: '
@ 22,3 SAY 'rubro               :'

DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
RETURN

PROCEDURE CARGA_ART
*******************
* Carga de Datos del Articulo

IF .NOT. MARCA
   SET COLOR TO I
   @ 4,25 SAY M_ART PICT '@!'
   SET COLOR TO
ENDIF
DO WHILE .T.
   SELE 12
   @ 8,25 GET M_PRO PICT '@!'
   READ
   IF LASTKEY() = 27
      RETURN
   ENDIF
   SEEK M_PRO
   IF !FOUND()
      DO M_CARTEL WITH 13,24,0,.T.,.T.,.T.
      ESPERAR(0)
      @ 24,0 SAY SPACE(79)
   ELSE
      SET COLOR TO I
      @ 8,45 SAY NOMBRE
      SET COLOR TO
      EXIT
   ENDIF
ENDDO
SELE 2
@ 6,25 GET M_DES
@ 10,25 GET M_PCRI PICT'999999' VALID M_PCRI=0 .OR. M_PCRI>0
@ 10,65 GET M_STOCK PICT '##########'
@ 12,25 GET M_UNID
@ 12,65 GET M_MEDIDA
@ 14,25 GET M_DESCU PICT '###.##' VALID M_DESCU >= 0 .AND. M_DESCU <= 100
@ 14,63 GET M_COSTO PICT  '#########.####'
@ 16,25 GET M_LISTA1 PICT '###########.###'
@ 16,55 GET M_LISTA2 PICT '###########.###'
@ 18,25 GET M_LISTA3 PICT '###########.###'
@ 18,55 GET M_LISTA4 PICT '###########.###'
@ 20,25 GET M_LISTA5 PICT '###########.###'
@ 20,65 GET M_TPRE PICT 'A' VALID M_TPRE = 'D' .OR. M_TPRE = 'P'
READ
IF LASTKEY()=27
   RETURN
ENDIF
IF MARCA
    M_RUB = SELE_RUBA(15,30,20,M_RUB)
ELSE
    M_RUB = SELE_RUBA(15,30,20,M_RUB)
ENDIF
SET COLOR TO I
@ 22,30 SAY RUBROA->DESCR
SET COLOR TO
RETURN

PROCEDURE BLANVART
******************
* Realiza el Blanqueo de las Variables, en el caso que se trate de una
* Baja o una Modificacion se cargan las Variables con los Datos del Archivo.
IF MARCA
   M_DES=SPACE(53)
   M_PRO=SPACE(10)
   M_PCRI=0
   M_UNID=SPACE(10)
   M_DESCU = 0
   M_COSTO = 0
   STOR 0 TO M_LISTA1,M_LISTA2,M_LISTA3,M_LISTA4,M_LISTA5
   M_TPRE = 'D'
   M_STOCK = 0
   M_MEDIDA = 0
   M_RUB = SPACE(10)
ELSE
   M_ART=COD_ART
   M_DES=DESCR
   M_PRO=COD_PROV
   M_PCRI=P_CRIT
   M_UNID=UNIDAD
   M_DESCU = DESCU
   M_COSTO = COSTO
   M_LISTA1 = LISTA1
   M_LISTA2 = LISTA2
   M_LISTA3 = LISTA3
   M_LISTA4 = LISTA4
   M_LISTA5 = LISTA5
   M_TPRE = TPRE
   M_STOCK = STOCK
   M_MEDIDA = MEDIDA
   M_RUB = RUBRO
ENDIF
RETURN

PROCEDURE GRABART
*****************
* Grabacion del Registro.
SELE 2
REPLACE COD_ART WITH M_ART
REPLACE DESCR WITH M_DES
REPLACE COD_PROV  WITH M_PRO
REPLACE P_CRIT WITH M_PCRI
REPLACE UNIDAD WITH M_UNID
REPLACE DESCU WITH M_DESCU
REPLACE COSTO WITH M_COSTO
REPLACE LISTA1 WITH M_LISTA1
REPLACE LISTA2 WITH M_LISTA2
REPLACE LISTA3 WITH M_LISTA3
REPLACE LISTA4 WITH M_LISTA4
REPLACE LISTA5 WITH M_LISTA5
REPLACE TPRE WITH M_TPRE
REPLACE STOCK WITH M_STOCK
REPLACE MEDIDA WITH M_MEDIDA
REPLACE RUBRO WITH M_RUB
REPLACE FEAC WITH M_FECHA
RETURN

PROCEDURE MUESTRART
*******************
* En Baja o Modificacion se Displayan los Datos del Articulo.
SET COLOR TO I
@ 6,25 SAY M_DES
SET COLOR TO
RETURN

PROCEDURE BORRAREG
******************
* Borra el registro seleccionado en todos los archivos.

SELE 2
DELETE
PACK
RETURN

PROCEDURE LIS_ART
*****************
*Listado de Articulos
PARAMETERS M_PRE

IF M_PRE
   SELE 2
   USE ARTIC INDEX ARTIC,AR2

   IMPRE = .F.
   IF APRUEBA(24,0,11)
      SET DEVICE TO PRINT
      IMPRE = .T.
   ENDIF
ELSE
   IMPRE = .F.
ENDIF
GO TOP
LINEAS = 70
PRIMERA = .T.
HOJA = 1
DO WHILE !EOF()
   IF LINEAS > 65 .AND. IMPRE
      DO ENCABE
   ELSE
      IF LINEAS > 20 .AND. !IMPRE
         DO ENCABE
         IF LASTKEY() = 27
            GO BOTTOM
            SKIP
            LOOP
         ENDIF
      ENDIF
   ENDIF
   @ LINEAS,1 SAY COD_ART + ' ' + DESCR + ' ' + UNIDAD
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
ERASE C:\SIAAC\AUXILI0.NTX
IF M_PRE
   CLOSE ALL
ENDIF
RETURN


*!*********************************************************************
*!
*!      Procedure: ENCABE
*!
*!      Called by: LIS_ART        (procedure in ABMARTI.PRG)
*!
*!          Calls: M_CARTEL       (procedure in SIAAC1.PRG)
*!               : ESPERAR()      (function  in SIAAC1.PRG)
*!               : SPACE()        (function  in ?)
*!               : IIF()          (function  in ?)
*!               : CHR()          (function  in ?)
*!               : DTOC()         (function  in ?)
*!               : DATE()         (function  in ?)
*!               : STR()          (function  in ?)
*!
*!*********************************************************************
PROCEDURE ENCABE
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
@ LINEAS,15 SAY IIF(IMPRE,CHR(14),'         ') + ' * LISTADO DE ARTICULOS * '
@ LINEAS + 1,2 SAY 'Fecha: ' + DTOC(DATE())
@ LINEAS + 1,60 SAY 'Hoja Nro: ' + STR(HOJA,2,0)
@ LINEAS + 3,3 SAY 'Codigo   Descripcion                                            Unidad'
@ LINEAS + 4,1 SAY REPLICATE('=',79)
LINEAS = 6
HOJA = HOJA + 1
RETURN


function sele_rubA
*****************
*Selecciona Rubros
parameters f,c,t,R
M_POSI = 1
sele 13
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
       IF !MARCA
            IF COD_RUB = R
                M_POSI = I
            ENDIF
       ENDIF
       I = I + 1
       SKIP
   ENDDO
ENDIF
save screen to m_panta
Q = ventopcion('RUBROS',v_RUBROS,f,c,t,.t.,.t.,M_POSI)
restore screen from m_panta
if lastkey()=27
   return(0)
endif
SEEK V_COD[Q]
return(v_cod[Q])
