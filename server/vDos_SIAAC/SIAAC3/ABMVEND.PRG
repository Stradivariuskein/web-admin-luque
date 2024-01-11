*:*********************************************************************
*:
*:        Program: ABMVEND.PRG
*:
*:         System: SIAAC
*:         Author: D&D SISTEMAS
*:      Copyright (c) 1991, D&D SISTEMAS
*:  Last modified: 12/14/90     10:33
*:
*:  Procs & Fncts: PANTAVEN
*:               : BLANVARI
*:               : CARGA_VEN
*:               : GRABAVEN
*:               : MUESTRAVEN
*:
*:      Called by: ABM            (procedure in SIAAC1.PRG)
*:
*:          Calls: PANTAVEN       (procedure in ABMVEND.PRG)
*:               : VALVACIO()     (function  in SIAAC1.PRG)
*:               : LASTKEY()      (function  in ?)
*:               : FOUND()        (function  in ?)
*:               : SPACE()        (function  in ?)
*:               : BLANVARI       (procedure in ABMVEND.PRG)
*:               : CARGA_VEN      (procedure in ABMVEND.PRG)
*:               : GRABAVEN       (procedure in ABMVEND.PRG)
*:               : MUESTRAVEN     (procedure in ABMVEND.PRG)
*:               : M_CARTEL       (procedure in SIAAC1.PRG)
*:               : APRUEBA()      (function  in SIAAC1.PRG)
*:
*:           Uses: VENDEDOR.DBF
*:
*:        Indexes: VENDEDOR.IDX
*:
*:      Documented 09/23/91 at 19:02               FoxDoc  version 2.01
*:*********************************************************************
SELE 9
USE VENDEDOR INDEX VENDEDOR


PRIVATE M_CODVEN,LETRA,MARCA,M_NOM,M_DIR,M_TEL,M_LOC,M_CP,M_R1,M_R2,M_R3,M_R4
PRIVATE M_R5,M_R6,M_R7,M_R8,M_R9,M_R10,M_OBS,M_TEL,M_PROVI

DO WHILE .T.
   CLEAR
   DO PANTAVEN
   M_CODVEN=SPACE(10)
   @ 5,25 GET M_CODVEN PICT '@!'
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   SEEK M_CODVEN
   IF .NOT. FOUND()
      IF APRUEBA (22,0,38)
         @ 22,0 SAY SPACE(79)
         IF LASTKEY()=27
            LOOP
         ENDIF
         MARCA=.T.
         DO BLANVARI
         DO CARGA_VEN
         IF LASTKEY()=27
            LOOP
         ENDIF
         IF APRUEBA  (22,0,2)
            @ 22,0 SAY SPACE(79)
            APPEND BLANK
            DO GRABAVEN
         ENDIF
      ENDIF
   ELSE
      MARCA=.F.
      DO BLANVARI
      DO MUESTRAVEN
      DO M_CARTEL WITH 35,22,0,.T.,.T.,.T.
      LETRA='M'
      @ 22,66 GET LETRA PICT 'A' VALID LETRA = 'B' .OR. LETRA = 'M'
      READ
      @ 22,0 SAY SPACE(79)
      IF LASTKEY()=27
         LOOP
      ENDIF
      IF LETRA='M'
         DO CARGA_VEN
         IF APRUEBA(22,0,36)
            @ 22,0 SAY SPACE(79)
            DO GRABAVEN
         ENDIF
      ELSE
         IF APRUEBA(22,0,37)
            DELETE
            PACK
            LOOP
         ENDIF
      ENDIF
   ENDIF
ENDDO
CLOSE ALL
RETURN


*!*********************************************************************
*!
*!      Procedure: PANTAVEN
*!
*!      Called by: ABMVEND.PRG
*!
*!          Calls: M_CARTEL       (procedure in SIAAC1.PRG)
*!
*!*********************************************************************
PROCEDURE PANTAVEN
********* ********

* Muestra la pantalla de vendedores.


@ 1,1 TO 21,79 DOUBLE
SET COLOR TO I
@ 2,27  SAY " - ABM de VENDEDORES - "
SET COLOR TO
@ 3,2 TO 3,78
@ 5,3 SAY 'Codigo de Vendedor :'
@ 7,3 SAY 'Nombre             :'
@ 8,3 SAY 'Direcci¢n          :'
@ 9,3 SAY  'Localidad          :'
@ 10,3 SAY 'Provincia          :'
@ 11,3 SAY 'Telefono           :'
@ 12,3 SAY 'C¢digo Postal      :'
@ 13,3 SAY 'Observaciones      :'
@ 14,2 TO 14,78
SET COLOR TO I
@ 15,27 SAY "* PORCENTUALES x RUBRO *"
SET COLOR TO
@ 17,3 SAY 'A :'
@ 19,3 SAY 'B :'
@ 17,18 SAY 'C :'
@ 19,18 SAY 'D :'
@ 17,33 SAY 'E :'
@ 19,33 SAY 'F :'
@ 17,49 SAY 'G :'
@ 19,49 SAY 'H :'
@ 17,65 SAY 'I :'
@ 19,65 SAY 'J :'
DO M_CARTEL WITH 1,22,0,.T.,.F.,.T.
RETURN

*!*********************************************************************
*!
*!      Procedure: CARGA_VEN
*!
*!      Called by: ABMVEND.PRG
*!
*!          Calls: LASTKEY()      (function  in ?)
*!
*!*********************************************************************
PROCEDURE CARGA_VEN
*******************

* Carga de Datos del Cliente.

IF .NOT. MARCA
   SET COLOR TO I
   @ 5,25 SAY M_CODVEN PICT '99'
   SET COLOR TO
ENDIF
@ 7,25 GET M_NOM
@ 8,25 GET M_DIR
@ 9,25 GET M_LOC
@ 10,25 GET M_PROVI
@ 11,25 GET M_TEL
@ 12,25 GET M_CP PICT '9999'
@ 13,25 GET M_OBS PICT '@!S50'
@ 17,7 GET M_R1 PICT '999.99'
@ 19,7 GET M_R2 PICT '999.99'
@ 17,22 GET M_R3 PICT '999.99'
@ 19,22 GET M_R4 PICT '999.99'
@ 17,37 GET M_R5 PICT '999.99'
@ 19,37 GET M_R6 PICT '999.99'
@ 17,53 GET M_R7 PICT '999.99'
@ 19,53 GET M_R8 PICT '999.99'
@ 17,69 GET M_R9 PICT '999.99'
@ 19,69 GET M_R10 PICT '999.99'
READ
IF LASTKEY()=27
   RETURN
ENDIF
RETURN


*!*********************************************************************
*!
*!      Procedure: BLANVARI
*!
*!      Called by: ABMVEND.PRG
*!
*!          Calls: SPACE()        (function  in ?)
*!
*!*********************************************************************
PROCEDURE BLANVARI
******************

* Realiza el Blanqueo de las Variables, en el caso que se trate de una
* Baja o una Modificacion se cargan las Variables con los Datos del Archivo.
IF .NOT. MARCA
   M_NOM=NOMBRE
   M_DIR=DIRECC
   M_LOC=LOC
   M_CP=CP
   M_R1=RUBROA
   M_R2=RUBROB
   M_R3=RUBROC
   M_R4=RUBROD
   M_R5=RUBROE
   M_R6=RUBROF
   M_R7=RUBROG
   M_R8=RUBROH
   M_R9=RUBROI
   M_R10=RUBROJ
   M_TEL = TEL
   M_OBS = OBS
   M_PROVI = PROVI
ELSE
   M_NOM=SPACE(40)
   M_DIR=SPACE(30)
   M_LOC=SPACE(25)
   M_TEL = SPACE(30)
   M_OBS = SPACE(70)
   M_PROVI = SPACE(20)
   M_CP=0
   M_R1=0
   M_R2=0
   M_R3=0
   M_R4=0
   M_R5=0
   M_R6=0
   M_R7=0
   M_R8=0
   M_R9=0
   M_R10=0
ENDIF
RETURN


*!*********************************************************************
*!
*!      Procedure: GRABAVEN
*!
*!      Called by: ABMVEND.PRG
*!
*!*********************************************************************
PROCEDURE GRABAVEN
******************

* Grabacion del Registro.
REPLACE COD_VEND WITH M_CODVEN
REPLACE NOMBRE WITH M_NOM
REPLACE DIRECC WITH M_DIR
REPLACE LOC WITH M_LOC
REPLACE CP WITH M_CP
REPLACE TEL WITH M_TEL
REPLACE OBS WITH M_OBS
REPLACE RUBROA WITH M_R1
REPLACE RUBROB WITH M_R2
REPLACE RUBROC WITH M_R3
REPLACE RUBROD WITH M_R4
REPLACE RUBROE WITH M_R5
REPLACE RUBROF WITH M_R6
REPLACE RUBROG WITH M_R7
REPLACE RUBROH WITH M_R8
REPLACE RUBROI WITH M_R9
REPLACE RUBROJ WITH M_R10
REPLACE PROVI WITH M_PROVI
RETURN

*!*********************************************************************
*!
*!      Procedure: MUESTRAVEN
*!
*!      Called by: ABMVEND.PRG
*!
*!          Calls: LASTKEY()      (function  in ?)
*!
*!*********************************************************************
PROCEDURE MUESTRAVEN
********************

* En Baja o Modificacion se Displayan los Datos del Cliente
SET COLOR TO I
@ 7,25 SAY M_NOM
SET COLOR TO
@ 9,25 SAY M_DIR
@ 11,25 SAY M_LOC
@ 13,25 SAY M_CP PICT '9999'
@ 17,7 SAY M_R1 PICT'999.99'
@ 19,7 SAY M_R2 PICT'999.99'
@ 17,22 SAY M_R3 PICT'999.99'
@ 19,22 SAY M_R4 PICT'999.99'
@ 17,37 SAY M_R5 PICT'999.99'
@ 19,37 SAY M_R6 PICT'999.99'
@ 17,53 SAY M_R7 PICT'999.99'
@ 19,53 SAY M_R8 PICT'999.99'
@ 17,69 SAY M_R9 PICT'999.99'
@ 19,69 SAY M_R10 PICT'999.99'
IF LASTKEY()=27
   RETURN
ENDIF
RETURN
*: EOF: ABMVEND.PRG
