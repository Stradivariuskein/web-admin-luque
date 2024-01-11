*******************************************************************************
*Fuente : ABMEXPR.PRG  - SIAAC
*
*Funcion : Alta, Baja y Modificaciones de Colores.
*
* Opcion 4 Menu de ABM.
*******************************************************************************

IF !SEGURIDAD(MM_CLAVE,'G')
   DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
   ESPERAR(0)
   RETURN
ENDIF

SELE 3
USE EXPRESO INDEX EXPRESO

PRIVATE M_NRO,M_DESCRIP,M_DIREC,M_CUIT,M_TEL,M_OBS,M_LOC

DO WHILE .T.
   CLEAR
   DO PANT_EXP
   DO TITULO
   M_NRO = SPACE(10)
   @ 9,32 GET M_NRO PICT '@!' VALID VALVACIO(M_NRO)
   READ
   IF LASTKEY() = 27
      EXIT
   ENDIF
   IF TRIM(M_NRO) = 'LIS'
      DO LIS_EXP
      LOOP
   ENDIF
   SEEK M_NRO
   IF !FOUND() .OR. DELETE()
      IF APRUEBA(24,0,7)
         @ 24,0 SAY SPACE(79)
         DO PIDE_EXP WITH .T.
         IF LASTKEY() = 27
            LOOP
         ENDIF
         IF APRUEBA(24,0,2)
            APPEND BLANK
            REPLACE NUMERO WITH M_NRO
            REPLACE NOMBRE WITH M_DESCRIP
            REPLACE DIREC WITH M_DIREC
            REPLACE CUIT WITH M_CUIT
            REPLACE LOC WITH M_LOC
            REPLACE TEL WITH M_TEL
            REPLACE OBS WITH M_OBS
         ENDIF
      ENDIF
   ELSE
      DO PIDE_EXP WITH .F.
      IF LASTKEY() = 27
         LOOP
      ENDIF
      IF TRIM(M_NRO) = 'LIS'
         DO LIS_EXP
         LOOP
      ENDIF
      IF TRIM(M_NRO) = 'LIBRE'
         IF APRUEBA(24,0,6)
           if rlock()
            DELETE
            unlock
          endif
            LOOP
         ENDIF
      ENDIF
      IF APRUEBA(24,0,2)
        if rlock()
         REPLACE NUMERO WITH M_NRO
         REPLACE NOMBRE WITH M_DESCRIP
         REPLACE DIREC WITH M_DIREC
         REPLACE CUIT WITH M_CUIT
         REPLACE LOC WITH M_LOC
         REPLACE TEL WITH M_TEL
         REPLACE OBS WITH M_OBS
         unlock
        endif
      ENDIF
   ENDIF
ENDDO
CLOSE ALL
RETURN

PROCEDURE PANT_EXP
******************
*Pantalla de ABM de Expresos

SET COLOR TO I
@  2, 25  SAY '     *  ARCHIVO DE EXPRESOS *     '
@  4, 25  SAY '- Altas, Bajas y Modificaciones -'
SET COLOR TO I
@ 22,25 SAY '<LIS> = LISTADO DE EXPRESOS'
SET COLOR TO
@  9,  6  SAY "C¢digo de Expreso      :"
@ 11,  6  SAY "Nombre                 :"
@ 13,  6  SAY "Direcci¢n              :"
@ 15,6    SAY 'Localidad              :'
@ 17,6    SAY 'Telefono               :'
@ 19,  6  SAY "Nro. C.U.I.T.          :"
@ 21,6    SAY 'Observaciones          :'
@  1,  0  TO 23, 79    DOUBLE
@  6,  1  TO  6, 78
DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
RETURN

PROCEDURE PIDE_EXP
******************
*Pide Datos de Expresos
PARAMETERS ALTA

IF ALTA
   DO BLAN_EXP  WITH .T.
ELSE
   DO BLAN_EXP  WITH .F.
ENDIF

IF !ALTA
   @ 9,32 GET M_NRO PICT '@!'  VALID VALVACIO(M_NRO)
ENDIF
@ 11,32 GET M_DESCRIP PICT '@!'
@ 13,32 GET M_DIREC PICT '@!S40'
@ 15,32 GET M_LOC PICT '@!'
@ 17,32 GET M_TEL
@ 19,32 GET M_CUIT
@ 21,32 GET M_OBS
READ
IF LASTKEY() = 27
   RETURN
ENDIF
RETURN

PROCEDURE BLAN_EXP
******************
*Blanqueo de Variables de Expresos

PARAMETERS M_ALTA

IF M_ALTA
   M_DESCRIP = SPACE(30)
   M_DIREC = SPACE(70)
   M_CUIT = SPACE(30)
   M_LOC = SPACE(30)
   M_TEL = SPACE(30)
   M_OBS = SPACE(70)
ELSE
   M_DESCRIP= NOMBRE
   M_DIREC = DIREC
   M_CUIT = CUIT
   M_LOC = LOC
   M_TEL = TEL
   M_OBS = OBS
ENDIF
RETURN

PROCEDURE LIS_EXP
*****************
*Listado de Expresos

IMPRE = .F.
IF APRUEBA(24,0,11)
   IMPRE = .T.
ENDIF
IF LASTKEY() = 27
   RETURN
ENDIF
DO M_CARTEL WITH 10,24,0,.T.,.F.,.T.
ESPERAR(0)
IF LASTKEY() = 27
   RETURN
ENDIF
IF IMPRE
   SET DEVICE TO PRINT
ENDIF
INDEX ON NOMBRE TO AUXIL00
GO TOP
LINEAS = 66
PRIMERA = .T.
HOJA = 1
DO WHILE !EOF()
   IF LINEAS > 65 .AND. IMPRE
      DO ENC_EXP
   ELSE
      IF LINEAS > 20 .AND. !IMPRE
         DO ENC_EXP
         IF LASTKEY() = 27
             GO BOTTOM
             LOOP
         ENDIF
      ENDIF
   ENDIF
   IF IMPRE
       @ LINEAS,2 SAY CHR(15) + NUMERO  + '        ' + NOMBRE + '      ' + DIREC
       @ LINEAS+1,2 SAY 'Loc: ' + LOC + ' ' + 'Tel : ' + TEL
       @ LINEAS+2,2 SAY 'Obs: ' + OBS + CHR(18)
       @ LINEAS+3,2 SAY REPLICATE('=',77)
       LINEAS = LINEAS + 3
   ELSE
        @ LINEAS,2 SAY NUMERO + '   ' + NOMBRE + ' ' + SUBSTR(DIREC,1,40)
        LINEAS = LINEAS + 1
   ENDIF
   SKIP
ENDDO
IF IMPRE
   EJECT
   SET DEVICE TO SCREEN
ELSE
   @ 22,3 SAY 'Pulse Cualquier Tecla Para Continuar ...'
   ESPERAR(0)
ENDIF
ERASE C:\SIAAC\AUXIL00.NTX
SELE 3
USE EXPRESO INDEX EXPRESO
RETURN

PROCEDURE ENC_EXP
*****************
*Encabezamiento del Listado de Expresos

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
@ PROW(),PCOL() SAY CHR(18)
@ LINEAS,15 SAY IIF(IMPRE,CHR(14),'             ') + '* LISTADO DE EXPRESOS * '
@ LINEAS + 2,2 SAY 'Fecha: ' + DTOC(DATE())
@ LINEAS + 2,50 SAY 'Hoja Nro : ' + STR(HOJA,1,2)
@ LINEAS + 4,1 SAY 'Codigo       Descripcion                   Direccion'
HOJA = HOJA + 1
@ LINEAS + 5,2 SAY REPLICATE('=',77)
LINEAS = 7
@ PROW(),PCOL() SAY CHR(15)
RETURN
*: EOF: ABMEXPR.PRG
