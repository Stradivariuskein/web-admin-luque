SET CONFIRM ON
SET DATE FRENCH
SET PATH TO
SET DEFA TO
SETCANCEL(.F.)

DECLARE CARTEL[57]

CARTEL[1]='   Movimientos - <Enter> selecciona - <ESC> = Fin '
CARTEL[2]=' APRUEBA INGRESO? (S/N): '
CARTEL[3]=' CONFIRMA BAJA? (S/N): '
CARTEL[4]=' SU CLAVE NO AUTORIZA A EJECUTAR ESTE PROCESO - Consulte Con El Jefe'
CARTEL[5]=' Escriba <LIBRE> Para Dar de BAJA'
CARTEL[6]=' OJO ! SERA DADO DE BAJA - APRUEBA S/N: '
CARTEL[7]=' LA CLAVE ELEGIDA NO EXISTE, DA DE ALTA S/N: '
CARTEL[8]=' EL EMPLEADO ELEGIDO NO EXISTE, DA DE ALTA S/N: '
CARTEL[9]='Escriba <LIS> para Listar Datos Por Impresora'
CARTEL[10]= 'POSICIONE EL PAPEL EN LA IMPRESORA - <ESC> Cancela'
CARTEL[11]= 'Desea El Listado Por Impresora S/N : '
CARTEL[12]= 'EL COLOR ELEGIDO NO EXISTE - Pulse Una Tecla Para Seguir'
CARTEL[13]= 'PROVEEDOR INEXISTENTE - Pulse Una Tecla Para Seguir'
CARTEL[14]= 'Escriba <NUEVA> Si quiere actualizar por Rangos '
CARTEL[15]= 'EL ARTICULO ELEGIDO NO EXISTE, Verif¡quelo'
CARTEL[16]= 'Escriba en Precio < -1 > si desea dar de BAJA '
CARTEL[17]= 'Actualizando Lista de Precios ... '
CARTEL[18]= 'Escriba <LIB>, para dar de BAJA'
CARTEL[19]= 'El Empleado Elegido NO EXISTE, Verif¡quelo'
CARTEL[20]= 'Pulse Cualquier Tecla Para Continuar'
CARTEL[21]= 'APRUEBA COMPROBANTE e IMPRIME ? S/N '
CARTEL[22]= 'Imprimiendo Comprobante ... '
CARTEL[23]= 'ANULA ITEM S/N '
CARTEL[24]= 'No se Registra Tanta Existencia de este Art¡culo'
CARTEL[25]= 'No esta registrado el precio de Dicho Articulo, OPERACION CANCELADA'
CARTEL[26]= 'Coloque Diskette en la Unidad <A>, Presione una tecla cuando este listo'
CARTEL[27]= 'Confirma el mes elegido S/N: '
CARTEL[28]= 'Procesando Operacion de Copia ... '
CARTEL[29]= 'Operaci¢n de Copia Finalizada, Pulse una Tecla para Seguir...'
CARTEL[30]= 'Procesando Operaci¢n de Depuraci¢n'
CARTEL[31]= 'EL COMPROBANTE ELEGIDO NO EXISTE, Verif¡quelo'
CARTEL[32]= 'Escriba <LIB> para dar de BAJA'
CARTEL[33]= 'Escriba <RANGO> Para Actualizar Por Rango de N£meros'
CARTEL[34]='   EL CLIENTE ELEGIDO NO EXISTE, DA DE ALTA S/N:   '
CARTEL[35]=' Desea Realizar una BAJA (B) o una MODIFICACION (M) : '
CARTEL[36]=' APRUEBA LA MODIFICACION S/N : '
CARTEL[37]=' APRUEBA LA BAJA S/N : '
CARTEL[38]='   EL VENDEDOR ELEGIDO NO EXISTE, DA DE ALTA S/N:   '
CARTEL[39]='   EL ARTICULO ELEGIDO NO EXISTE, DA DE ALTA S/N:   '
CARTEL[40]='EL CLIENTE ELEGIDO NO EXISTE, Verif¡quelo'
CARTEL[41]='DESEA EMITIR TAMBIEN MENSAJE DE COTIZACION S/N : '
CARTEL[42]='DESEA EMITIR REMITO DE ESTA FACTURA S/N : '
CARTEL[43]='El Comprobante Elegido No existe, Verif¡quelo'
CARTEL[44]='DESEA INGRESAR DATOS DESDE EL ARCHIVO MAILING S/N: '
CARTEL[45]='NO EXISTE EL CLIENTE SELECCIONADO,INGRESE DATOS X PANTALLA'
CARTEL[46]='INGRESE APELLIDO Y NOMBRE'
CARTEL[47]='DESEA EL LISTADO POR ORDEN NUMERICO o ALFABETICO o POR DIRECCION'
CARTEL[48]='DESEA EL LISTADO POR ORDEN ALFABETICO o C.P. o POR DIRECCION'
CARTEL[49]='DESEA SACAR EL COMPROBANTE POR IMPRESORA S/N: '
CARTEL[50]='POSICIONE EL PAPEL EN LA IMPRESORA - <ESC> PARA NO IMPRIMIR'
CARTEL[51]='NO SE PUDO EFECTUAR LA OPERACION DE GRABACION - VUELVA A INTENTAR'
CARTEL[52]='OPERACION DE GRABACION APROBADA'
CARTEL[53]='ERROR EN LA APERTURA DE ARCHIVOS, VUELVA A INTENTAR INGRESAR'
CARTEL[54]='EL PROVEDOR ELEGIDO NO EXISTE, DA DE ALTA'
CARTEL[55]='LA IMPRESORA NO ESTA EN LINEA o EL PAPEL ESTA MAL PUESTO, Verifiquela'
CARTEL[56]='ESTE COMPROBANTE NO CORRESPONDE AL CLIENTE ELEGIDO, VERIFIQUELO'
CARTEL[57]='AJUSTANDO SALDOS'

*================================================================
*
*                    TRONCO DEL PROGRAMA
*
*================================================================

*Presentacion del Sistema  e Iniciaci¢n

RUN FA VERIFICA.DBF /R-/HID- >NUL

DO BARRE WITH 'D'

PRIVATE MM_CLAVE,M_DIA,M_MES,M_FECHA,MLINEAS

MLINEAS = 0

IF !INICIO(.T.)
      CLOSE ALL
      CLEAR
      DO BARRE WITH 'P'
      RUN FA VERIFICA.DBF /R+/HID+ >NUL
      RETURN
ENDIF

DO PIDE_FECH
IF LASTKEY() = 27
  RETURN
ENDIF                                                                                                                                               ]
*PONER A QUE PRG VA
DO BUCKUP
RETURN


FUNCTION SEGURIDAD
******** *********
*Autoriza y Verifica Niveles de Seguridad Para Ejecutar Procesos
SELE 17
USE SEGURI
IF OP_ERROR()
   RETURN(.F.)
ENDIF

PARAMETERS I_CLAVE,PROCESO
GO TOP
DO WHILE !EOF()
     IF TRIM(CLAVE) = MM_CLAVE
         M_HABIL = HABILITA
     ENDIF
     SKIP
ENDDO
IF AT(PROCESO,M_HABIL) = 0
        SELE 17
        USE
        RETURN(.F.)
ELSE
        SELE 17
        USE
        RETURN(.T.)
ENDIF

FUNCTION VENTOPCION
* Genera ventana con opciones y captura opci¢n.
PARAMETERS VENT,TABLA,FIL,IZQ,TOPE,BESP,SALE_ESC,PRIOP
* VENT: Titulo de la ventana
* TABLA: Array con el contenido de la ventana
* FIL: Fila a patir de la cual se displaya la ventana
* IZQ: Columna a izquierda a partir de la cual se displaya la ventana (0=CENTRADO)
* TOPE: Fila tope maximo de la ventana
* BESP: Logico. Indica si se dibuja borde especial.
* SALE_ESC: Logico. Indica si se permite salida con la tecla ESC
* PRIOP: Primer opcion a posicionar el cursor dentro de la ventana (default: 1)
PRIVATE O,LONG,X,DER
* Calcula parametros de posicion en pantalla
* Col. derecha a partir de IZQ
DER=LEN(VENT)
FOR X=1 TO LEN(TABLA)
  DER=IIF(LEN(RTRIM(TABLA[X]))>DER,LEN(RTRIM(TABLA[X])),DER)
NEXT
IF IZQ=0
  IZQ=INT((79-DER)/2)
ENDIF
DER=IZQ+DER-1
* Fila TOPE a partir de FIL
TOPE=IIF(FIL+LEN(TABLA)-1< TOPE,FIL+LEN(TABLA)-1,TOPE)
* Dibuja ventana.
STOR DER+2-(IZQ-2) TO LONG
IF BESP
 FOR X=FIL-IIF(!EMPTY(VENT),4,2) TO TOPE+2
  @ X,IZQ-4 SAY REPLICATE(CHR(176),LONG+5)
 NEXT
ENDIF
@ FIL-IIF(!EMPTY(VENT),3,1),IZQ-2,TOPE+1,DER+2 BOX 'ÉÍ»º¼ÍÈº '
STOR DER+1-(IZQ-2) TO LONG
IF !EMPTY(VENT)
  @ FIL-1,IZQ-2 SAY CHR(204)+REPLICATE(CHR(205),LONG)+CHR(185)
  @ FIL-2,IZQ SAY VENT
ENDIF
* Captura opci¢n.
SE=SALE_ESC
O=ACHOICE(FIL,IZQ,TOPE,DER,TABLA,.T.,'TRAT_ACH',IIF(PCOUNT()=7,1,PRIOP),0)
RETURN (O)


FUNCTION TRAT_ACH
* Controla la sentencia achoice
PARAMETERS MODE,ELEM,POS_REL
DO CASE
   CASE MODE=0.OR.MODE=1.OR.MODE=2.OR.MODE=4
     RETURN(2)
   CASE MODE=3
     DO CASE
        CASE LASTKEY()=28
*         DO AYUDA
          SET CURSOR OFF
          RETURN(2)
        CASE LASTKEY()=13
          RETURN(1)
        CASE LASTKEY()=27
          RETURN(IIF(SE,0,2))
        CASE (LASTKEY()>64.AND.LASTKEY()<91).OR.(LASTKEY()>96.AND.LASTKEY()<123)
          RETURN(3)
        OTHERWISE
          RETURN(2)
     ENDCASE
ENDCASE


FUNCTION VALVACIO
* Valida que: - el ingreso de un campo numerico no sea 0
*             - el ingreso de un campo alfa no sea ''
PARAMETERS CAMPO
RETURN(!EMPTY(CAMPO))

FUNCTION INICIO
***************
* Inicializa el Sistema

PARAMETERS LOGO
IF !VERIFICA()
     CLEAR
     DO WHILE .T.
     ENDDO
ENDIF

IF LOGO
    CLEAR
    @ 1,0 TO 24,79 DOUBLE
    @ 18,15 SAY 'Sistema Integrado de Administraci¢n Asistida Por Computadora'
    @ 19,15 SAY '             Versi¢n 2.0 - D & D  Sistemas 1991'
ELSE
    CLEAR
ENDIF
@ 20,21 TO 23,67
@ 22,22 SAY 'INGRESE CLAVE de ACCESO: '
FILA =47
MM_CLAVE = ''
DO WHILE .T.
      Z = INKEY()
      IF Z = 13
          EXIT
      ELSE
         IF Z >=32 .AND. Z < 127
             @ 22,FILA SAY 'X'
             MM_CLAVE = MM_CLAVE + CHR(Z)
             FILA = FILA + 1
         ENDIF
      ENDIF
ENDDO

SET EXACT ON
SELE 17
USE SEGURI INDEX SEGURI

IF EMPTY(MM_CLAVE)
    MM_CLAVE = ' '
ENDIF

ENCONTRO = .F.
GO TOP
DO WHILE !EOF()
    IF RTRIM(CLAVE) = MM_CLAVE
          ENCONTRO = .T.
    ENDIF
    SKIP
ENDDO

IF !ENCONTRO
      SET COLOR TO I
      @  3,2 CLEAR TO 17,78
      SET COLOR TO
      DO M_CARTEL WITH 4,10,0,.T.,.T.,.T.
      ESPERAR(0)
      USE
      RETURN(.F.)
ELSE
      USE
      RETURN(.T.)
ENDIF

FUNCTION OP_ERROR
*****************

IF NETERR()
    DO M_CARTEL WITH 53,24,0,.T.,.T.,.T.
    ESPERAR(0)
    RETURN(.T.)
ENDIF
RETURN(.F.)



FUNCTION VALFECH
******** *******

PARAMETERS FECH

PRIVATE F_FECHA

F_FECHA = DTOC(FECH)

IF SUBSTR(F_FECHA,1,2) > '31' .OR. SUBSTR(F_FECHA,1,2) < '01'
      RETURN(.F.)
ENDIF
IF SUBSTR(F_FECHA,4,2) > '12' .OR. SUBSTR(F_FECHA,4,2) < '01'
      RETURN(.F.)
ENDIF
RETURN(.T.)



PROCEDURE M_CARTEL
******************
PARAMETERS NC,FIL,COL,ILUM,BEEP
*
*   Muestra un cartel determinado, utilizando para ello el valor
*   del parametro NC como posicion dentro del vector CARTEL.
*   Se manejan ademas los siguientes parametros:
*      1) FIL  se especifica la fila de la pantalla deseada.
*      2) COL  se especifica la columna de inicio del mensaje.
*              COL=0 -> CENTRALIZADO.
*      3) ILUM se indica si se desea sobreiluminar el mensaje.
*      4) BEEP se indica la emision de un BEEP (sonido) al visualizar
*         el mensaje.
*
IF FIL=23
   @ 23,1 SAY SPACE(76)
ENDIF
IF BEEP
 @ 23,78 SAY ''
 ? CHR(7)
ENDIF
IF COL=0
 COL=INT((79-LEN(CARTEL[NC]))/2)
ENDIF
IF ILUM
 SET COLOR TO I
ENDIF
@ FIL,COL SAY CARTEL[NC]
IF ILUM
 SET COLOR TO
ENDIF
RETURN


PROCEDURE TITULO
****************
*Pone titulo Margen Izquierdo de Pantalla
SET COLOR TO I
@ 0,0 SAY 'PAPELERA RB  -- Sistema de Ventas   ' + DTOC(M_FECHA)
SET COLOR TO
RETURN

FUNCTION ESPERAR
******** *******
* Detiene ejecucion hasta un teclazo del operador o un tiempo TIEMPO
PRIVATE TEC
PARAMETERS TIEMPO
SET CURSOR OFF
TEC=INKEY(TIEMPO)
SET CURSOR ON
RETURN (TEC)

FUNCTION BUSCA_TRA
******************
*Lockea un archivo abierto y si no puede iniste un cierto tiempo


HORA = 1
DO WHILE HORA <= 100
    IF FLOCK()
       @ 24,0 SAY SPACE(79)
       RETURN(.T.)
    ELSE
       HORA = HORA + 1
       IF HORA = 101
            SET DEVICE TO SCREEN
            DO M_CARTEL WITH 51,24,0,.T.,.T.,.T.
            ESPERAR(0)
            RETURN(.F.)
       ENDIF
   ENDIF
ENDDO


FUNCTION APRUEBA
******** *******
* Pide aprobacion de un proceso
PARAMETERS F,C,NC
* F: Fila
* C: Columna (0=centrado)
* NC: Nro. de cartel del array CARTEL definido en bloque principal
PRIVATE AP
DO M_CARTEL WITH NC,F,C,.T.,.T.,.T.
AP= 0
DO WHILE .T.
   AP = INKEY()
   IF  AP = 13 .OR. AP = 83
          RETURN(.T.)
   ELSE
          IF AP = 78
              RETURN(.F.)
          ENDIF
   ENDIF
ENDDO


PROCEDURE PIDE_FECH
*******************
*Pide Fecha Al Sistema

SELE 20
USE DOLAR
IF OP_ERROR()
   RETURN
ENDIF
SET INDEX TO DOLAR

DO WHILE .T.
    CLEAR
    SET COLOR TO I
    @ 0,0 SAY 'PAPELERA RB - SISTEMA DE VENTAS'
    SET COLOR TO
    @ 1,0 TO 23,79 DOUBLE
    M_FECHA = DATE()
    @ 12,18 TO 17,60
    @ 14,20 SAY 'Ingrese Fecha de Trabajo     : ' GET M_FECHA PICT '99/99/99' VALID VALFECH(M_FECHA)
    READ
    SELE 20
    IF BUSCA_TRA()
       SEEK M_FECHA
       UNLOCK
    ELSE
       RETURN
    ENDIF
    IF !FOUND()
        M_COTIZ = 0
        ESTA = .F.
    ELSE
        ESTA = .T.
        M_COTIZ = COTIZ
    ENDIF
    @ 16,20 SAY 'Ingrese Cotizaci¢n del D¢lar : ' GET M_COTIZ PICT '########' VALID M_COTIZ >=0
    READ
    IF LASTKEY() = 27
         CLOSE ALL
         CLEAR
         DO BARRE WITH 'P'
         RETURN
    ENDIF
    IF APRUEBA(24,0,2)
         M_MES = SUBSTR(DTOC(M_FECHA),4,2)
         M_DIA = SUBSTR(DTOC(M_FECHA),1,2)
         M_MES = VAL(M_MES)
         M_DIA = VAL(M_DIA)
      SELE 20
      IF BUSCA_TRA()
            IF !ESTA
                APPEND BLANK
            ENDIF
            REPLACE FECHA WITH M_FECHA
            REPLACE COTIZ WITH M_COTIZ
            UNLOCK
            BUSCO = .T.
            EXIT
      ENDIF
      EXIT
    ENDIF
ENDDO
SELE 20
USE
RETURN

FUNCTION VERIFICA
*****************
SELE 14
USE VERIFICA

IF TRIM(NOMBRE) = 'BARBETA'
      USE
      RETURN(.T.)
ELSE
      USE
      RETURN(.F.)
ENDIF

FUNCTION OPCIONES
* Displaya opciones de los distintos men£es y captura opcion.
PARAMETERS TIT,TAB_OP,TAB_ME
* TIT: Titulo del menu
* TAB_OP: Array con opciones del menu
* TAB_ME: Array con mensajes de las opciones
PRIVATE I,F,C,PA,O
* Borra pantalla.
@ 1,0,24,79 BOX '         '
SET COLOR TO I
@ 0,0 SAY 'PAPELERA RB  -- Sistema de Ventas   ' + DTOC(M_FECHA)
SET COLOR TO
* Calcula columna de display de opciones
C=LEN(TIT)
FOR I=1 TO LEN(TAB_OP)
   C=IIF(LEN(TAB_OP[I])>C,LEN(TAB_OP[I]),C)
NEXT I
C=INT((80-C)/2)
* Calcula fila de display de opciones
F=INT((22-(LEN(TAB_OP)+6))/2)
F=F+2
* Dibuja ventana de opciones
@ F,10,F+LEN(TAB_OP)+6-1,69 BOX 'ÉÍ»º¼ÍÈº '
@ F+2,10 SAY CHR(204)+REPLICATE(CHR(205),58)+CHR(185)
@ F+LEN(TAB_OP)+4-1,10 SAY CHR(204)+REPLICATE(CHR(205),58)+CHR(185)
* Displaya t¡tulo del men£.
SET COLOR TO I
@ F+1,12 SAY SPACE(56)
@ F+1,INT((80-LEN(TIT))/2) SAY TIT
SET COLOR TO
* Displaya opciones y captura.
SET MESSAGE TO F+LEN(TAB_OP)+5-1
STOR 1 TO PA
FOR L=F+3 TO F+3+LEN(TAB_OP)-1
 IF PCOUNT()=3
  @ L,C PROMPT TAB_OP[PA] MESSAGE TAB_ME[PA]
 ELSE
  @ L,C PROMPT TAB_OP[PA]
 ENDIF
 STOR PA+1 TO PA
NEXT
MENU TO O
RETURN (O)

PROCEDURE ABRE_SPOOL
********* **********
*Abre Archivos Para el Spool de la Red

IF MM_CLAVE = 'CAD'
    RUN SPOOL CREATE ARCHIMP.IMP TI=150 >NUL
ELSE
    RUN SPOOL CREATE ARCH.IMP TI=150 >NUL
ENDIF
RETURN

PROCEDURE IMP_SPOOL
********* *********
*Imprime lo que se halla cargado en el archivo de Spool

IF MM_CLAVE = 'CAD'
   RUN NPRINT  ARCHIMP.IMP NO BANNER NO FF
ELSE
   RUN NPRINT  ARCH.IMP NO BANNER NO FF >NUL
ENDIF
RUN ENDSPOOL >NUL
RETURN

PROCEDURE ARCH_EXCLU
********************
*Abre y cierra un Archivo en forma exclusiva

PARAMETERS ARCHIVO,AREA,M_EXCLU

SELE &AREA

M_EXCLUS = .F.
DO WHILE !M_EXCLUS
     IF M_EXCLU
        SET EXCLUSIVE ON
        IF !NETERR()
            M_EXCLUS = .T.
        ENDIF
     ELSE
        SET EXCLUSIVE OFF
        IF !NETERR()
            M_EXCLUS = .T.
        ENDIF
     ENDIF
ENDDO
USE &ARCHIVO
SET INDEX TO &ARCHIVO
RETURN

PROCEDURE CREAR_AR
********************
* Crea un archivo
PARAMETERS NOMBRE,T_CAMPOS,T_TIPOS,T_LONG,T_DEC,AREASEL,ABRIR
PRIVATE I
*
* NOMBRE: nombre del archivo (<8 caracteres maximo>.EXT)
* T_CAMPOS: array con nombre de los campos
* T_TIPOS: array con tipos de campos
* T_LONG: array con longitud de campos
* T_DEC: array con cantidad de decimales por campo
* AREASEL: area del SELE
* ABRIR: logico, indica si se abre el archivo en AREASEL
* Crea entrada a directorio
*
SELE &AREASEL
CREATE GENESIS.DBF
USE GENESIS
* Crea estructura
FOR I=1 TO LEN(T_CAMPOS)
   APPE BLANK
   REPLA FIELD_NAME WITH T_CAMPOS[I]
   REPLA FIELD_TYPE WITH T_TIPOS[I]
   REPLA FIELD_LEN WITH T_LONG[I]
   IF T_DEC[I]<>0
      REPLA FIELD_DEC WITH T_DEC[I]
   ENDIF
NEXT
CLOSE
* Crea la base utilizando el valor del par metro.
CREATE &NOMBRE FROM GENESIS.DBF
ERASE GENESIS.DBF
* Verifica si se desea la apertura de la Base.
IF ABRIR
   SELE &AREASEL
   USE &NOMBRE
ENDIF
RETURN

PROCEDURE BARRE
********* *****
PARAMETERS FUNC

PRIVATE I
DECLARE TABLA[ADIR("*.DBF")]
ADIR("*.DBF",TABLA)
FOR I=1 TO LEN(TABLA)
   S=BASEPD(TABLA[I],FUNC)
   IF S<>0
      CLEAR
      @ 24,25 SAY "PROBLEMAS CON EL ARCHIVO: "+TABLA[I]
      INKEY(0)
      CLEAR
   ENDIF
NEXT I
CLEAR
CLOSE ALL
RETURN

FUNCTION BASEPD
* Protege o desprotege un archivo.
* Devuelve: 1- Archivo inexistente
*           2- Error de lectura / grabacion
*           0- Ok
PRIVATE _NOM_ARCH,_LLAVE,_ARCH,HANDLE,SALE
PARAMETERS _NOM_ARCH,_LLAVE
IF UPPER(SUBSTR(_NOM_ARCH,LEN(_NOM_ARCH)-3,4))<>".DBF"
   _ARCH=_NOM_ARCH+".DBF"
ELSE
   _ARCH=_NOM_ARCH
ENDIF
IF .NOT. FILE("&_ARCH")
   RETURN(1)
ENDIF
IF _LLAVE="D" .OR. _LLAVE="d"
   SALE=""
ELSE
   SALE=")"
ENDIF
HANDLE = FOPEN ("&_ARCH",2)
IF FERROR() <> 0
   FCLOSE(HANDLE)
   RETURN(2)
ENDIF
FSEEK(HANDLE,0,0)
FWRITE(HANDLE,SALE,1)
FCLOSE(HANDLE)
RETURN(0)
