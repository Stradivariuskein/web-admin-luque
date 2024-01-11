*ABM de RUBROS Y SUBRUBROS

*if !seguridad(mm_clave,'E')
*   do m_cartel with 4,24,0,.t.,.t.,.t.
*   esperar(0)
*   return
*endif
PARAMETERS CAJA

IF CAJA
   sele 5
   use rubroS index rubroS
ELSE
   SELE 5
   USE RUBROA INDEX RUBROA
ENDIF

private m_rub,letra,marca,m_des,m_subrub1,m_subrub2,m_subrub3,M_INGRES

sele 5
IF CAJA
   m_rub=1
ELSE
   M_RUB = SPACE(10)
ENDIF
do while .t.
   sele 5
   clear
   do titulo
   do pantrub
   IF CAJA
      @ 5,22 get m_rub PICT '####'
   ELSE
      @ 5,22 GET M_RUB PICT '@!'
   ENDIF
   read
   if lastkey()=27
      exit
   endif
   seek m_rub
   if .not. found()
      @ 16,0 say space(79)
      if aprueba (16,0,66)
         @ 16,0 say space(79)
         marca=.t.
         do blanvrub
         do carga_rub
         if aprueba  (16,0,2)
            @ 16,0 say space(79)
            do grabrub
         endif
      endif
   else
      marca=.f.
      do blanvrub
      do muestrub
      do m_cartel with 35,16,0,.t.,.t.,.t.
      letra='M'
      @ 16,66 get letra pict 'A' valid letra = 'B' .or. letra = 'M'
      read
      @ 16,0 say space(79)
      if lastkey()=27
         loop
      endif
      if letra='M'
         do carga_rub
         if lastkey()=27
            loop
         endif
         if aprueba(16,0,36)
            @ 16,0 say space(79)
            do grabrub
         endif
      else
         if aprueba(16,0,37)
            do borrarub
            loop
         endif
      endif
   endif
enddo
close all
return

procedure pantrub
********* *******
* Muestra la pantalla de rubros

@ 1,1 to  15,79 double
set color to i

IF CAJA
   @ 2,30  say " - ABM de RUBROS de CAJA - "
ELSE
   @ 2,28  say " - ABM de RUBROS de ARTICULOS - "
ENDIF

set color to
@ 3,2 to 3,78
@ 5,3 say 'Codigo de Rubro :'
@ 7,3 say 'Descripci¢n :'
IF CAJA
     @ 9,3 SAY '(I)ngreso o (E)greso : '
ENDIF
do m_cartel with 1,16,0,.t.,.f.,.t.
return

procedure carga_rub
*******************
* Carga de Datos de Rubros
if .not. marca
   set color to i
   @ 5,22 say m_rub pict '##########'
   set color to
endif
@ 7,18 get m_des PICT '@!S40'
IF CAJA
   @ 9,25 GET M_INGRES PICT 'A' VALID M_INGRES = 'I' .OR. M_INGRES = 'E'
ENDIF
read
return

procedure blanvrub
******************

* Realiza el Blanqueo de las Variables, en el caso que se trate de una
* Baja o una Modificacion se cargan las Variables con los Datos del Archivo.

if marca
   m_des=space(70)
   M_INGRES = 'I'
else
   m_des=descr
   IF CAJA
      M_INGRES = INGRES
   ENDIF
endif
return

procedure grabrub
*****************
* Grabacion del Registro.

if marca
   sele 5
   append blank
   replace cod_rub with m_rub
   replace descr with m_des
   IF CAJA
      REPLACE INGRES WITH M_INGRES
   ENDIF
else
   sele 5
   replace cod_rub with m_rub
   replace descr with m_des
   IF CAJA
      REPLACE INGRES WITH M_INGRES
   ENDIF
endif
return

procedure muestrub
******************

* En Baja o Modificacion se Displayan los Datos del Rubro.
set color to i
@ 5,22 say m_rub
set color to
@ 7,18 say SUBSTR(m_des,1,40)
return

procedure borrarub
******************
* Borra el registro seleccionado en todos los archivos.

sele 5
seek m_rub
delete
pack
return

procedure lis_rub
*****************
*Listado de Rubros y Subrubros
PARAMETERS CUAL

IF CUAL = 'R'
   sele 5
   use rubroS index rubroS
ELSE
   SELE 5
   USE RUBROA INDEX RUBROA
ENDIF
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
      do enc_rub
   else
      if lineas > 20 .and. !impre
         do enc_rub
      endif
   endif
   IF CUAL = 'R'
      @ lineas,1 say STR(cod_rub,10,0) +'        ' + descr
   ELSE
      @ lineas,1 say SUBSTR(cod_rub,1,10) +'        ' + descr
   ENDIF
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


*!*********************************************************************
*!
*!      Procedure: ENC_RUB
*!
*!      Called by: LIS_RUB        (procedure in ABMRUB.PRG)
*!
*!          Calls: ESPERAR()      (function  in SARAC.PRG)
*!               : IIF()          (function  in ?)
*!               : CHR()          (function  in ?)
*!               : DTOC()         (function  in ?)
*!               : DATE()         (function  in ?)
*!               : STR()          (function  in ?)
*!
*!*********************************************************************
procedure enc_rub
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
IF CUAL = 'R'
   @ lineas,10 say iif(impre,chr(14),'              ') + '* LISTADO DE RUBROS DE CAJA * '
ELSE
   @ lineas,10 say iif(impre,chr(14),'               ') + '* LISTADO DE RUBROS DE ARTICULOS * '
ENDIF
@ lineas + 2,2 say 'Fecha: ' + dtoc(date())
@ lineas + 2,50 say 'Hoja Nro : ' + str(hoja,1,2)
@ lineas + 4,5 say 'Nro.      Descripcion'
hoja = hoja + 1
@ lineas + 5,2 say replicate('=',77)
lineas = 7
return
