PRIVATE M_CLI,LETRA,MARCA,M_NOM,M_DIR,M_TEL,M_LOC,M_CP,M_CUIT,M_IVA,M_AT,M_ACTIVO
PRIVATE M_VEN,M_OBS,M_SAL,M_FECH,M_COND,M_PORC,M_DOMENT,M_NPROV,M_CANTS,M_TIPOC,M_EXPRES,M_ESPEC,M_INSCRIP,M_COND2,M_PORC2,M_QLIST,M_ZONA
PRIVATE M_COND1,M_COND2,M_COND3,M_COND4,M_COND5,M_RUBRO,M_FRASE,M_OBS1,M_OBS2,M_OBS3,M_OBS4,M_OBS5,M_OBS6
V_PORC = ARRAY(15)

R5 = .F.
DO WHILE .T.
   SELE 11
   CLEAR
   DO PANTACLI WITH R5
   SELE 11
   USE CLIENTES INDEX CLIENTES
   GO BOTTOM
   M_CLI = COD_CLI

   SELE 19
   USE DOMICILI  INDEX DOMICILI

   SELE 22
   USE PROVI INDEX PROVI

   @ 5,23 GET M_CLI PICT '@!'
   READ
   IF LASTKEY() = 27
      EXIT
   ENDIF
   SELE 11
   SEEK M_CLI
   IF .NOT. FOUND()
      IF APRUEBA (24,0,34)
         @ 24,0 SAY SPACE(79)
         MARCA=.T.
         DO BLANVAR
         DO CARGA_CLI
         IF LASTKEY() = 27
            EXIT
         ENDIF
         SELE 11
         @ 24,0 SAY SPACE(79)
         IF APRUEBA  (24,0,2)
            @ 24,0 SAY SPACE(79)
            APPEND BLANK
            DO GRABA WITH .T.
            IF M_CANTS <> 0
               DO CARGA_DOM
            ENDIF
         ENDIF
      ENDIF
   ELSE
      MARCA=.F.
      DO BLANVAR
      DO MUESTRACLI
      DO M_CARTEL WITH 35,24,0,.T.,.F.,.T.
      LETRA='M'
      @ 24,66 GET LETRA PICT 'A' VALID LETRA = 'B' .OR. LETRA = 'M'
      READ
      @ 24,0 SAY SPACE(79)
      IF LASTKEY()=27
         LOOP
      ENDIF
      IF LETRA='M'
         DO CARGA_CLI
         IF LASTKEY()=27
            LOOP
         ENDIF
         IF APRUEBA(24,0,36)
            @ 24,0 SAY SPACE(79)
            DO GRABA WITH .F.
            IF M_CANTS <> 0
               DO CARGA_DOM
            ENDIF
         ENDIF
      ELSE
         IF APRUEBA(24,0,37)
            IF SALDO <> 0
                DO M_CARTEL WITH 104,24,0,.T.,.T.,.T.
                ESPERAR(0)
                LOOP
            ENDIF
            SELE 11
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
*!      Procedure: PANTACLI
*!
*!      Called by: ABMCLI.PRG
*!
*!          Calls: M_CARTEL       (procedure in SIAAC1.PRG)
*!
*!*********************************************************************
PROCEDURE PANTACLI
********* ********
PARAMETERS COB
* Muestra la pantalla de clientes.
IF COB
   @ 1,1 TO 23,79
ELSE
   @ 1,1 TO 23,79 DOUBLE
ENDIF
SET COLOR TO I
@ 2,30  SAY " - ABM de CLIENTES - "
SET COLOR TO
@ 3,2 TO 3,78
@ 5,3 SAY 'Codigo de Cliente :'
@ 7,3 SAY 'Nombre            :'
@ 9,3 SAY 'Direcci¢n         :'
@ 11,3 SAY 'Telefono          :'
@ 12,2 TO 12,78
@ 13,3 SAY 'Localidad         :'
@ 15,3 SAY 'C¢digo Postal     :'
@ 17,3 SAY 'CUIT              :'
@ 19,3 SAY 'IVA               :'
@ 13,41 SAY 'Atendido por       :'
@ 15,41 SAY 'C¢digo de Vendedor :'
@ 17,41 SAY 'Fecha de Saldo     :'
@ 19,41 SAY 'Saldo              :'
@ 21,3 SAY  'Observaciones :'
@ 22,3 SAY  'Provincia      :'
DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
RETURN

*!*********************************************************************
*!
*!      Procedure: PANT_CLI2
*!
*!      Called by: CARGA_CLI      (procedure in ABMCLI.PRG)
*!
*!          Calls: TITULO         (procedure in SIAAC1.PRG)
*!               : RTRIM()        (function  in ?)
*!
*!*********************************************************************
PROCEDURE PANT_CLI2
********* *********
PARAMETERS COB
*2da. Pantalla de Clientes
CLEAR
DO TITULO
SET COLOR TO I
@ 2,30 SAY RTRIM(M_NOM)
SET COLOR TO
@ 4,1 TO 4,78
IF !COB
   @ 1,0 TO 23,78 DOUBLE
ELSE
   @ 1,0 TO 23,78
ENDIF
@ 6,2 SAY 'N£mero de Proveedor    : '
@ 8,2 SAY 'Cantidad de Sucursales : '
@ 10,2 SAY 'Codigos de Expresos   : '
@ 11,2 SAY 'Especial S/N          : '
@ 12,2 SAY 'Responsable Inscripto : '
@ 13,2 SAY 'Numero de Lista p/Vta.: '
@ 14,2 SAY 'Zona                  : '
@ 15,2 SAY 'Rubro Comision (A/B)  : '
@ 16,2 SAY 'Condiciones           : '
@ 17,1 SAY 'Obs. Especiales       : '
@ 18,1 SAY 'Obs. Especiales       : '
@ 19,1 SAY 'Obs. Especiales       : '
@ 20,1 SAY 'Obs. Especiales       : '
@ 21,1 SAY 'Obs. Especiales       : '
@ 22,1 SAY 'Obs. Especiales       : '
RETURN

PROCEDURE CARGA_CLI
*******************
* Carga de Datos del Cliente.

IF .NOT. MARCA
   SET COLOR TO I
   @ 5,23 SAY M_CLI PICT '99999'
   SET COLOR TO
ENDIF
@ 7,23 GET M_NOM
@ 9,23 GET M_DIR
@ 11,23 GET M_TEL
@ 13,23 GET M_LOC PICT '@!S15'
@ 15,23 GET M_CP PICT '9999'
@ 17,23 GET M_CUIT PICT '@!S15'
@ 19,23 GET M_IVA PICT '@!S15'
@ 13,62 GET  M_AT PICT '@!S15'
@ 15,62 GET M_VEN PICT  '@!S2'
@ 17,62 GET M_FECH PICT '99/99/99'VALID VALFECH(M_FECH)
@ 19,62 GET M_SAL PICT '99,999,999.99'
@ 21,25 GET M_OBS
@ 22,25 GET M_TIPOC PICT '##' VALID VALPROVI(M_TIPOC,22,30)
READ
IF LASTKEY()=27
   RETURN
ENDIF
DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
ESPERAR(0)
DO PANT_CLI2 WITH R5
DO CARGA_CLI2
RETURN

PROCEDURE CARGA_CLI2
********************

@ 6,38 GET M_NPROV PICT '@!'
@ 8,38 GET M_CANTS PICT '###' VALID M_CANTS >= 0
@ 10,38 GET M_EXPRES PICT '@!'
@ 11,38 GET M_ESPEC PICT 'A' VALID M_ESPEC = 'S' .OR. M_ESPEC = 'N'
@ 12,38 GET M_INSCRIP
@ 13,38 GET M_QLIST PICT '#' VALID M_QLIST >= 1 .AND. M_QLIST <= 5
@ 14,38 GET M_ZONA PICT '@!'
@ 15,38 GET M_RUBRO PICT 'A' VALID M_RUBRO = 'A' .OR. M_RUBRO = 'B'
@ 16,38 GET M_FRASE PICT '@!'
@ 17,38 GET M_OBS1 PICT '@S35'
@ 18,38 GET M_OBS2 PICT '@S35'
@ 19,38 GET M_OBS3 PICT '@S35'
@ 20,38 GET M_OBS4 PICT '@S35'
@ 21,38 GET M_OBS5 PICT '@S35'
@ 22,38 GET M_OBS6 PICT '@S35'
READ
IF LASTKEY() = 27
   RETURN
ENDIF
DO CARGA_CLI3
RETURN


PROCEDURE BLANVAR
*****************

* Realiza el Blanqueo de las Variables, en el caso que se trate de una
* Baja o una Modificacion se cargan las Variables con los Datos del Archivo.
IF MARCA
   M_NOM=SPACE(40)
   M_DIR=SPACE(30)
   M_TEL=SPACE(50)
   M_LOC=SPACE(25)
   M_CP=0
   M_ZONA = SPACE(10)
   M_CUIT=SPACE(20)
   M_IVA=SPACE(20)
   M_FRASE = SPACE(40)
   M_RUBRO = 'A'
   M_AT=SPACE(30)
   M_VEN=SPACE(10)
   M_OBS=SPACE(50)
   M_FECH=DATE()
   M_SAL=0
   M_NPROV = SPACE(10)
   M_CANTS = 0
   M_TIPOC = 1
   M_EXPRES = SPACE(20)
   M_ESPEC = 'N'
   M_INSCRIP = 'S'
   M_QLIST = 1
   M_ACTIVO = 'S'
   STOR 0 TO M_COND1,M_COND2,M_COND3,M_COND4,M_COND5
   STOR SPACE(70) TO M_OBS1,M_OBS2,M_OBS3,M_OBS4,M_OBS5,M_OBS6
   AFILL(V_PORC,0)
ELSE
   M_NOM=NOMBRE
   M_DIR=DIRECC
   M_ZONA = ZONA
   M_TEL=TEL
   M_LOC=LOC
   M_FRASE = FRASE
   M_CP=CP
   M_RUBRO = RUBRO
   M_CUIT=CUIT
   M_IVA=IVA
   M_AT=AT
   M_VEN=COD_VEND
   M_OBS=OBSERVA
   M_FECH=FECH_SAL
   M_SAL=SALDO
   M_NPROV = NPROV
   M_CANTS = CANTS
   M_TIPOC = TIPO_CLI
   M_ESPEC = ESPEC
   M_OBS1 = OBS1
   M_OBS2 = OBS2
   M_OBS3 = OBS3
   M_OBS4 = OBS4
   M_OBS5 = OBS5
   M_OBS6 = OBS6
   M_EXPRES = EXPRES
   M_INSCRIP = INSCRIP
   M_QLIST = QLIST
   M_ACTIVO = ACTIVO
   M_COND1 = COND1
   M_COND2 = COND2
   M_COND3 = COND3
   M_COND4 = COND4
   M_COND5 = COND5
   FOR I = 1 TO 15
       IF I < 10
           M_PORC = 'PORC' + STR(I,1,0)
       ELSE
           M_PORC = 'PORC' + STR(I,2,0)
       ENDIF
       V_PORC[I] = &M_PORC
   NEXT
ENDIF
RETURN


PROCEDURE GRABA
***************
PARAMETERS ALTA

* Grabacion del Registro.
SELE 11
M_AUXIL = CANTS
if rlock()
REPLACE COD_CLI WITH M_CLI
REPLACE NOMBRE WITH M_NOM
REPLACE DIRECC WITH M_DIR
REPLACE FRASE WITH M_FRASE
REPLACE TEL WITH M_TEL
REPLACE RUBRO WITH M_RUBRO
REPLACE LOC WITH M_LOC
REPLACE CP WITH M_CP
REPLACE CUIT WITH M_CUIT
REPLACE IVA WITH M_IVA
REPLACE AT WITH M_AT
REPLACE COD_VEND WITH M_VEN
REPLACE OBSERVA WITH M_OBS
REPLACE ZONA WITH M_ZONA
REPLACE FECH_SAL WITH M_FECH
REPLACE SALDO WITH M_SAL
REPLACE NPROV  WITH M_NPROV
REPLACE CANTS WITH M_CANTS
REPLACE TIPO_CLI WITH M_TIPOC
REPLACE ESPEC WITH M_ESPEC
REPLACE EXPRES WITH M_EXPRES
REPLACE INSCRIP WITH M_INSCRIP
REPLACE QLIST WITH M_QLIST
REPLACE ACTIVO WITH M_ACTIVO
REPLACE COND1 WITH M_COND1
REPLACE COND2 WITH M_COND2
REPLACE COND3 WITH M_COND3
REPLACE COND4 WITH M_COND4
REPLACE COND5 WITH M_COND5
REPLACE OBS1 WITH M_OBS1
REPLACE OBS2 WITH M_OBS2
REPLACE OBS3 WITH M_OBS3
REPLACE OBS4 WITH M_OBS4
REPLACE OBS5 WITH M_OBS5
REPLACE OBS6 WITH M_OBS6
FOR I = 1 TO 15
    IF I < 10
        M_PORC = 'PORC' + STR(I,1,0)
    ELSE
        M_PORC = 'PORC' + STR(I,2,0)
    ENDIF
    REPLACE &M_PORC WITH V_PORC[I]
NEXT
unlock
endif

IF ALTA
   SELE 19
   IF M_CANTS <> 0
      FOR Q = 1 TO M_CANTS + 1
         APPEND BLANK
         REPLACE CLIENTE WITH M_CLI
         REPLACE SUCURSAL WITH Q
         IF Q = 1
            REPLACE DOMENT WITH 'MISMO DOMICILIO'
         ELSE
            REPLACE DOMENT WITH ''
         ENDIF
         REPLACE CDOMENT WITH 0
         REPLACE SUCLOC WITH ''
      NEXT
   ENDIF
ELSE
   IF M_CANTS > M_AUXIL
      FOR Q = M_AUXIL + 1 TO M_CANTS
         SELE 19
         APPEND BLANK
         REPLACE CLIENTE WITH M_CLI
         REPLACE SUCURSAL WITH Q
         IF Q = 1
            REPLACE DOMENT WITH 'MISMO DOMICILIO'
         ELSE
            REPLACE DOMENT WITH ''
         ENDIF
         REPLACE CDOMENT WITH 0
         REPLACE SUCLOC WITH ''
      NEXT
   ENDIF
ENDIF
RETURN

PROCEDURE MUESTRACLI
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
@ 13,62 SAY  SUBSTR(M_AT,1,15)
@ 15,62 SAY M_VEN
@ 17,62 SAY M_FECH
@ 19,62 SAY M_SAL
@ 21,25 SAY M_OBS
IF LASTKEY()=27
   RETURN
ENDIF
RETURN


PROCEDURE LIS_CLI
*****************
*Listado de Clientes
PARAMETERS ORDEN

@ 20,0 CLEAR TO 24,79
@ 20,0 TO 23,79
M_DESDE = SPACE(10)
M_HASTA = SPACE(10)
M_ZONA = SPACE(10)
@ 21,2 SAY 'Desde Cliente : ' GET M_DESDE PICT '@!'
@ 21,52 SAY 'Hasta Cliente : ' GET M_HASTA PICT '@!'
@ 22,2 SAY 'Zona (9999999999 = TODAS) : ' GET M_ZONA PICT '@!'
READ
IF LASTKEY() = 27
   RETURN
ENDIF

SELE 21
USE EXPRESO INDEX EXPRESO

SELE 25
USE VENDEDOR INDEX VENDEDOR

SELE 11
USE CLIENTES INDEX CLIENTES

SELE 22
USE PROVI INDEX PROVI

SELE 11
IF ORDEN = 'A'
   INDEX ON NOMBRE TO AUXILI0
ELSE
   IF ORDEN = 'D'
      INDEX ON DIRECC TO AUXILI0
   ENDIF
ENDIF

IMPRE = .F.
IF APRUEBA(24,0,11)
   IMPRE = .T.
ENDIF

DO M_CARTEL WITH 10,24,0,.T.,.F.,.T.
ESPERAR(0)
IF LASTKEY() = 27
    RETURN
ENDIF
IF IMPRE
   SET DEVI TO PRINT
ENDIF

GO TOP
LINEAS = 70
PRIMERA = .T.
HOJA = 1
DO WHILE !EOF()
   IF LINEAS > 65 .AND. IMPRE
      DO ENCABE_CLI
   ELSE
      IF LINEAS > 20 .AND. !IMPRE
         DO ENCABE_CLI
         IF LASTKEY() = 27
             EXIT
         ENDIF
      ENDIF
   ENDIF
   IF M_ZONA <> '9999999999'
       IF M_ZONA <> ZONA
           SKIP
           LOOP
       ENDIF
   ENDIF
   IF COD_CLI >= M_DESDE .AND. COD_CLI <= M_HASTA
      IF IMPRE
         M_EXPRESO = BUSCA_EXPRE()
         SELE 25
         SEEK CLIENTES->COD_VEND
         SELE 22
         SEEK CLIENTES->TIPO_CLI
         SELE 11
         @ LINEAS,1 SAY CHR(15) + 'Cod: ' + COD_CLI + ' Nom: ' + NOMBRE +  ' Dir: ' + DIRECC
         @ LINEAS+1,1 SAY  'Loc: ' + LOC + 'Cp' + STR(CP,4,0) + '  Tel: ' + TEL + ' CUIT ' + CUIT + ' Resp. ' + IIF(INSCRIP='S','Inscripto','No Inscripto')
         @ LINEAS+2,1 SAY 'Provincia : ' + PROVI->NOMBRE
         @ LINEAS+3,1 SAY 'Expreso : ' + M_EXPRESO + ' ' + 'Vendedor : ' + VENDEDOR->NOMBRE
         @ LINEAS+4,1 SAY REPLICATE('=',136)
         LINEAS = LINEAS + 5
      ELSE
         M_EXPRESO = BUSCA_EXPRE()
         SELE 25
         SEEK CLIENTES->COD_VEND
         SELE 11
         @ LINEAS,1 SAY COD_CLI + ' ' + SUBSTR(NOMBRE,1,30) + ' ' + SUBSTR(TEL,1,20)
         @ LINEAS+1,1 SAY 'Expreso: ' + SUBSTR(M_EXPRESO,1,20) + ' Vendedor: ' + VENDEDOR->NOMBRE
         @ LINEAS+2,1 SAY REPLICATE('=',79)
         LINEAS = LINEAS + 3
      ENDIF
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
ENDIF
ERASE C:\SIAAC\AUXILI0.NTX
CLOSE ALL
RETURN

PROCEDURE ENCABE_CLI
********************

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
IF IMPRE
   @ PROW(),PCOL() SAY CHR(15)
ENDIF

LINEAS = 1
@ LINEAS,35 SAY IIF(IMPRE,CHR(14),'') + ' * LISTADO DE CLIENTES * '
@ LINEAS + 1,2 SAY 'Fecha: ' + DTOC(DATE())
IF IMPRE
   @ LINEAS + 1,100 SAY 'Hoja Nro: ' + STR(HOJA,2,0)
   @ LINEAS + 2,1 SAY 'Zona : ' + IIF(M_ZONA = '9999999999','TODAS',M_ZONA)
ELSE
   @ LINEAS + 1,60 SAY 'Hoja Nro: ' + STR(HOJA,2,0)
   @ LINEAS + 2,1 SAY 'Zona : ' + IIF(M_ZONA = '9999999999','TODAS',M_ZONA)
   @ LINEAS + 3,3 SAY ' Codigo     Nombre                   Telefono'
ENDIF
@ LINEAS + 4,1 SAY IIF(IMPRE,REPLICATE('=',136),REPLICATE('=',79))
LINEAS = 6
HOJA = HOJA + 1
RETURN

FUNCTION BUSCA_EXPRE
********************

SELE 21
SET EXACT ON
M_A=''
AS = 1
FOR J = 1 TO 20
    IF SUBSTR(CLIENTES->EXPRES,J,1) <> ' '
          M_A = M_A + SUBSTR(CLIENTES->EXPRES,J,1)
    ELSE
          IF M_A = ''
             M_A = ' '
          ENDIF
          SEEK M_A
          IF FOUND()
             RETURN(NOMBRE)
          ELSE
             RETURN('')
          ENDIF
    ENDIF
NEXT


PROCEDURE CARGA_DOM
********************
SELE 19
SEEK M_CLI + '  1'

CONT_DOMI = 1
DO WHILE .T.
   IF CONT_DOMI > CLIENTES->CANTS
      EXIT
   ENDIF
   M_DOMENT = DOMENT
   M_CDOMENT = CDOMENT
   M_SUCLOC = SUCLOC
   CLEAR
   @ 1,0 TO 14,79 DOUBLE
   SET COLOR TO I
   @ 3,25 SAY ' * DOMICILIOS DE ENTREGA * '
   SET COLOR TO
   @ 4,1 TO 4,78
   @ 13,40 SAY 'Domicilio : ' + STR(CONT_DOMI,3,0)
   @ 6,2 SAY 'Domicilio de Entrega : ' GET M_DOMENT PICT '@!'
   @ 8,2 SAY 'Localidad            : ' GET M_SUCLOC PICT '@!'
   @ 10,2 SAY 'C¢digo Postal        : ' GET M_CDOMENT PICT '####' VALID M_CDOMENT >= 0
   READ
   IF LASTKEY() = 27
      EXIT
   ENDIF
   IF APRUEBA(24,0,2)
      if rlock()
      REPLACE CLIENTE WITH M_CLI
      REPLACE DOMENT WITH M_DOMENT
      REPLACE CDOMENT WITH M_CDOMENT
      REPLACE SUCLOC WITH M_SUCLOC
      unlock
      endif
      SKIP
      CONT_DOMI = CONT_DOMI + 1
   ENDIF
ENDDO
RETURN
*: EOF: ABMCLI.PRG


PROCEDURE CARGA_CLI3
********************
*Carga Condiciones de Pago

CLEAR
@ 1,0 TO 23,79 DOUBLE
DO TITULO
DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
SET COLOR TO I
@ 2,25 SAY M_NOM
SET COLOR TO
@ 5,1 TO 5,78
SET COLOR TO W+
@ 6,30 SAY 'CONDICIONES DE PAGO'
SET COLOR TO

@ 10,2 SAY 'Dias  : ' GET M_COND1 PICT '###'
@ 10,40 SAY '% Bonif : '
@ 10,50 GET V_PORC[1] PICT '###.##'
@ 10,58 GET V_PORC[2] PICT '###.##'
@ 10,66 GET V_PORC[3] PICT '###.##'

@ 12,2 SAY 'Dias  : ' GET M_COND2 PICT '###'
@ 12,40 SAY '% Bonif : '
@ 12,50 GET V_PORC[4] PICT '###.##'
@ 12,58 GET V_PORC[5] PICT '###.##'
@ 12,66 GET V_PORC[6] PICT '###.##'

@ 14,2 SAY 'Dias  : ' GET M_COND3 PICT '###'
@ 14,40 SAY '% Bonif : '
@ 14,50 GET V_PORC[7] PICT '###.##'
@ 14,58 GET V_PORC[8] PICT '###.##'
@ 14,66 GET V_PORC[9] PICT '###.##'

@ 16,2 SAY 'Dias  : ' GET M_COND4 PICT '###'
@ 16,40 SAY '% Bonif : '
@ 16,50 GET V_PORC[10] PICT '###.##'
@ 16,58 GET V_PORC[11] PICT '###.##'
@ 16,66 GET V_PORC[12] PICT '###.##'

@ 18,2 SAY 'Dias  : ' GET M_COND5 PICT '###'
@ 18,40 SAY '% Bonif : '
@ 18,50 GET V_PORC[13] PICT '###.##'
@ 18,58 GET V_PORC[14] PICT '###.##'
@ 18,66 GET V_PORC[15] PICT '###.##'
READ
IF LASTKEY() = 27
   RETURN
ENDIF
RETURN

PROCEDURE ENVIO
***************

sele 2
use provi index provi


SELE 1
USE CLIENTES INDEX CLIENTES

DO WHILE .T.
     CLEAR
     @ 1,0 TO 23,79 DOUBLE
     @ 3,30 SAY 'EMISION de NOTAS de ENVIO PARA CLIENTES'
     @ 5,1 TO 5,78
     M_CLIENTE = SPACE(10)
     M_COPIAS = 1
     @ 8,3 SAY  'Cliente : ' GET M_CLIENTE
     @ 10,3 say 'Copias  : ' get m_copias pict '#'
     READ
     IF LASTKEY() = 27
          EXIT
     ENDIF
     SELE 1
     SEEK M_CLIENTE
     IF FOUND()
        SET COLOR TO I
        @ 8,40 SAY SUBSTR(NOMBRE,1,37)
        SET COLOR TO
     ELSE
        DO M_CARTEL WITH 40,24,0,.T.,.T.,.T.
        ESPERAR(0)
        LOOP
     ENDIF
     sele 2
     seek clientes->tipo_cli
     m_nompro = nombre
     sele 1
     M_NOMBRE = NOMBRE
     M_DIRECC = DIRECC
     M_LOC = LOC
     M_EXPRESO = EXPRES
     @ 12,3 SAY 'Expreso : ' get m_expreso
     read
     IF APRUEBA(24,0,2)
            SET PRINT ON
            LINEAS = 0
            for i = 1 to M_COPIAS
                ? CHR(14) + 'ENVIO'
                ? CHR(14) + '          ANTONIO LUQUE S.A.I. y C.'
                ? '   Fabricacion de herrajes'
                ? '  Herramientas de Ferreteria'
                ? 'E. Porrini 217 - 1702 - Ciudadela - Tel. 653-3006'
                ? replicate('-',80)
                ?
                ? 'Se¤or(es)   : ' + m_nombre
                ?
                ? 'Domicilio   : ' + m_direcc
                ?
                ? 'Localidad   : ' + m_loc
                ?
                ? 'Provincia   : ' + m_nompro
                ?
                ? 'Expreso     : ' + m_expreso
                ?
                ?
                ?
                ?
                ?
                ?
                ? REPLICATE('*',80)
                LINEAS = LINEAS + 1
                IF LINEAS >= 3
                     EJECT
                     LINEAS = 0
                ENDIF
            NEXT
            EJECT
            SET PRINT OFF
     ENDIF
ENDDO
CLOSE ALL
RETURN
