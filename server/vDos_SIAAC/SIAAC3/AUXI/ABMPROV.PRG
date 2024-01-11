*IF !SEGURIDAD(MM_CLAVE,'R')
*   DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*   ESPERAR(0)
*   RETURN
*ENDIF

PARAMETERS CIERRA

IF CIERRA
   SELE 12
   USE PROVEDOR INDEX PROVEDOR
ENDIF

PRIVATE M_CODPRO,LETRA,MARCA,M_NOM,M_DIR,M_TEL,M_LOC,M_CP,M_CUIT,M_IVA,M_CPA
PRIVATE M_PP,M_OBS,M_SAL,M_FECH,M_NOMBRE
SELE 12
GO BOTTOM
M_PRO = COD_PRO

DO WHILE .T.
   SELE 12
   CLEAR
   DO TITULO
   DO PANTAPRO
   @ 5,25 GET M_PRO PICT '@!'
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   SEEK M_PRO
   IF .NOT. FOUND()
      @ 24,0 SAY SPACE(79)
      IF APRUEBA (24,0,52)
         @ 24,0 SAY SPACE(79)
         MARCA=.T.
         DO BLANVARIA
         DO CARGA_PRO
         @ 24,0 SAY SPACE(79)
         IF APRUEBA  (24,0,2)
            @ 24,0 SAY SPACE(79)
            SELE 12
            APPEND BLANK
            DO GRABAPRO
         ENDIF
      ENDIF
   ELSE
      MARCA=.F.
      DO BLANVARIA
      DO MUESTRAPRO
      DO M_CARTEL WITH 35,24,0,.T.,.T.,.T.
      LETRA='M'
      @ 24,66 GET LETRA PICT 'A' VALID LETRA = 'B' .OR. LETRA = 'M'
      READ
      @ 24,0 SAY SPACE(79)
      IF LASTKEY()=27
         LOOP
      ENDIF
      IF LETRA='M'
         DO CARGA_PRO
         IF LASTKEY()=27
            LOOP
         ENDIF
         IF APRUEBA(24,0,36)
            @ 24,0 SAY SPACE(79)
            DO GRABAPRO
         ENDIF
      ELSE
         IF APRUEBA(24,0,37)
            DELETE
            PACK
            LOOP
         ENDIF
      ENDIF
   ENDIF
ENDDO
IF CIERRA
   CLOSE ALL
ENDIF
RETURN


PROCEDURE PANTAPRO
********* ********

* Muestra la pantalla de clientes.


@ 1,1 TO 23,79 DOUBLE
SET COLOR TO I
@ 2,30  SAY " - ABM de PROVEEDORES - "
SET COLOR TO
@ 3,2 TO 3,78
@ 5,3 SAY 'Codigo de Proveedor :'
@ 7,3 SAY 'Nombre            :'
@ 9,3 SAY 'Direcci¢n         :'
@ 11,3 SAY 'Telefono          :'
@ 12,2 TO 12,78
@ 13,3 SAY 'Localidad         :'
@ 15,3 SAY 'C¢digo Postal     :'
@ 17,3 SAY 'CUIT              :'
@ 19,3 SAY 'IVA               :'
@ 13,41 SAY 'Condiciones de Pago :'
@ 15,41 SAY 'Porcentaje de Pago :'
@ 17,41 SAY 'Fecha de Saldo     :'
@ 19,41 SAY 'Saldo              :'
@ 21,9 SAY     'Observaciones :'
DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
RETURN

PROCEDURE CARGA_PRO
*******************

* Carga de Datos del Provedor.

SELE 12
IF .NOT. MARCA
   SET COLOR TO I
   @ 5,25 SAY M_PRO PICT '999'
   SET COLOR TO
ENDIF
@ 7,23 GET M_NOM
@ 9,23 GET M_DIR
@ 11,23 GET M_TEL
@ 13,23 GET M_LOC PICT '@!S15'
@ 15,23 GET M_CP PICT '9999'
@ 17,23 GET M_CUIT PICT '@!S15'
@ 19,23 GET M_IVA PICT '@!S15'
@ 13,63 GET  M_CPA PICT '#####'
@ 15,62 GET M_PP PICT '#####.##'
@ 17,62 GET M_FECH PICT '99/99/99'VALID VALFECH(M_FECH)
@ 19,62 GET M_SAL PICT '99,999,999.99'
@ 21,25 GET M_OBS
READ
IF LASTKEY()=27
   RETURN
ENDIF
RETURN


PROCEDURE BLANVARIA
*******************
* Realiza el Blanqueo de las Variables, en el caso que se trate de una
* Baja o una Modificacion se cargan las Variables con los Datos del Archivo.
SELE 12
IF MARCA
   M_NOM=SPACE(40)
   M_DIR=SPACE(30)
   M_TEL=SPACE(50)
   M_LOC=SPACE(25)
   M_CP=0
   M_CUIT=SPACE(20)
   M_IVA=SPACE(20)
   M_CPA=0
   M_PP=0
   M_OBS=SPACE(50)
   M_FECH=DATE()
   M_SAL=0
ELSE
   M_NOM=NOMBRE
   M_DIR=DIRECC
   M_TEL=TEL
   M_LOC=LOC
   M_CP=CP
   M_CUIT=CUIT
   M_IVA=IVA
   M_CPA=CPA
   M_PP=POR_PAGO
   M_OBS=OBSERVA
   M_FECH=FECH_SAL
   M_SAL=SALDO
ENDIF
RETURN


PROCEDURE GRABAPRO
******************
* Grabacion del Registro.
REPLACE COD_PRO WITH M_PRO
REPLACE NOMBRE WITH M_NOM
REPLACE DIRECC WITH M_DIR
REPLACE TEL WITH M_TEL
REPLACE LOC WITH M_LOC
REPLACE CP WITH M_CP
REPLACE CUIT WITH M_CUIT
REPLACE IVA WITH M_IVA
REPLACE CPA WITH M_CPA
REPLACE POR_PAGO WITH M_PP
REPLACE OBSERVA WITH M_OBS
REPLACE FECH_SAL WITH M_FECH
REPLACE SALDO WITH M_SAL
RETURN


PROCEDURE MUESTRAPRO
********************
* En Baja o Modificacion se Displayan los Datos del Cliente
SET COLOR TO I
@ 7,23 SAY M_NOM
SET COLOR TO
@ 9,23 SAY M_DIR
@ 11,23 SAY M_TEL
@ 13,23 SAY SUBSTR(M_LOC,1,15)
@ 15,23 SAY M_CP
@ 17,23 SAY SUBSTR(M_CUIT,1,15)
@ 19,23 SAY SUBSTR(M_IVA,1,15)
@ 13,63 SAY M_CPA
@ 15,62 SAY M_PP
@ 17,62 SAY M_FECH
@ 19,62 SAY M_SAL
@ 21,25 SAY M_OBS
IF LASTKEY()=27
   RETURN
ENDIF
RETURN


PROCEDURE LIS_PROV
******************
*Listado de Proveedores

SELE 12
USE PROVEDOR
INDEX ON NOMBRE TO M_AUXILI

IMPRE = .F.
IF APRUEBA(24,0,11)
   IMPRE = .T.
ENDIF
IF LASTKEY() = 27
   RETURN
ENDIF
DO M_CARTEL WITH 10,24,0,.T.,.T.,.T.
ESPERAR(0)
IF LASTKEY() = 27
   RETURN
ENDIF
IF IMPRE
   SET DEVICE TO PRINT
   @ PROW(),PCOL() SAY CHR(18)
ENDIF
GO TOP
LINEAS = 66
PRIMERA = .T.
HOJA = 1
DO WHILE !EOF()
   IF LINEAS > 65 .AND. IMPRE
      DO ENC_PROV
   ELSE
      IF LINEAS > 20 .AND. !IMPRE
         DO ENC_PROV
      ENDIF
   ENDIF
   @ LINEAS,2 SAY COD_PRO + '   ' + SUBSTR(NOMBRE,1,20) + ' ' + SUBSTR(DIRECC,1,20) + ' ' + SUBSTR(LOC,1,10) + '     ' + TEL
   SKIP
   LINEAS = LINEAS + 1
ENDDO
IF IMPRE
   EJECT
   SET DEVICE TO SCREEN
ELSE
   @ 22,3 SAY 'Pulse Cualquier Tecla Para Continuar ...'
   ESPERAR(0)
ENDIF
CLOSE ALL
RETURN


PROCEDURE ENC_PROV
******************
*Encabezamiento del Listado

IF !PRIMERA
   IF IMPRE
      EJECT
   ELSE
      @ 22,3 SAY 'Pulse Cualquier Tecla Para Continuar ...'
      ESPERAR(0)
      @ 9,2 CLEAR TO 24,79
   ENDIF
ELSE
   PRIMERA = .F.
   IF !IMPRE
      @ 1,0 CLEAR TO 24,79
   ENDIF
ENDIF
LINEAS = 1
@ LINEAS,15 SAY IIF(IMPRE,CHR(14),'       ') + '* LISTADO DE PROVEEDORES * '
@ LINEAS + 2,2 SAY 'Fecha: ' + DTOC(DATE())
@ LINEAS + 2,50 SAY 'Hoja Nro : ' + STR(HOJA,1,2)
@ LINEAS + 4,1 SAY 'Nro.   Nombre                 Direccion y Localidad              T.E.'
HOJA = HOJA + 1
@ LINEAS + 5,2 SAY REPLICATE('=',77)
LINEAS = 7
RETURN
*: EOF: ABMPROV.PRG
