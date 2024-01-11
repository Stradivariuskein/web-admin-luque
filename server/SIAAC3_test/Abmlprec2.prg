*******************************************************************************
*Fuente : ABMLPREC.PRG  - SIAAC
*
*Funcion : Alta, Baja y Modificaciones de Lista de Precios.
*          Actualizacion por rango elegido.
*
*******************************************************************************

*IF !SEGURIDAD(MM_CLAVE,'F')
*        DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*        ESPERAR(0)
*        RETURN
*ENDIF

SELE 3
USE ARTIC2 INDEX ARTIC2

SELE 2
USE ARTIC INDEX ARTIC,AR2

SELE 12
USE PROVEDOR INDEX PROVEDOR

PRIVATE M_ART,M_COLOR,M_NUM,M_PREC,M_FECH,M_CUAL

DO WHILE .T.
   CLEAR
   DO TITULO
   DECLARE MENPEE[7]
   DECLARE OPPEE[7]
   OPPEE[1]='ABM DE LISTA DE PRECIOS'
   OPPEE[2]='ACTUALIZACION INDIVIDUAL POR ARTICULO'
   OPPEE[3]='ACTUALIZACION LISTA DE PRECIOS POR %'
   OPPEE[4]='LISTA de PRECIOS P/CLIENTES'
   OPPEE[5]='LISTA de PRECIOS ACTUALIZADOS'
   OPPEE[6]='LISTA de PRECIOS INTERNA'
   OPPEE[7]='LISTA de PRECIOS (CODIGO y PRECIO)'

   MENPEE[1]='          º Altas, Bajas y Modif. de Listas de Precios'
   MENPEE[2]='          º Actualizaci¢n uno por uno de Art¡culo'
   MENPEE[3]='          º Actualizaci¢n por % de toda la lista'
   MENPEE[4]='          º Lista de Precios por Pantalla o Impresora'
   MENPEE[5]='          º Lista de Precios por Pantalla o Impresora'
   MENPEE[6]='          º Otras listas de Precios'
   MENPEE[7]='          º Lista Codigo y Precio'

   *    Displaya opciones y captura.
   OPPE=OPCIONES('SISTEMA DE VENTAS - LISTA DE PRECIOS',OPPEE,MENPEE)
   *    Fin
   IF LASTKEY()=27
      EXIT
   ENDIF
   DO CASE
   CASE OPPE = 1
      DO ABMLISTA
   CASE OPPE=2
      DO LIS_INDI
   CASE OPPE=3
      DO ACTU_RANG
   CASE OPPE=4
      DO LIS_PRE WITH .F.
   CASE OPPE = 5
      DO LIS_ACTU
   CASE OPPE = 6
      DO LIS_PRE WITH .T.
   CASE OPPE = 7
      DO LIS_ESP
   ENDCASE
ENDDO
CLOSE ALL
RETURN


PROCEDURE LIS_INDI
******************
*Actualizacion individual de la lista de precios

DO WHILE .T.
   CLEAR
   DO TITULO
   DO PANT_PRE
   @ 1,0 TO 23,79 DOUBLE
   M_ART = SPACE(11)
   DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
   DO WHILE .T.
      SELE 2
      @ 7,6   SAY 'C¢digo de Art¡culo       : ' GET M_ART PICT '@!' VALID VALVACIO(M_ART)
      READ
      IF LASTKEY() = 27
         EXIT
      ENDIF
      SEEK M_ART
      IF FOUND()
         SET COLOR TO I
         @ 8,6 SAY DESCR
         SET COLOR TO
         EXIT
      ELSE
         DO M_CARTEL WITH 15,24,0,.T.,.T.,.T.
         ESPERAR(0)
         @ 24,0 SAY SPACE(79)
      ENDIF
   ENDDO
   IF LASTKEY() = 27
      EXIT
   ENDIF
   M_CODLIS = '0'
   @ 9,6 SAY 'Codigo de Lista (0 = LISTA VIGENTE) : ' GET M_CODLIS PICT '@!' VALID VALLIS(M_CODLIS,3)
   READ
   IF LASTKEY() = 27
       LOOP
   ENDIF
   DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
   IF M_CODLIS = '0'
      SELE 2
      SEEK M_ART
   ELSE
      SELE 3
      SEEK M_CODLIS + M_ART
      IF !FOUND()
           DO M_CARTEL WITH 91,24,0,.T.,.T.,.T.
           ESPERAR(0)
           LOOP
      ENDIF
   ENDIF
   M_PREC1 = LISTA1
   M_PREC2 = LISTA2
   M_PREC3 = LISTA3
   M_PREC4 = LISTA4
   M_PREC5 = LISTA5
   M_TIPO = TPRE
   M_FEAC = FEAC
   @ 12,32 GET M_PREC1 PICT '######.###' VALID M_PREC1 >= 0
   @ 14,32 GET M_PREC2 PICT '######.###' VALID M_PREC2 >= 0
   @ 16,32 GET M_PREC3 PICT '######.###' VALID M_PREC3 >= 0
   @ 18,32 GET M_PREC4 PICT '######.###' VALID M_PREC4 >= 0
   @ 20,32 GET M_PREC5 PICT '######.###' VALID M_PREC5 >= 0
   @ 22,32 GET M_TIPO PICT 'A' VALID M_TIPO = 'P' .OR. M_TIPO = 'D'
   @ 22,50 GET M_FEAC PICT '99/99/99' VALID VALFECH(M_FEAC)
   READ
   IF LASTKEY() = 27
      EXIT
   ENDIF
   IF APRUEBA(24,0,2)
      REPLACE LISTA1 WITH M_PREC1
      REPLACE LISTA2 WITH M_PREC2
      REPLACE LISTA3 WITH M_PREC3
      REPLACE LISTA4 WITH M_PREC4
      REPLACE LISTA5 WITH M_PREC5
      REPLACE TPRE WITH M_TIPO
      REPLACE FEAC WITH M_FEAC
   ENDIF
   @ 12,32 SAY SPACE(20)
   @ 14,32 SAY SPACE(20)
   @ 16,32 SAY SPACE(20)
   @ 18,32 SAY SPACE(20)
   @ 20,32 SAY SPACE(20)
   @ 22,32 SAY SPACE(20)
   @ 24,0 SAY SPACE(79)
ENDDO
RETURN


PROCEDURE PANT_PRE
******************
*Pantalla de ABM de Lista de Precios

SET COLOR TO I
@  2, 25  SAY '     *  LISTA DE PRECIOS *       '
SET COLOR TO
@ 10,1 TO 10,78 DOUBLE
@ 12,  6  SAY "Precio  Lista 1        :"
@ 14,  6  SAY "Precio  Lista 2        :"
@ 16,  6  SAY "Precio  Lista 3        :"
@ 18,  6  SAY "Precio  Lista 4        :"
@ 20,  6  SAY "Precio  Lista 5        :"
@ 22,  6  SAY "Tipo de Precio P o D   :"
@ 22,35 SAY 'Fecha de Act : '
@  1,  0  TO 21, 79    DOUBLE
@  6,  1  TO  6, 78
RETURN

PROCEDURE ACTU_RANG
*******************
*Actualiza La Lista de Costos Por Rangos de Articulo por PROVEEDOR

DO WHILE .T.
   CLEAR
   @ 1,0 TO 23,79 DOUBLE
   DO TITULO
   SET COLOR TO I
   @ 3,28 SAY '* ACTUALIZACION DE LISTAS POR % * '
   SET COLOR TO
   @ 5,2 TO 5,78 DOUBLE
   M_PORC = 0
   M_LISTA = 2
   M_LISAC = 1
   M_CODLIS = '0'
   @ 12,2 SAY 'Lista a Actualizar : ' GET M_LISAC PICT '#'
   @ 14,2 SAY 'Porcentaje : ' GET M_PORC PICT '###.##' VALID M_PORC >= 0
   @ 16,2 SAY 'Sobre que Lista Nro: ' GET M_LISTA PICT '#'
   @ 18,2 SAY 'Codigo de Lista a Actualizar (0 = LISTA VIGENTE) : ' GET M_CODLIS PICT '@!' VALID VALLIS(M_CODLIS,3)
   SELE 12
   M_PROV = SELE_PROV(15,30,20)
   SELE 12
   SEEK M_PROV
   @ 20,2 SAY 'Proveedor : ' + PROVEDOR->NOMBRE
   READ
   IF LASTKEY() = 27
      EXIT
   ENDIF
   M_LIS1 = 'LISTA' + STR(M_LISAC,1,0)
   M_LIS2 = 'LISTA' + STR(M_LISTA,1,0)
   IF APRUEBA(24,0,2)
      IF M_CODLIS = '0'
         SELE 2
         M_COND = 'COD_PROV = M_PROV'
      ELSE
         SELE 3
         M_COND = 'COD_PROV = M_PROV .AND. M_CODLIS = LISTA'
      ENDIF
      GO TOP
      DO M_CARTEL WITH 17,24,0,.T.,.F.,.T.
      DO WHILE !EOF()
            IF &M_COND
               REPLACE &M_LIS1 WITH &M_LIS2 + (&M_LIS2 * M_PORC / 100)
            ENDIF
            SKIP
      ENDDO
      @ 24,0 SAY SPACE(79)
   ENDIF
   @ 24,0 SAY SPACE(79)
ENDDO
RETURN


PROCEDURE LIS_PRE
*****************
PARAMETERS M_DOSCOL

*Listado de Precios
STOR SPACE(10) TO M_DESDER,M_HASTAR
STOR SPACE(65) TO M_NOTA1,M_NOTA2,M_NOTA3
M_TITULO = SPACE(20)
M_CODLIS = '0'
STOR 1 TO M_LISTA1,M_LISTA2
STOR SPACE(10) TO M_TIT1,M_TIT2
M_IOA = 'I'
@ 13,0 CLEAR TO 23,79
@ 13,0 TO 23,79
@ 14,1 SAY '(L)istado o (A)rchivo : ' GET M_IOA PICT '@A' VALID M_IOA = 'L' .OR. M_IOA = 'A'
@ 15,1 SAY 'Titulo : ' GET M_TITULO
@ 16,1 SAY 'Nota   : ' GET M_NOTA1 PICT '@!'
@ 17,11 GET M_NOTA2 PICT '@!'
@ 18,11 GET M_NOTA3 PICT '@!'
@ 19,1 SAY 'Cod.Lista (0 = VIGENTE) ' get m_codlis PICT '@!' VALID VALLIS(M_CODLIS,3)
@ 20,1 SAY 'Listas Nros.: ' GET M_LISTA1 PICT '#' VALID M_LISTA1 >= 1 .AND. M_LISTA1 <= 5
IF M_DOSCOL
    @ 20,30 GET M_LISTA2 PICT '#' VALID M_LISTA2 >= 0 .AND. M_LISTA2 <= 5
ENDIF
@ 21,1 SAY  'Columna 1  : ' GET M_TIT1 PICT '@!'
IF M_DOSCOL
    @ 21,53 SAY 'Columna 2: ' GET M_TIT2 PICT '@!'
ENDIF
@ 22,1 SAY  'Desde rubro: ' GET M_DESDER PICT '@!'
@ 22,50 SAY 'Hasta Rubro : ' GET M_HASTAR PICT '@!'
READ
IF LASTKEY() = 27
    RETURN
ENDIF

IF M_LISTA2 = 0
     M_DOSCOL = .F.
ENDIF

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
   IF M_IOA = 'A'
        SET PRINT TO PRECIOS.TXT
   ENDIF
   SET DEVICE TO PRINT
   IF M_IOA = 'L'
        @ PROW(),PCOL() SAY CHR(18)
        @ PROW(),PCOL() SAY CHR(27) + CHR(48)
   ENDIF
ENDIF

SELE 1
USE RUBROA INDEX RUBROA

IF M_CODLIS = '0'
   SELE 2
   INDEX ON RUBRO + COD_ART TO AUXILI0
   SEEK M_DESDER
   IF !FOUND()
       GO TOP
   ENDIF
ELSE
   SELE 3
   INDEX ON RUBRO + COD_ART TO AUXILI0
   SEEK M_DESDER
   IF !FOUND()
      GO TOP
   ENDIF
ENDIF

LINEAS = 110
PRIMERA = .T.
HOJA = 1
VEZ = 1
COLUM = 3
DO WHILE !EOF() .AND. RUBRO <= M_HASTAR
    M_RUBROA = RUBRO
    PRIMER = .T.
    DO WHILE !EOF() .AND. M_RUBROA = RUBRO
         IF LINEAS > 86 .AND. IMPRE
            DO ENC_PRE2 WITH .T.
         ELSE
            IF LINEAS > 20 .AND. !IMPRE
               DO ENC_PRE2 WITH .F.
               IF LASTKEY() = 27
                  GO BOTTOM
                  SKIP
                  LOOP
               ENDIF
            ENDIF
         ENDIF
         IF M_CODLIS <> '0'
            IF LISTA <> M_CODLIS
                SKIP
                LOOP
            ENDIF
         ENDIF
         M_LIS1 = 'LISTA' + STR(M_LISTA1,1,0)
         IF M_DOSCOL
               M_LIS2 = 'LISTA' + STR(M_LISTA2,1,0)
               IF &M_LIS1 = 0 .AND. &M_LIS2 = 0
                    SKIP
                    LOOP
               ENDIF
         ELSE
               IF &M_LIS1 = 0
                    SKIP
                    LOOP
               ENDIF
         ENDIF
         IF PRIMER
             IF M_CODLIS = '0'
                SELE 1
                SEEK ARTIC->RUBRO
             ELSE
                SELE 1
                SEEK ARTIC2->RUBRO
             ENDIF
             IF IMPRE
                 IF M_IOA = 'L'
                      @ LINEAS,1 SAY CHR(27) + CHR(71) + DESCR + CHR(27) + CHR(72)
                 ELSE
                      @ LINEAS,1 SAY DESCR
                 ENDIF
             ELSE
                 SET COLOR TO W+
                 @ LINEAS,1 SAY DESCR
                 SET COLOR TO
             ENDIF
             LINEAS = LINEAS + 1
             PRIMER = .F.
             IF M_CODLIS = '0'
                SELE 2
             ELSE
                SELE 3
             ENDIF
         ENDIF
         IF M_IOA = 'L'
               @ LINEAS,COLUM SAY COD_ART + ' ' + IIF(!IMPRE,SUBSTR(DESCR,1,35),CHR(15) + DESCR + CHR(18)) + ' ' + IIF(IMPRE,CHR(15)+SUBSTR(ARTIC->UNIDAD,1,6)+CHR(18),'') + ' ' + TRANSFORM(&M_LIS1,'##,###.###') + ' ' +;
               IIF(M_DOSCOL,TRANSFORM(&M_LIS2,'###,###.##'),'')
         ELSE
               @ LINEAS,COLUM SAY COD_ART + ' ' + SUBSTR(DESCR,1,35) + ' ' + SUBSTR(ARTIC->UNIDAD,1,6) + ' ' + TRANSFORM(&M_LIS1,'##,###.###') + ' ' +;
               IIF(M_DOSCOL,TRANSFORM(&M_LIS2,'###,###.##'),'')
         ENDIF
         LINEAS = LINEAS + 1
         SKIP
    ENDDO
ENDDO
@ LINEAS + 1,1 SAY M_NOTA1
@ LINEAS + 2,1 SAY M_NOTA2
@ LINEAS + 3,1 SAY M_NOTA3
IF IMPRE
   IF M_IOA = 'L'
        @ PROW(),PCOL() SAY CHR(18)
        @ PROW(),PCOL() SAY CHR(27) + CHR(50)
   ENDIF
   SET DEVICE TO SCREEN
   IF M_IOA = 'L'
        EJECT
   ELSE
        SET PRINT TO
   ENDIF
ELSE
   @ 22,3 SAY 'Pulse Cualquier Tecla Para Continuar ...'
   ESPERAR(0)
ENDIF
SELE 2
USE ARTIC INDEX ARTIC,AR2
SELE 3
USE ARTIC2 INDEX ARTIC2
RETURN


PROCEDURE ENC_PRE2
******************
*Encabezamiento del Listado de precios

PARAMETERS IMPRES

IF !PRIMERA
   IF IMPRES
      IF M_IOA = 'L'
          EJECT
      ENDIF
   ELSE
      @ 22,3 SAY 'Pulse Cualquier Tecla Para Continuar ...'
      ESPERAR(0)
      @ 9,1 CLEAR TO 24,79
   ENDIF
ELSE
   PRIMERA = .F.
   IF !IMPRES
      @ 1,0 CLEAR TO 24,79
   ENDIF
ENDIF
LINEAS = 1
IF M_IOA = 'L'
     @ LINEAS,1 SAY CHR(14) + 'LUQUE'
ENDIF
@ LINEAS+1,1 SAY 'Antonio Luque S.A.I.C.'
@ LINEAS+2,1 SAY 'Eduardo Porrini 217 - (1702) Ciudadela'
@ LINEAS+3,1 SAY 'T.E. (01)-653-3006'
@ LINEAS+4,1 SAY 'Hoja: ' + STR(HOJA,3,0)
@ LINEAS+4,25 SAY M_TITULO
@ LINEAS + 5,0 SAY REPLICATE('=',80)
@ LINEAS + 6,2 SAY ' Codigo     Descripcion                    Unidad' + M_TIT1 + ' ' + IIF(M_DOSCOL,M_TIT2,'')
@ LINEAS + 7,0 SAY REPLICATE('=',80)
LINEAS = 9
*IF PRIMER
*   SELE 1
*   IF M_CODLIS = '0'
*       SEEK ARTIC->RUBRO
*   ELSE
*       SEEK ARTIC2->RUBRO
*   ENDIF
*   IF IMPRE
*      @ LINEAS,1 SAY CHR(27) + CHR(71) + DESCR + CHR(27) + CHR(72)
*   ELSE
*      SET COLOR TO W+
*      @ LINEAS,1 SAY DESCR
*      SET COLOR TO
*   ENDIF
*   PRIMER = .F.
*   IF M_CODLIS = '0'
*      SELE 2
*   ELSE
*      SELE 3
*   ENDIF
*ENDIF
LINEAS = LINEAS + 1
HOJA = HOJA + 1
RETURN


PROCEDURE ABMLISTA
******************
*Genera Nuevas Listas de Precios.

DO WHILE .T.
    CLEAR
    DO TITULO
    @ 1,0 TO 23,79 DOUBLE
    DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
    SET COLOR TO I
    @ 3,30 SAY 'ABM de LISTAS de PRECIOS'
    SET COLOR TO
    M_CODLIS = ' '
    @ 8,3 SAY 'Ingrese Codigo de Lista : ' GET M_CODLIS PICT 'A'
    READ
    IF LASTKEY() = 27
       EXIT
    ENDIF
    IF M_CODLIS = '0'
         LOOP
    ENDIF
    SELE 3
    SEEK M_CODLIS
    IF !FOUND()
         IF APRUEBA(24,0,90)
              ALTA = .T.
         ELSE
              LOOP
         ENDIF
    ELSE
         DO M_CARTEL WITH 35,24,0,.T.,.F.,.T.
         M_LETRA = 'M'
         @ 24,70 GET M_LETRA PICT 'A' VALID M_LETRA = 'B' .OR. M_LETRA = 'M'
         READ
         IF LASTKEY() = 27
             LOOP
         ENDIF
         IF M_LETRA = 'M'
              ALTA = .F.
         ELSE
              IF APRUEBA(24,0,6)
                   DO BAJA_LISTA
                   LOOP
              ENDIF
         ENDIF
    ENDIF
    M_VIGENCIA = M_FECHA
    @ 10,3 SAY 'Vigencia desde : ' GET M_VIGENCIA PICT '99/99/99' VALID VALFECH(M_VIGENCIA)
    READ
    IF LASTKEY() = 27
         LOOP
    ENDIF
    IF APRUEBA(24,0,2)
          DO GRABACOD WITH ALTA
    ENDIF
ENDDO
RETURN

PROCEDURE GRABACOD
******************

PARAMETERS M_MARCA

IF M_MARCA
   SELE 2
   GO TOP
   DO WHILE !EOF()
        SELE 3
        APPE BLANK
        REPLACE LISTA WITH M_CODLIS
        REPLACE COD_ART WITH ARTIC->COD_ART
        REPLACE LISTA1 WITH ARTIC->LISTA1
        REPLACE LISTA2 WITH ARTIC->LISTA2
        REPLACE LISTA3 WITH ARTIC->LISTA3
        REPLACE LISTA4 WITH ARTIC->LISTA4
        REPLACE LISTA5 WITH ARTIC->LISTA5
        REPLACE VIGEN WITH M_VIGENCIA
        REPLACE TPRE WITH ARTIC->TPRE
        REPLACE COD_PROV WITH ARTIC->COD_PROV
        REPLACE RUBRO WITH ARTIC->RUBRO
        REPLACE DESCR WITH ARTIC->DESCR
        REPLACE FEAC WITH ARTIC->FEAC
        SELE 2
        SKIP
   ENDDO
ELSE
   SELE 3
   REPLACE VIGEN WITH M_VIGENCIA
ENDIF
RETURN

PROCEDURE BAJA_LISTA
********************

SELE 3
DO WHILE !EOF() .AND. LISTA = M_CODLIS
       DELETE
       SKIP
ENDDO
PACK
RETURN


FUNCTION VALLIS
***************
PARAMETERS M_COD,M_SELE

IF M_COD = '0'
   RETURN(.T.)
ENDIF

SELE 3
SEEK M_COD
IF !FOUND()
    DO M_CARTEL WITH 92,24,0,.T.,.T.,.T.
    ESPERAR(0)
    RETURN(.F.)
ELSE
    RETURN(.T.)
ENDIF


PROCEDURE LIS_ACTU
******************
*Listado de Precios Actualizados
M_LISTA = 1
STOR M_FECHA TO M_DESDE,M_HASTA,M_VIGEN
M_CODLIS = '0'
M_DESEO = 'N'
M_LETRA = SPACE(10)
@ 15,0 CLEAR TO 23,79
@ 15,0 TO 23,79 DOUBLE
@ 16,2 SAY 'Desde Fecha de Act        : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
@ 17,2 SAY 'Hasta Fecha de Act        : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
@ 18,2 SAY 'Numero de Lista Vigente   : ' GET M_LISTA PICT '#' VALID M_LISTA >= 1 .AND. M_LISTA <= 5
@ 19,2 SAY 'Codigo de Lista Anterior  : ' GET M_CODLIS PICT '@!' VALID VALLIS(M_CODLIS,3)
@ 20,2 SAY 'Vigencia Desde Fecha      : ' GET M_VIGEN PICT '99/99/99' VALID VALFECH(M_VIGEN)
@ 21,2 SAY 'Desea Sacar % S/N         : ' GET M_DESEO PICT '@A' VALID M_DESEO = 'S' .OR. M_DESEO = 'N'
@ 22,2 SAY 'Letra                     : ' GET M_LETRA
READ
IF LASTKEY() = 27
    RETURN
ENDIF

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
DO M_CARTEL WITH 102,24,0,.T.,.F.,.T.
IF IMPRE
   SET DEVICE TO PRINT
   @ PROW(),PCOL() SAY CHR(15)
ENDIF
SELE 2
LINEAS = 66
PRIMERA = .T.
HOJA = 1
VEZ = 1
COLUM = 3
M_VECES = 1
FIN = .F.
DO WHILE !EOF()
         IF LINEAS > 60 .AND. IMPRE
            DO ENC_ACT WITH .T.
         ELSE
            IF LINEAS > 20 .AND. !IMPRE
               DO ENC_ACT WITH .F.
               IF LASTKEY() = 27
                  EXIT
               ENDIF
            ENDIF
         ENDIF
         IF FEAC >= M_DESDE .AND. FEAC <= M_HASTA
              M_LIS = 'LISTA' + STR(M_LISTA,1,0)
              M_PRECIO = &M_LIS
              SELE 3
              SEEK M_CODLIS + ARTIC->COD_ART
              IF !FOUND()
                   M_PREANT = 0
                   M_PORC = 0
              ELSE
                   M_PREANT = &M_LIS
                   M_PORC = (M_PRECIO - M_PREANT) / M_PREANT * 100
              ENDIF
              SELE 2
              @ LINEAS,1 SAY COD_ART + ' ' + SUBSTR(DESCR,1,60) + TRANSFORM(M_PRECIO,'##,###.###') + '     ' + TRANSFORM(M_PREANT,'###,###.###') + '     ' + IIF(M_DESEO = 'S',TRANSFORM(M_PORC,'###.##'),'')
              LINEAS = LINEAS + 1
         ENDIF
         SKIP
ENDDO
@ LINEAS + 4,1 SAY 'Nota: Estos precios estan sugetos a variacion sin aviso previo'
IF IMPRE
   EJECT
   @ PROW(),PCOL() SAY CHR(18)
   SET DEVICE TO SCREEN
ELSE
   @ 22,3 SAY 'Pulse Cualquier Tecla Para Continuar ...'
   ESPERAR(0)
ENDIF
ERASE C:\SIAAC\AUXILI0.NTX
SELE 2
USE ARTIC INDEX ARTIC,AR2
RETURN


PROCEDURE ENC_ACT
*****************
*Encabezamiento del Listado de precios

PARAMETERS IMPRES

IF !PRIMERA
   @ PROW(),PCOL() SAY CHR(18)
   @ LINEAS + 4,1 SAY 'Nota: Estos precios estan sugetos a variacion sin aviso previo'
   IF IMPRES
      EJECT
   ELSE
      @ 22,3 SAY 'Pulse Cualquier Tecla Para Continuar ...'
      ESPERAR(0)
      @ 9,2 CLEAR TO 24,79
   ENDIF
ELSE
   PRIMERA = .F.
   IF !IMPRES
      @ 1,0 CLEAR TO 24,79
   ENDIF
ENDIF
LINEAS = 1
@ PROW(),PCOL() SAY CHR(18)
@ LINEAS,1 SAY CHR(14) + CHR(27) + CHR(71) + CHR(27) + CHR(52) + 'LUQUE  m.r.' + CHR(27) + CHR(53) + CHR(27) + CHR(72)
@ PROW(),PCOL() SAY CHR(18)
@ LINEAS + 1,1 SAY 'ANTONIO LUQUE S.A.I.C.'
@ LINEAS + 2,1 SAY 'Eduardo Porrini 217 (1702) Ciudadela'
@ LINEAS + 3,1 SAY 'T.E. : (01) 653-3006'
@ LINEAS + 3,40 SAY 'Vigencia Desde : ' + DTOC(M_VIGEN)
@ LINEAS + 4,1 SAY REPLICATE('_',79)
@ LINEAS + 5,20 SAY '    FABRICACION DE HERRAJES'
@ LINEAS + 6,20 SAY 'HERRAMIENTAS - ART. DE FERRETERIA'
@ LINEAS + 7,1 SAY 'Letra : ' + M_LETRA
@ PROW(),PCOL() SAY CHR(15)
@ LINEAS + 8,0 SAY REPLICATE('=',136)
IF M_DESEO = 'S'
    @ LINEAS + 9,2 SAY ' Codigo              Descripcion                                    P.ACTUAL        P.ANTERIOR   % '
ELSE
    @ LINEAS + 9,2 SAY ' Codigo              Descripcion                                    P.ACTUAL        P.ANTERIOR'
ENDIF
@ LINEAS + 10,0 SAY REPLICATE('=',136)
LINEAS = 12
HOJA = HOJA + 1
RETURN

PROCEDURE LIS_ESP
********* *******
*Lista de Precios Especial
M_LISTA = 1
M_NRO = SPACE(10)
VIGEN = DATE()
M_DESDE = DATE()
M_HASTA = DATE()
@ 17,1 CLEAR TO 23,79
@ 17,1 TO 23,79 DOUBLE
@ 18,2 SAY 'Lista Numero                : ' GET M_LISTA PICT '#' VALID M_LISTA >= 1 .AND. M_LISTA <= 5
@ 19,2 SAY 'Modificaciones sobre Lista  : ' GET M_NRO
@ 20,2 SAY 'Vigencia desde el           : ' GET VIGEN PICT '99/99/99' VALID VALFECH(VIGEN)
@ 21,2 SAY 'Desde Fecha de Actualizacion: ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
@ 22,2 SAY 'Hasta Fecha de Actualizacion: ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
READ
IF LASTKEY() = 27
    RETURN
ENDIF

IMPRESORA = .T.
IF LASTKEY() = 27
   RETURN
ENDIF
DO M_CARTEL WITH 10,24,0,.T.,.F.,.T.
ESPERAR(0)
IF LASTKEY() = 27
     RETURN
ENDIF
IF IMPRESORA
     SET DEVICE TO PRINT
     @ PROW(),PCOL() SAY CHR(27) + CHR(48)
     @ PROW(),PCOL() SAY CHR(15)
ENDIF

SELE 2
USE ARTIC INDEX ARTIC,ARTIC2
GO TOP
SET FILTER TO FEAC >= M_DESDE .AND. FEAC <= M_HASTA

LINEAS = 100
PRIMERA = .T.
HOJA = 1
COLUM = 0
VEZ = 1
DO WHILE !EOF()
      IF LINEAS > 88 .AND. IMPRESORA
             IF !PRIMERA
                @ PROW(),PCOL() SAY CHR(27) + CHR(45) + '0'
             ENDIF
             DO ENC_ESP WITH .T.
             IF LASTKEY() = 27
                   GO BOTTOM
                   SKIP
                   LOOP
             ENDIF
      ENDIF
      IF VEZ = 6
         @ PROW(),PCOL() SAY CHR(27) + CHR(45) + '1'
      ENDIF
      IF AT('/',COD_ART) = 0
         M_AUXI = 'LISTA' + ALLTRIM(STR(M_LISTA,1,0))
         M_PRECIO = &M_AUXI
         @ LINEAS,COLUM SAY SUBSTR(COD_ART,1,5) + ' ' + STR(M_PRECIO,12,2) + IIF(ARTIC->TPRE  = 'P',' P',' D') + ' | '
         VEZ = VEZ + 1
         COLUM = COLUM + 22
      ENDIF
      SKIP
      @ PROW(),PCOL() SAY CHR(27) + CHR(45) + '0'
      IF VEZ = 7
          LINEAS = LINEAS  + 1
          VEZ = 1
          COLUM = 0
      ENDIF
ENDDO
IF IMPRESORA
    @ PROW(),PCOL() SAY CHR(27) + CHR(45) + '0'
    EJECT
    SET DEVICE TO SCREEN
ELSE
    @ 22,3 SAY 'Pulse Cualquier Tecla Para Continuar ...'
    ESPERAR(0)
ENDIF
SELE 2
USE ARTIC INDEX ARTIC,ARTIC2
RETURN


PROCEDURE ENC_ESP
*****************
*Encabezamiento del Listado de precios

PARAMETERS IMPRES

IF !PRIMERA
     IF IMPRES
         EJECT
     ELSE
         @ 22,3 SAY 'Pulse Cualquier Tecla Para Continuar ...'
         ESPERAR(0)
         @ 9,2 CLEAR TO 24,79
     ENDIF
ELSE
     PRIMERA = .F.
     IF !IMPRES
         @ 1,0 CLEAR TO 24,79
     ENDIF
ENDIF
LINEAS = 1
@ PROW(),PCOL() SAY CHR(18)
@ PROW(),PCOL() SAY CHR(27) + CHR(45) + '0'
@ LINEAS,1 SAY CHR(14) + 'LUQUE'
@ LINEAS+1,1 SAY 'Antonio Luque S.A.I.C.'
@ LINEAS+2,1 SAY 'Eduardo Porrini 217 - (1702) Ciudadela'
@ LINEAS+3,1 SAY 'T.E. (01)-653-3006'
LINEAS = LINEAS + 6
@ LINEAS, 20 SAY '* MODIFICACIONES SOBRE LISTA       : ' + M_NRO
@ LINEAS + 2,2 SAY 'Fecha: ' + DTOC(M_FECHA)
@ LINEAS + 2,60 SAY 'Hoja Nro : ' + STR(HOJA,2,0)
@ LINEAS + 3,2 SAY 'Vigencia a Partir del : ' + DTOC(VIGEN)
@ PROW(),PCOL() SAY CHR(15)
@ LINEAS + 4,0 SAY REPLICATE('=',136)
HOJA = HOJA + 1
@ LINEAS + 5,COLUM SAY 'Codigo      Precio    |Codigo      Precio  |Codigo      Precio   |Codigo      Precio   |Codigo      Precio   |Codigo      Precio'
@ LINEAS + 6,0 SAY REPLICATE('=',136)
LINEAS = 14
RETURN
