SELE 1
USE ARTIC INDEX ARTIC

SELE 2
USE SUBCONJ INDEX SUBCONJ

SELE 4
USE SUBCONJ2 INDEX SUBCONJ2

SELE 3
USE MPRIMA INDEX MPRIMA

SELE 5
USE CONJUNTO INDEX CONJUNTO

SELE 6
USE CONJUN2 INDEX CONJUN2

SELE 12
USE PROVEDOR INDEX PROVEDOR

SELE 13
USE RUBROA INDEX RUBROA

SELE 15
USE AUXIACT2 INDEX AUXIACT2
ZAP

PRIVATE M_ESTADO,M_ARMA,M_ART,LETRA,MARCA,M_DES,M_PRO,M_PCRI,M_UNID,M_DESCU,M_COSTO,M_TPRE,M_STOCK,M_MEDIDA,M_COST
PRIVATE M_COSTOAN,M_COSTOA,M_LISTA1,M_LISTA2,M_LISTA3,M_LISTA4,M_RUB,M_PROV,M_LISTA5

SELE 2
SENIAL=.F.
DO WHILE .T.
   SELE 2
   CLEAR
   DO TITULO
   DO PANTSUB
   M_ART=SPACE(15)
   @ 4,28 GET M_ART PICT '@!' VALID VALVACIO(M_ART)
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   SEEK M_ART
   IF .NOT. FOUND()
      IF APRUEBA (24,0,39)
         @ 24,0 SAY SPACE(79)
         MARCA=.T.
         DO BLANSUB
         DO CARGA_SUB
         IF LASTKEY() = 27
            EXIT
         ENDIF
         IF APRUEBA  (24,0,2)
            @ 24,0 SAY SPACE(79)
            SELE 2
            APPEND BLANK
            DO GRABSUB
         ENDIF
      ENDIF
   ELSE
      MARCA=.F.
      DO BLANSUB
      DO MUESTSUB
      DO M_CARTEL WITH 35,24,0,.T.,.T.,.T.
      LETRA='M'
      @ 24,66 GET LETRA PICT 'A' VALID LETRA = 'B' .OR. LETRA = 'M'
      READ
      @ 24,0 SAY SPACE(79)
      IF LASTKEY()=27
         LOOP
      ENDIF
      IF LETRA='M'
         DO CARGA_SUB
         IF LASTKEY()=27
            LOOP
         ENDIF
         IF APRUEBA(24,0,36)
            IF SENIAL
               SELE 15
               APPEND BLANK
               REPLACE CODIGO WITH M_ART
               REPLACE COSTO_A WITH M_COSTO
               REPLACE COSTO_AN WITH M_COSTOA
               SENIAL=.F.
            ENDIF
            @ 24,0 SAY SPACE(79)
            DO GRABSUB
         ENDIF
      ELSE
         IF APRUEBA(24,0,6)
            DO BORRASUB
            LOOP
         ENDIF
      ENDIF
   ENDIF
ENDDO
SELE 15
IF .NOT. EOF()
   @ 24,0 SAY SPACE(79)
   do m_cartel with 94,24,0,.t.,.t.,.t.
   DO ACTUAR
ENDIF
CLOSE ALL
RETURN


PROCEDURE PANTSUB
********* *******

* Muestra la pantalla de articulos


@ 1,1 TO  23,79 DOUBLE
SET COLOR TO I
@ 2,28  SAY " - ABM de P. DE FABRICACION - "
SET COLOR TO
@ 3,2 TO 3,78
@ 4,4 SAY 'Codigo de Producto    :'
@ 6,3 SAY 'Descripci¢n :'
@ 8,3 SAY 'Componentes :'
@ 10,3 SAY 'Cantidad :'
@ 12,3 SAY 'Unidad :'
@ 14,3 SAY 'Dol. o Pesos : '
@ 10,45 SAY 'Costo de Armado :'
@ 12,45 SAY 'Precio de Costo :'
@ 14,45 say 'Stock :'
@ 16,3 SAY 'Lista 1 : '
@ 17,3 SAY 'Lista 2 : '
@ 18,3 SAY 'Lista 3 : '
@ 19,3 SAY 'Lista 4 : '
@ 19,45 SAY 'Lista 5 : '
@ 20,3 SAY 'Prov.   : '
@ 21,3 SAY 'Rubro   : '
DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
RETURN

PROCEDURE CARGA_SUB
*******************

* Carga de Datos del Articulo

IF .NOT. MARCA
   SET COLOR TO I
   @ 4,28 SAY M_ART PICT '@!'
   SET COLOR TO
ENDIF
SELE 2
@ 6,17 GET M_DES
READ
m_com=space(15)
m_cant=0
DO WHILE .T.
           m_com = sele_com(10,19,20)
           SEEK M_COM
           IF LASTKEY()=27
              IF APRUEBA (24,0,93)
                 @ 24,0 SAY SPACE(79)
                 LOOP
              ELSE
                 @ 24,0 SAY SPACE(79)
                 EXIT
              ENDIF
           ENDIF
           SET COLOR TO I
           @ 8,16 SAY MPRIMA->DESCR
           SET COLOR TO
           sele 4
           SEEK M_ART+M_COM
           IF  FOUND()
                 DO M_CARTEL WITH 35,24,0,.T.,.T.,.T.
                 LETRA='M'
                 @ 24,75 GET LETRA PICT 'A' VALID LETRA = 'B' .OR. LETRA = 'M'
                 READ
                 @ 24,0 SAY SPACE(79)
                 IF LASTKEY()=27
                    LOOP
                 ENDIF
                 IF LETRA='M'
                    M_CANT=CANTIDAD
                    SELE 3
                    SEEK M_COM
                    M_COST=M_COST-(M_CANT*COSTO)
                    SELE 4
                    SET COLOR TO I
                    @ 10,14 get m_cant PICT '#####.##'
                    SET COLOR TO
                    READ
                    REPLACE CANTIDAD WITH M_CANT
                    SELE 3
                    SEEK M_COM
                    M_COST=M_COST+(M_CANT*COSTO)
                    SELE 4
                    IF LASTKEY()=27
                       LOOP
                    ENDIF
                 ELSE
                    IF APRUEBA(24,0,6)
                       SELE 3
                       SEEK M_COM
                       SELE 4
                       M_COST=M_COST-(CANTIDAD*MPRIMA->COSTO)
                       DELETE
                       PACK
                       @ 24,0 SAY SPACE(79)
                       LOOP
                    ENDIF
                 ENDIF
            ELSE
                 M_CANT=0
                 @ 10,14 SAY SPACE(7)
                 SET COLOR TO I
                 @ 10,14 get m_cant PICT '#####.##'
                 SET COLOR TO
                 READ
                 append blank
                 replace codigo with m_art
                 replace m_prima with m_com
                 replace cantidad with m_cant
                 SELE 3
                 SEEK M_COM
                 M_COST=M_COST+(M_CANT*COSTO)
                 SELE 4
            ENDIF
ENDDO
DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
SELE 2
@ 8,17 SAY SPACE(15)
@ 10,14 SAY SPACE(12)
M_COSTOAN=ARMADO
M_COSTOA=COSTO
@ 12,12 GET M_UNID
@ 14,18 GET M_TPRE PICT 'A' VALID M_TPRE = 'D' .OR. M_TPRE = 'P'
@ 10,63 GET M_ARMA PICT '#########.#####'
READ
IF M_ARMA <> M_COSTOAN .AND. !MARCA
    SENIAL=.T.
ENDIF
@ 12,63 GET M_COSTO PICT '#########.#####'
@ 14,53 GET M_STOCK PICT '#####.##'
@ 16,14 GET M_LISTA1 PICT '#########.###'
@ 17,14 GET M_LISTA2 PICT '#########.###'
@ 18,14 GET M_LISTA3 PICT '#########.###'
@ 19,14 GET M_LISTA4 PICT '#########.###'
@ 19,53 GET M_LISTA5 PICT '#########.###'
READ
DO WHILE .T.
   SELE 12
   @ 20,14 GET M_PROV PICT '@!'
   READ
   IF LASTKEY() = 27
      RETURN
   ENDIF
   SEEK M_PROV
   IF !FOUND()
      DO M_CARTEL WITH 13,24,0,.T.,.T.,.T.
      ESPERAR(0)
      @ 24,0 SAY SPACE(79)
   ELSE
      SET COLOR TO I
      @ 20,45 SAY NOMBRE
      SET COLOR TO
      EXIT
   ENDIF
ENDDO
M_RUB = SELE_RUBA(15,30,20,M_RUB)
SET COLOR TO I
@ 21,30 SAY RUBROA->DESCR
SET COLOR TO
IF LASTKEY()=27
   RETURN
ENDIF
RETURN

PROCEDURE BLANSUB
******************

* Realiza el Blanqueo de las Variables, en el caso que se trate de una
* Baja o una Modificacion se cargan las Variables con los Datos del Archivo.
IF MARCA
   M_DES=SPACE(53)
   M_UNID=SPACE(5)
   M_ARMA=0
   M_COSTO = 0
   M_TPRE = 'D'
   M_STOCK = 0
   M_COST=0
   STOR 0 TO M_LISTA1,M_LISTA2,M_LISTA3,M_LISTA4,M_LISTA5
   M_RUB = 1
   M_PROV = SPACE(10)
ELSE
   M_ART=CODIGO
   M_DES=DESCR
   M_UNID=UNIDAD
   M_ARMA=ARMADO
   M_COSTO = COSTO
   M_TPRE = TPRE
   M_COST=COSTO_CO
   SELE 1
   SEEK M_ART
   M_STOCK = STOCK
   M_LISTA1 = LISTA1
   M_LISTA2 = LISTA2
   M_LISTA3 = LISTA3
   M_LISTA4 = LISTA4
   M_LISTA5 = LISTA5
   M_RUB = RUBRO
   M_PROV = COD_PROV
ENDIF
RETURN


PROCEDURE GRABSUB
*****************

* Grabacion del Registro.

SELE 2
REPLACE CODIGO WITH M_ART
REPLACE DESCR WITH M_DES
REPLACE UNIDAD WITH M_UNID
REPLACE ARMADO WITH M_ARMA
REPLACE COSTO WITH M_COSTO
REPLACE COSTO_CO WITH M_COST
REPLACE TPRE WITH M_TPRE
REPLACE STOCK WITH M_STOCK


SELE 1
SEEK M_ART
IF !FOUND()
   APPE BLANK
ENDIF
REPLACE COD_ART WITH M_ART
REPLACE DESCR WITH M_DES
REPLACE LISTA1 WITH M_LISTA1
REPLACE LISTA2 WITH M_LISTA2
REPLACE LISTA3 WITH M_LISTA3
REPLACE LISTA4 WITH M_LISTA4
REPLACE LISTA5 WITH M_LISTA5
REPLACE TPRE WITH M_TPRE
REPLACE FEAC WITH M_FECHA
REPLACE RUBRO WITH M_RUB
REPLACE COD_PROV WITH M_PROV
REPLACE COSTO WITH M_COSTO + M_ARMA
REPLACE STOCK WITH M_STOCK
REPLACE UNIDAD WITH M_UNID

if marca
   sele 10
   use movsub index movsub
   append blank
   replace CODIGO with m_art
   replace DESCR with m_DES
   replace c1 with 0
   replace c2 with 0
   replace c3 with 0
endif


RETURN


PROCEDURE MUESTSUB
*******************

* En Baja o Modificacion se Displayan los Datos del Articulo.
SET COLOR TO I
@ 6,17 SAY M_DES
SET COLOR TO
RETURN

PROCEDURE BORRASUB
******************
* Borra el registro seleccionado en todos los archivos.
SELE 1
SEEK M_ART
DELETE
PACK

SELE 2
DELETE
PACK

sele 4
seek m_art
do while CODIGO = m_art .and. .not. eof()
   delete
   skip
enddo
pack
return

PROCEDURE LIS_SUB
*****************
*Listado de Articulos

SELE 2
USE SUBCONJ INDEX SUBCONJ

SELE 4
USE SUBCONJ2 INDEX SUBCONJ2

SELE 3
USE MPRIMA INDEX MPRIMA

SELE 2
IMPRE = .F.
@ 24,0 SAY SPACE(79)
IF APRUEBA(24,0,11)
   IF ERROR_PRINT()
      RETURN
   ENDIF
   SET DEVICE TO PRINT
   IMPRE = .T.
ENDIF

GO TOP
LINEAS = 70
PRIMERA = .T.
HOJA = 1
DO WHILE !EOF()
   IF LINEAS > 65 .AND. IMPRE
      DO ENCASUB
   ELSE
      IF LINEAS > 20 .AND. !IMPRE
         DO ENCASUB
         IF LASTKEY() = 27
            GO BOTTOM
            SKIP
            LOOP
         ENDIF
      ENDIF
   ENDIF
   IF IMPRE
      @ PROW(), PCOL() SAY CHR(15)
      @ LINEAS,4 SAY CODIGO + '' + DESCR +'                  '+STR(COSTO)
   ELSE
      @ LINEAS,1 SAY CODIGO + '' + DESCR +'          '+STR(COSTO)
   ENDIF
   LINEAS = LINEAS + 1
   IF IMPRE
      m_cod=codigo
      sele 4
      seek m_cod
      do while m_COD = codigo .and. !eof()
         m_busco=m_prima
         sele 3
         seek m_busco
         @ lineas,90 say descr +''+str(subconj2->cantidad)
         sele 4
         LINEAS=LINEAS+1
         SKIP
      enddo
      @ PROW(), PCOL() SAY CHR(18)
    ENDIF
   SELE 2
   skip
ENDDO
IF IMPRE
   EJECT
   SET DEVICE TO SCREEN
ELSE
   DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
   ESPERAR(0)
ENDIF
CLOSE ALL
RETURN


PROCEDURE ENCASUB
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
@ LINEAS,15 SAY IIF(IMPRE,CHR(14),'         ') + ' * LISTADO DE SUBCONJUNTOS *'
@ LINEAS + 1,2 SAY 'Fecha: ' + DTOC(DATE())
@ LINEAS + 1,60 SAY 'Hoja Nro: ' + STR(HOJA,2,0)
IF IMPRE
   @ LINEAS + 3,3 SAY 'Codigo       Descripcion              Costo     Componentes        Cant.'
ELSE
   @ LINEAS + 3,3 SAY 'Codigo       Descripcion                             Costo'
ENDIF
@ LINEAS + 4,1 SAY REPLICATE('=',79)
LINEAS = 6
HOJA = HOJA + 1
RETURN

function sele_COM
*****************
*Selecciona Componentes

parameters f,c,t

sele 3

go top

if eof()
   do m_cartel with 105,24,0,.t.,.t.,.t.
   esperar(0)
   return('')
endif

declare v_com[RECCOUNT()]
declare v_cod[RECCOUNT()]

for i = 1 to reccount()
   v_com[I] = descr
   v_cod[I]=codigo
   skip
next
r=1
save screen to m_panta
DO WHILE .T.
     l = ventopcion('COMPONENTES  <F1> = LISTADO DE COMPONENTES',v_com,f,c,t,.t.,.t.,r)
     restore screen from m_panta
     if lastkey()=27
        return('')
     ENDIF
     IF LASTKEY() = 28
        DO LIS_COMP
        RESTORE SCREEN FROM M_PANTA
        LOOP
     ENDIF
     EXIT
ENDDO
return(v_cod[l])

PROCEDURE ACTUAR
****************


SELE 6
INDEX ON SUBCONJ TO PEPITO2

sele 15

GO TOP
DO WHILE .NOT. EOF()
   M_COD=CODIGO
   SELE 6
   SEEK M_COD
   DO WHILE .NOT. EOF() .AND. SUBCONJ=M_COD
      M_COSTO=(AUXIACT2->COSTO_A*CANTIDAD)
      M_COSTO1=(AUXIACT2->COSTO_AN*CANTIDAD)
      M_COD1=CODIGO
      SELE 5
      SEEK M_COD1
      M_COSTOAN=COSTO
      REPLACE COSTO_S WITH COSTO_S - M_COSTO1 + M_COSTO
      REPLACE COSTO WITH COSTO_S+ARMADO
      SELE 6
      SKIP
   ENDDO
 SELE 15
 SKIP
ENDDO

ERASE C:\SIAAC\PEPITO2.NTX
RETURN



PROCEDURE LIS_COMP
******************
*Lista de Componentes.

SELE 4
SEEK M_ART
CLEAR
LINEAS = 40
PRIMERA = .T.
DO WHILE !EOF() .AND. CODIGO = M_ART
         IF LINEAS > 20
               IF PRIMERA
                  PRIMERA = .F.
                  CLEAR
               ELSE
                  DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
                  ESPERAR(0)
                  CLEAR
               ENDIF
               @ 1,0 TO 23,79 DOUBLE
               SET COLOR TO I
               @ 3,25 SAY 'COMPONENTES DE ESTE ARTICULO'
               SET COLOR TO W+
               @ 4,1 SAY 'Articulo : ' + M_DES
               SET COLOR TO
               @ 5,1 TO 5,78
               @ 6,1 SAY 'Codigo M.P.    DESCRIPCION                           CANTIDAD'
               @ 7,1 TO 7,78
               LINEAS = 8
         ENDIF
         SELE 3
         SEEK SUBCONJ2->M_PRIMA
         SELE 4
         @ LINEAS,1 SAY M_PRIMA + ' ' + MPRIMA->DESCR + ' ' + TRANSFORM(CANTIDAD,'#########.##')
         LINEAS = LINEAS + 1
         SKIP
ENDDO
DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
ESPERAR(0)
RETURN
