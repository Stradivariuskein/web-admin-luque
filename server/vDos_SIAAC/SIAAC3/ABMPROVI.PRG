*ABM de PROVINCIAS

*if !seguridad(mm_clave,'E')
*   do m_cartel with 4,24,0,.t.,.t.,.t.
*   esperar(0)
*   return
*endif

sele 1
use PROVI INDEX PROVI

private M_COD,M_NOM,M_COEFI,M_COEFI1

M_COD =1
do while .t.
   clear
   do titulo
   do panTPROVI
   @ 5,22 get M_COD pict '###'
   read
   if lastkey()=27
      exit
   endif
   seek M_COD
   if .not. found()
      @ 24,0 say space(79)
      if aprueba (24,0,46)
         @ 24,0 say space(79)
         marca=.t.
         do blanPROVI
         do carga_PROVI
         if aprueba  (24,0,2)
            @ 24,0 say space(79)
            do grabPROVI
         endif
      endif
   else
      marca=.f.
      do blanPROVI
      do m_cartel with 35,24,0,.t.,.t.,.t.
      letra='M'
      @ 24,66 get letra pict 'A' valid letra = 'B' .or. letra = 'M'
      read
      @ 24,0 say space(79)
      if lastkey()=27
         loop
      endif
      if letra='M'
         do carga_PROVI
         if lastkey()=27
            loop
         endif
         if aprueba(24,0,36)
            @ 24,0 say space(79)
            do graBPROVI
         endif
      else
         if aprueba(24,0,37)
            do borraPROVI
            loop
         endif
      endif
   endif
enddo
close all
return

procedure pantPROVI
********* *******

@ 1,1 to  15,79 double
set color to i
@ 2,30  say " - ABM de PROVINCIAS - "
set color to
@ 3,2 to 3,78
@ 5,3 say 'Codigo de Prov. :'
@ 7,3 say 'Nombre          :'
@ 9,3  SAY 'Coefi.p/I.Brutos (P.fabricacion) :'
@ 11,3 say 'Coefi.p/I.Brutos (P.Terminados)  :'
do m_cartel with 1,24,0,.t.,.f.,.t.
return

procedure carga_PROVI
*******************
@ 7,21 get m_nom pict '@!'
@ 9,35 GET M_COEFI PICT '###.##'
@ 11,35 get m_coefi1 pict '###.##'
read
return

procedure blanPROVI
******************

if marca
   M_NOM=space(30)
   M_COEFI = 0
   M_COEFI1 = 0
else
   M_NOM= NOMBRE
   M_COEFI = COEFI
   M_COEFI1 = COEFI1
endif
return

procedure grabPROVI
*****************
* Grabacion del Registro.

IF MARCA
   append blank
ENDIF
REPLACE NUMERO WITH M_COD
REPLACE NOMBRE WITH M_NOM
REPLACE COEFI WITH M_COEFI
REPLACE COEFI1 WITH M_COEFI1
RETURN

procedure borraPROVI
******************
* Borra el registro seleccionado en todos los archivos.

sele 1
delete
pack
return

procedure lis_PROVI
*****************
*Listado de PROVINCIAS

sele 1
use provi INDEX PROVI

impre = .f.
@ 24,0 SAY SPACE(79)
if aprueba(24,0,11)
   impre = .t.
endif
if lastkey() = 27
   return
endif
do m_cartel with 10,24,0,.t.,.t.,.t.
esperar(0)
if lastkey() = 27
   return
endif
if impre
   set device to print
endif
go top
lineas = 66
primera = .t.
hoja = 1
do while !eof()
   if lineas > 65 .and. impre
      do enc_PROVI
   else
      if lineas > 20 .and. !impre
         do enc_PROVI
      endif
   endif
   @ lineas,0 say str(NUMERO,3,0)+'        ' + NOMBRE
   skip
   lineas = lineas + 1
enddo
if impre
   eject
   set device to screen
else
   @ 22,3 say 'Pulse Cualquier Tecla Para Continuar ...'
   esperar(0)
endif
close all
return

procedure enc_PROVI
******************
*Encabezamiento del Listado

if !primera
   if impre
      eject
   else
      @ 22,3 say 'Pulse Cualquier Tecla Para Continuar ...'
      esperar(0)
      @ 9,2 clear to 24,79
   endif
else
   primera = .f.
   if !impre
      @ 0,0 clear to 24,79
   endif
endif
lineas = 1
@ lineas,10 say iif(impre,chr(14),'                   ') + '* LISTADO DE PROVINCIAS * '
@ lineas + 2,2 say 'Fecha: ' + dtoc(date())
@ lineas + 2,50 say 'Hoja Nro : ' + str(hoja,1,2)
@ lineas + 4,5 say 'Nro.      NOMBRE'
hoja = hoja + 1
@ lineas + 5,2 say replicate('=',77)
lineas = 7
return


FUNCTION VALPROVI
*****************
PARAMETERS M_PROV,M_FILA,M_COLU

IF M_PROV = 99
   SET COLOR TO I
   @ M_FILA,M_COLU SAY 'TODAS'
   SET COLOR TO
   RETURN(.T.)
ENDIF


SELE 22
SEEK M_PROV
IF !FOUND()
    DO M_CARTEL WITH 84,24,0,.T.,.T.,.T.
    ESPERAR(0)
    RETURN(.F.)
ELSE
    SET COLOR TO I
    @ M_FILA,M_COLU SAY NOMBRE
    SET COLOR TO
    RETURN(.T.)
ENDIF
