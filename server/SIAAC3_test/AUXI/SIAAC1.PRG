*******************************************************************************
*
* SISTEMA DE ADMINISTRACION ASISTIDO POR COMPUTADORA (SIAAC)  - D&D Sistemas.-
*
* ULTIMA ACTUALIZACION 07-11-91 - PRG. GENERAL PARA TODOS. - GIOVANI
*******************************************************************************

*Seteos Principales de Sistema

SET CONFIRM ON
SET DATE FRENCH
*SET PATH TO C:\SIAAC
*SET DEFA TO C:\SIAAC
SETCANCEL(.F.)
SET TALK OFF
SET SCOREBOARD OFF

*
* Array Con Los Carteles Para Mensajes Varios
*
DECLARE CARTEL[121]

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
CARTEL[15]= 'EL ARTICULO ELEGIDO NO EXISTE, Verif°quelo'
CARTEL[16]= 'Escriba en Precio < -1 > si desea dar de BAJA '
CARTEL[17]= 'Actualizando Lista de Precios ... '
CARTEL[18]= 'Escriba <LIB>, para dar de BAJA'
CARTEL[19]= 'El Empleado Elegido NO EXISTE, Verif°quelo'
CARTEL[20]= 'Pulse Cualquier Tecla Para Continuar <ESC> = Cancela'
CARTEL[21]= 'APRUEBA COMPROBANTE e IMPRIME ? S/N '
CARTEL[22]= 'Imprimiendo Comprobante ... '
CARTEL[23]= 'ANULA ITEM S/N '
CARTEL[24]= 'No se Registra Tanta Existencia de este Art°culo'
CARTEL[25]= 'EL BANCO ELEGIDO NO EXISTE, DA DE ALTA S/N: '
CARTEL[26]= 'Coloque Diskette en la Unidad <A>, Presione una tecla cuando este listo'
CARTEL[27]= 'Confirma el mes elegido S/N: '
CARTEL[28]= 'Procesando Operacion de Copia ... '
CARTEL[29]= 'Operaci¢n de Copia Finalizada, Pulse una Tecla para Seguir...'
CARTEL[30]= 'Procesando Operaci¢n de Depuraci¢n'
CARTEL[31]= 'EL COMPROBANTE ELEGIDO NO EXISTE, Verif°quelo'
CARTEL[32]= 'Escriba <LIB> para dar de BAJA'
CARTEL[33]= 'Escriba <RANGO> Para Actualizar Por Rango de N£meros'
CARTEL[34]='   EL CLIENTE ELEGIDO NO EXISTE, DA DE ALTA S/N:   '
CARTEL[35]=' Desea Realizar una BAJA (B) o una MODIFICACION (M) : '
CARTEL[36]=' APRUEBA LA MODIFICACION S/N : '
CARTEL[37]=' APRUEBA LA BAJA S/N : '
CARTEL[38]='   EL VENDEDOR ELEGIDO NO EXISTE, DA DE ALTA S/N:   '
CARTEL[39]='   EL ARTICULO ELEGIDO NO EXISTE, DA DE ALTA S/N:   '
CARTEL[40]='EL CLIENTE ELEGIDO NO EXISTE, Verif°quelo'
CARTEL[41]='DESEA EMITIR TAMBIEN MENSAJE DE COTIZACION S/N : '
CARTEL[42]='DESEA EMITIR REMITO DE ESTA FACTURA S/N : '
CARTEL[43]='El Comprobante Elegido No existe o ya esta cancelado , Verif°quelo'
CARTEL[44]='VERIFICANDO ARCHIVOS, ESPERE UNOS SEGUNDOS POR FAVOR...'
CARTEL[45]='SE DEBEN CARGAR PROVEEDORES PARA PODER EJECTUAR ESTA OPCION, Verifiquelo'
CARTEL[46]='LA PROVINCIA ELEGIDA NO EXISTE, DA DE ALTA S/N: '
CARTEL[47]='DESEA EL LISTADO POR ORDEN NUMERICO o ALFABETICO o POR DIRECCION'
CARTEL[48]='DESEA EL LISTADO POR ORDEN ALFABETICO o C.P. o POR DIRECCION'
CARTEL[49]='DESEA SACAR EL COMPROBANTE POR IMPRESORA S/N: '
CARTEL[50]='POSICIONE EL PAPEL EN LA IMPRESORA - <ESC> PARA NO IMPRIMIR'
CARTEL[51]='Incluye el Descuento Especial de Este Articulo S/N'
CARTEL[52]='EL PROVEEDOR ELEGIDO NO EXISTE, DA DE ALTA S/N'
CARTEL[53]='APRUEBA LA COMPRA S/N: '
CARTEL[54]='ESTE NUMERO INTERNO NO EXISTE, VERIFIQUELO'
CARTEL[55]='ESTA FACTURA YA HA SIDO CANCELADA, VERIFIQUELO'
CARTEL[56]='CODIGO INEXISTENTE, Verifiquelo'
CARTEL[57]='ESTA CANTIDAD SUPERA AL STOCK EXISTENTE, Verifiquelo o Ajuste el Stock'
CARTEL[58]='INCORPORA ESTE MOVIMIENTO AL REGISTRO DE CAJA S/N: '
CARTEL[59]='ESTE MOVIMIENTO YA FUE INGRESADO A CAJA, Verifiquelo'
CARTEL[60]='CANCELA LA OPERACION de COMPRA S/N: '
CARTEL[61]='NO SE REGISTRAN REMITOS PENDIENTES DE FACTURACION, VERIFIQUELO'
CARTEL[62]='AJUSTANDO SALDO DE LA CUENTA, POR FAVOR ESPERE UNOS SEGUNDOS...'
CARTEL[63]='NO SE PUEDE PAGAR UN RECIBO!!!, PULSE UNA TECLA PARA SEGUIR...'
CARTEL[64]='NO SE PUEDE PAGAR UN COMPROBANTE ANULADO!!!, PULSE UNA TECLA PARA SEGUIR...'
CARTEL[65]='NO SE PUEDE DAR INGRESO DE DATOS A CAJA A RUBROS QUE NO EXISTEN'
CARTEL[66]='EL RUBRO ELEGIDO NO EXISTE, DESEA DARLO DE ALTA S/N'
CARTEL[67]='ESTE ES EL DATO BUSCADO S/N : '
CARTEL[68]='NO HAY CARGADOS RUBROS DE ARTICULOS, VERIFIQUE ESO'
CARTEL[69]='ESTA FACTURA NO CORRESPONDE A ESTE CLIENTE, Verifiquelo'
CARTEL[70]='DESEA LISTAR LOS DOCUMENTOS QUE HAY EN CAJA S/N : '
CARTEL[71]='DEPOSITO INEXISTENTE, Verifiquelo'
CARTEL[72]='NO SE PUEDE INGRESAR 2 VECES EL MISMO ARTICULO Y DEPOSITO'
CARTEL[73]='MATERIA PRIMA INEXISTENTE, VERIFIQUELO'
CARTEL[76]='LA IMPRESORA NO ESTA CONECTADA O NO TIENE PAPEL, VERIFIQUELO'
CARTEL[78]='EL MOVIMIENTO DE CAJA ELEGIDO NO EXISTE, DA DE ALTA S/N: '
CARTEL[79]='NO EXISTE ESE NUMERO INTERNO DE DOCUMENTO, VERIFIQUELO'
CARTEL[80]='EL DOCUMENTO ELEGIDO YA FUE DADO DE BAJA, VERIFIQUELO'
CARTEL[81]='TERMINA DE CARGAR ITEMS S/N : '
CARTEL[82]='EL IMPORTE DE DOCUMENTOS ES DISTINTO AL CARGADO, ABANDONA OPERACION S/N'
CARTEL[83]='NO SE REGISTRAN CHEQUES EN CAJA QUE CUMPLAN ESA CONDICION, VERIFIQUELO'
CARTEL[84]='LA PROVINCIA ELEGIDA NO EXISTE, VERIFIQUELA'
CARTEL[85]='NO SE REGISTRAN FACTURAS PENDIENTES DE LIQUIDACION, VERIFIQUELO'
CARTEL[86]='CON FACTURAS CANCELADAS,NO SE PUEDE DAR DE BAJA A ESTE MOVIMIENTO DE CAJA'
CARTEL[87]='DESEA DAR DE BAJA A ESTE MOVIMIENTO'
CARTEL[88]='EL MOVIMIENTO ELEGIDO, NO CORRESPONDE A ESA OPERACION DE CAJA'
CARTEL[89]='NO SE PUEDE DAR DEBAJA A UN MOVIMIENTO DE CAJA CON DOCUMENTOS INGRESADOS'
CARTEL[90] = 'LA LISTA ELEGIDA NO EXISTE DA DE ALTA S/N: '
CARTEL[91] = 'DEBE GENERAR LA LISTA ELEGIDA Y LUEGO ACTUALIZARLA, VERIFIQUELO'
CARTEL[92] = 'NO SE REGISTRA NINGUNA LISTA CON ESE CODIGO, VERIFIQUELO'
CARTEL[93] = 'Desea Incorporar Otro Componente S/N : '
CARTEL[94] = 'Actualizando los costos, espere unos segundos por favor...'
CARTEL[95] = 'MATERIA PRIMA AFECTADA A UN PRODUCTO; NO SE PERMITE LA BAJA. VERIFIQUELO'
CARTEL[96] = 'CANCELA PEDIDO S/N : '
CARTEL[97] = '<?> = LISTADO DE ARTICULOS'
CARTEL[98] = 'EL PEDIDO ELEGIDO NO EXISTE, VERIFIQUELO'
CARTEL[99] = 'EL PEDIDO ELEGIDO NO CORRESPONDE A ESE CLIENTE, VERIFIQUELO'
CARTEL[100] = 'DEPURANDO ARCHIVOS, ESPERE UNOS SEGUNDOS POR FAVOR'
CARTEL[101] = 'EL PRODUCTO ELEGIDO NO EXISTE, VERIFIQUELO'
CARTEL[102] = 'ORDENANDO INFORMACION, ESPERE UNOS SEGUNDOS POR FAVOR'
CARTEL[103] = 'NO DESEA SACAR EL COMPROBANTE POR IMPRESORA S/N : '
CARTEL[104] = 'CLIENTE CON SALDO, IMPOSIBLE DAR DE BAJA, VERIFIQUELO'
CARTEL[105] = 'NO SE CARGARON COMPONENTES, VERIFIQUELO'
CARTEL[106] = 'ESTE REMITO NO CORRESPONDE A ESTE CLIENTE, VERIFIQUELO'
CARTEL[107] = 'CUIDADO, ESTE REMITO YA FUE FACTURADO <ESC> = CANCELA, OTRA TECLA SIGUE'
CARTEL[108] = 'EL RUBRO ELEGIDO NO CORRESPONDE CON LA OPERACION DE CAJA ELEGIDA, VERIFIQUELO'
CARTEL[109] = 'EL VENDEDOR ELEGIDO NO EXISTE, VERIFIQUELO'
CARTEL[110] = 'DESEA GENERAR UNA NOTA DE CREDITO POR DESCUENTO EN EL PAGO S/N : '
CARTEL[111] = 'CUIDADO EL PEDIDO ELEGIDO YA FUE COMPRADO, VERIFIQUELO'
CARTEL[112] = 'EL COMPROBANTE ELEGIDO YA EXISTE, VERIFIQUELO'
CARTEL[113] = 'PARA MODIFICAR O ANULAR INGRESE EL NUMERO DE ITEM DESEADO Y <ENTER>'
CARTEL[114] = '<ENTER> = MODIFICA ITEM | <F1> = ANULA ITEM'
CARTEL[115] = 'EL PEDIDO ELEGIDO YA FUE ENTREGADO, VEIRIFIQUELO'
CARTEL[116] = 'SE VA A IMPRIMIR EL ORIGINAL  S/N : '
CARTEL[117] = 'EL IMPORTE CARGADO EN FACTURAS ES DISTINTO AL CARGADO EN CAJA, VERIFIQUELO'
CARTEL[118] = 'DESEA REGISTRAR VALORES EN CAJA S/N : '
CARTEL[119] = 'PROCESANDO INFORMACION, ESPERE UNOS SEGUNDOS POR FAVOR'
CARTEL[120] = 'EL BANCO ELEGIDO NO EXISTE, VERIFIQUELO'
CARTEL[121] = 'LA OPERACION DE CAJA ELEGIDA NO EXISTE, VERIFIQUELO'

*================================================================
*
*                    TRONCO DEL PROGRAMA
*
*================================================================

*Presentacion del Sistema  e Iniciaci¢n

*RUN FA VERIFICA.DBF /R-/HID- >NUL

*DO BARRE WITH 'D'

PRIVATE MM_CLAVE,M_DIA,M_MES,M_FECHA,MLINEAS

MLINEAS = 0

IF !INICIO(.T.)
   CLOSE ALL
   CLEAR
*   DO BARRE WITH 'P'
*   RUN FA VERIFICA.DBF /R+/HID+ >NUL
   RETURN
ENDIF
DO PIDE_FECH
IF LASTKEY() = 27
   RETURN
ENDIF
DO WHILE .T.
                DECLARE MENPEE[13]
                DECLARE OPPEE[13]
                OPPEE[1]=  'ABM de ARCHIVOS MAESTROS'
                OPPEE[2]=  'COMPRAS de MERCADERIA'
                OPPEE[3]=  'FACTURACION'
                OPPEE[4]=  'STOCK'
                OPPEE[5]=  'MOVIMIENTOS de CAJA'
                OPPEE[6]=  'ABM de PEDIDOS'
                OPPEE[7]=  'EMISION de NOTAS de ENVIO'
                OPPEE[8]=  'LISTADOS VARIOS'
                OPPEE[9]=  'CONSULTAS DE COMPROBANTES'
                OPPEE[10] ='CONSULTAS DE CTAS. CTES. CLIENTES'
                OPPEE[11] ='LIQUIDACION de COMISIONES a VENDEDORES'
                OPPEE[12] ='ESTADISTICAS de VENTAS'
                OPPEE[13] ='FIN de OPERACIONES'

                MENPEE[1]='          ∫Altas, Bajas y Modificaciones de Archivos Principales'
                MENPEE[2]='          ∫Compra de Mercaderia a Proveedores - Factura y Carga IVA'
                MENPEE[3]='          ∫Sistema de Facturaci¢n, Devoluciones y Cambios'
                MENPEE[4]='          ∫Sistema de Control y Actualizaci¢n de Stock'
                MENPEE[5]='          ∫Movimientos de Caja'
                MENPEE[6]='          ∫Pedidos de Clientes y Proveedores'
                MENPEE[7]='          ∫Copia y Recuperacion de Archivos en Diskettes'
                MENPEE[8]='          ∫Listados de IVA Compras-Ventas, etc'
                MENPEE[9]='          ∫Consulta de Comprobantes Anteriores'
                MENPEE[10]='          ∫Consulta de Saldos de Clientes'
                MENPEE[11]='          ∫Liquidacion de Comisiones por Ventas'
                MENPEE[12]='          ∫Estadisticas de Ventas'
                MENPEE[13]='          ∫Salir al DOS'

         *    Displaya opciones y captura.
         OPPE=OPCIONES('SISTEMA DE VENTAS - OPCIONES PRINCIPALES',OPPEE,MENPEE)
         *    Fin
         DO CASE
         CASE OPPE=1
            IF !SEGURIDAD(MM_CLAVE,'A')
               DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
               ESPERAR(0)
               LOOP
            ENDIF
            DO ABM
         CASE OPPE=2
            IF !SEGURIDAD(MM_CLAVE,'C')
               DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
               ESPERAR(0)
               LOOP
            ENDIF
            DO COMPRAS
         CASE OPPE=3
            IF !SEGURIDAD(MM_CLAVE,'D')
               DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
               ESPERAR(0)
               LOOP
            ENDIF
            DO FACTURA
         CASE OPPE=4
            IF !SEGURIDAD(MM_CLAVE,'E')
               DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
               ESPERAR(0)
               LOOP
            ENDIF
            DO STOCK
         CASE OPPE = 5
            IF !SEGURIDAD(MM_CLAVE,'F')
               DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
               ESPERAR(0)
               LOOP
            ENDIF
            DO CAJA3
         CASE OPPE = 6
            IF !SEGURIDAD(MM_CLAVE,'G')
               DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
               ESPERAR(0)
               LOOP
            ENDIF
            DO MENPEDI
         CASE OPPE = 7
            IF !SEGURIDAD(MM_CLAVE,'H')
               DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
               ESPERAR(0)
               LOOP
            ENDIF
            DO ENVIO
         CASE OPPE = 8
            IF !SEGURIDAD(MM_CLAVE,'I')
               DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
               ESPERAR(0)
               LOOP
            ENDIF
            DO LISTADOS
         CASE OPPE = 9
            IF !SEGURIDAD(MM_CLAVE,'J')
               DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
               ESPERAR(0)
               LOOP
            ENDIF
            DO CONSULTA
         CASE OPPE = 10
            IF !SEGURIDAD(MM_CLAVE,'K')
               DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
               ESPERAR(0)
               LOOP
            ENDIF
            DO MENCTE
         CASE OPPE = 11
             IF !SEGURIDAD(MM_CLAVE,'M')
                DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
                ESPERAR(0)
                LOOP
             ENDIF
             DO LIQ_COM
         CASE OPPE = 12
             IF !SEGURIDAD(MM_CLAVE,'M')
                DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
                ESPERAR(0)
                LOOP
             ENDIF
             DO ESTADIS
         CASE OPPE = 13
            EXIT
         ENDCASE
ENDDO
CLEAR
CLOSE ALL
*RUN FA VERIFICA.DBF /R+/HID+ >NUL
*DO BARRE WITH 'P'
RETURN

PROCEDURE ABM
*Menu de ABM de Archivos Principales (Programas por Separado)

*Borrar Asteriscos si se Necesita Niveles de Seguridad
*
*IF !SEGURIDAD(MM_CLAVE,'A')
*     DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*     ESPERAR(0)
*     RETURN
*ENDIF

DO WHILE .T.
   DECLARE MENPEE[13]
   DECLARE OPPEE[13]
   OPPEE[1]='ABM de CLIENTES - Para Ventas'
   OPPEE[2]='ABM de ARTICULOS'
   OPPEE[3]='ABM de LISTA DE PRECIOS'
   OPPEE[4]='ABM de PROVEEDORES'
   OPPEE[5]='ABM de VENDEDORES'
   OPPEE[6]='ABM de EXPRESOS'
   OPPEE[7]='ABM de IVA'
   OPPEE[8]='ABM de RUBROS de CAJA'
   OPPEE[9]='ABM de RUBROS de ARTICULOS'
   OPPEE[10] = 'ABM de PROVINCIAS'
   OPPEE[11] = 'ABM de CLAVES de SEGURIDAD'
   OPPEE[12] = 'ABM de BANCOS'
   OPPEE[13] = 'LISTADOS VARIOS'

   MENPEE[1]='          ∫Altas, Bajas y Modif. de Clientes Activos'
   MENPEE[2]='          ∫Altas, Bajas y Modif. de Especificaciones de Articulos'
   MENPEE[3]='          ∫Altas, Bajas y Modif. de Lista de Precios'
   MENPEE[4]='          ∫Altas, Bajas y Modif. de Proveedores'
   MENPEE[5]='          ∫Altas, Bajas y Modif. de Vendedores'
   MENPEE[6]='          ∫Altas, Bajas y Modif. de Expresos'
   MENPEE[7]='          ∫Altas, Bajas y Modif. de % DE IVA'
   MENPEE[8]='          ∫Altas, Bajas y Modificaciones de Rubros de CAJA'
   MENPEE[9]='          ∫Altas, Bajas y Modificaciones de Rubros de ARTICULOS'
   MENPEE[10]='          ∫Altas, Bajas y Modificaciones de Provincias'
   MENPEE[11]='          ∫Altas, Bajas y Modificaciones de Claves'
   MENPEE[12]='          ∫Altas, Bajas y Modificaciones de Bancos'
   MENPEE[13]='          ∫Listados Varios'

   *    Displaya opciones y captura.
   OPPE=OPCIONES('SISTEMA DE VENTAS - ABM DE ARCHIVOS MAESTROS',OPPEE,MENPEE)
   *    Fin
   IF LASTKEY()=27
      EXIT
   ENDIF
   DO CASE
   CASE OPPE = 1
      DO ABMCLI WITH .T.
   CASE OPPE = 2
      DO ABMARTI
   CASE OPPE = 3
      DO ABMLPREC
   CASE OPPE = 4
      DO ABMPROV WITH .T.
   CASE OPPE = 5
      DO ABMVEND
   CASE OPPE = 6
      DO ABMEXPR
   CASE OPPE = 7
      DO ABMIVA
   CASE OPPE = 8
      DO ABMRUB WITH .T.
   CASE OPPE = 9
      DO ABMRUB WITH .F.
   CASE OPPE = 10
      DO ABMPROVI
   CASE OPPE = 11
      DO ABMCLAV
   CASE OPPE = 12
      DO ABMBANCO
   CASE OPPE = 13
      DO LIST_VS
   ENDCASE
ENDDO
RETURN

PROCEDURE LIST_VS
******************

DO WHILE .T.
     DECLARE MENPEE[6]
     DECLARE OPPEE[6]
     OPPEE[1]='LISTADO de ARTICULOS'
     OPPEE[2]='LISTADO de CLIENTES'
     OPPEE[3]='LISTADO de PROVEEDORES'
     OPPEE[4]='LISTADO de RUBROS de CAJA'
     OPPEE[5]='LISTADO de RUBROS de ARTICULOS'
     OPPEE[6]='LISTADO de PROVINCIAS'

     MENPEE[1]='          ∫Listado de Articulos'
     MENPEE[2]='          ∫Listado de Clientes'
     MENPEE[3]='          ∫Listado de Proveedores'
     MENPEE[4]='          ∫Listado de rubros de Caja'
     MENPEE[5]='          ∫Listado de Rubros de Articulos'
     MENPEE[6]='          ∫Listado de Provincias'

     *    Displaya opciones y captura.
     OPPE=OPCIONES('SISTEMA DE VENTAS - LISTADO VARIOS',OPPEE,MENPEE)
     *    Fin
     IF LASTKEY()=27
        EXIT
     ENDIF
     DO CASE
     CASE OPPE = 1
        DO LIS_ART WITH .T.
     CASE OPPE = 2
        DO LIS_CLI WITH 'A'
     CASE OPPE = 3
        DO LIS_PROV
     CASE OPPE = 4
        DO LIS_RUB WITH 'R'
     CASE OPPE = 5
        DO LIS_RUB WITH 'A'
     CASE OPPE = 6
        DO LIS_PROVI
     ENDCASE
ENDDO
RETURN


PROCEDURE PIDE_FECH
*******************
*Pide Fecha Al Sistema

SELE 20
USE DOLAR INDEX DOLAR

DO WHILE .T.
   CLEAR
   SET COLOR TO I
   @ 0,0 SAY 'LUQUE              - SISTEMA DE VENTAS'
   SET COLOR TO
   @ 1,0 TO 23,79 DOUBLE
   M_FECHA = DATE()
   @ 12,18 TO 17,60
   @ 14,20 SAY 'Ingrese Fecha de Trabajo     : ' GET M_FECHA PICT '99/99/99' VALID VALFECH(M_FECHA)
   READ
   SELE 20
   SEEK M_FECHA
   IF !FOUND()
      M_COTIZ = 0
      ESTA = .F.
   ELSE
      ESTA = .T.
      M_COTIZ = COTIZ
   ENDIF
   @ 16,20 SAY 'Ingrese Cotizaci¢n del D¢lar : ' GET M_COTIZ PICT '####.###' VALID M_COTIZ >=0
   READ
   IF LASTKEY() = 27
      CLOSE ALL
      CLEAR
*      DO BARRE WITH 'P'
      RETURN
   ENDIF
   IF APRUEBA(24,0,2)
      M_MES = SUBSTR(DTOC(M_FECHA),4,2)
      M_DIA = SUBSTR(DTOC(M_FECHA),1,2)
      M_MES = VAL(M_MES)
      M_DIA = VAL(M_DIA)
      SELE 20
      IF !ESTA
         APPEND BLANK
      ENDIF
      REPLACE FECHA WITH M_FECHA
      REPLACE COTIZ WITH M_COTIZ
      EXIT
   ENDIF
ENDDO
SELE 20
USE
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
* Crea la base utilizando el valor del par†metro.
CREATE &NOMBRE FROM GENESIS.DBF
ERASE GENESIS.DBF
* Verifica si se desea la apertura de la Base.
IF ABRIR
   SELE &AREASEL
   USE &NOMBRE
ENDIF
RETURN

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
@ 24,0 SAY SPACE(79)
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
@ 0,0 SAY 'LUQUE              -- Sistema de Ventas   ' + DTOC(M_FECHA)
SET COLOR TO
RETURN

FUNCTION SELE_PROV
******************
*Selecciona Proveedore

PARAMETERS F,C,T

SELE 12
GO TOP
IF EOF()
   DO M_CARTEL WITH 45,24,0,.T.,.T.,.T.
   ESPERAR(0)
   RETURN('')
ENDIF
DECLARE V_PROVE[RECCOUNT()]
DECLARE V_COD[RECCOUNT()]
FOR I = 1 TO RECCOUNT()
   V_PROVE[I] = NOMBRE
   V_COD[I] = COD_PRO
   SKIP
NEXT

SAVE SCREEN TO M_PANTA
LLL = VENTOPCION('PROVEEDORES',V_PROVE,F,C,T,.T.,.T.,1)
RESTORE SCREEN FROM M_PANTA
IF LASTKEY() = 27
   RETURN('')
ENDIF
RETURN(V_COD[LLL])


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
@ 0,0 SAY 'LUQUE              -- Sistema de Ventas   ' + DTOC(M_FECHA)
SET COLOR TO
DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
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
@ F,10,F+LEN(TAB_OP)+6-1,69 BOX '…Õª∫ºÕ»∫ '
@ F+2,10 SAY CHR(204)+REPLICATE(CHR(205),58)+CHR(185)
@ F+LEN(TAB_OP)+4-1,10 SAY CHR(204)+REPLICATE(CHR(205),58)+CHR(185)
* Displaya t°tulo del men£.
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

FUNCTION ESPERAR
******** *******
* Detiene ejecucion hasta un teclazo del operador o un tiempo TIEMPO
PRIVATE TEC
PARAMETERS TIEMPO
SET CURSOR OFF
TEC=INKEY(TIEMPO)
SET CURSOR ON
RETURN (TEC)

FUNCTION VALPREG
******** *******
* Valida ingreso de respuestas del operador.
PARAMETERS ING
IF UPPER(ING)<>'S'.AND.UPPER(ING)<>'N'
   RETURN (.F.)
ELSE
   RETURN (.T.)
ENDIF


FUNCTION SEGURIDAD
******** *********
*Autoriza y Verifica Niveles de Seguridad Para Ejecutar Procesos
SELE 17
USE SEGURI

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
DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
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
@ FIL-IIF(!EMPTY(VENT),3,1),IZQ-2,TOPE+1,DER+2 BOX '…Õª∫ºÕ»∫ '
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
      RETURN(1)
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

PROCEDURE BARRE
********* *****
PARAMETERS M_FUNC
DO M_CARTEL WITH 44,24,0,.T.,.F.,.T.
PRIVATE I
DECLARE TABLA[ADIR("*.DBF")]
ADIR("*.DBF",TABLA)
FOR I=1 TO LEN(TABLA)
   S=BASEPD(TABLA[I],M_FUNC)
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
   DO PANTA
ELSE
   CLEAR
ENDIF
@ 20,1 TO 23,40
@ 22,2 SAY 'INGRESE CLAVE de ACCESO: '
FILA =27
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
   IF TRIM(CLAVE) = MM_CLAVE
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


*******************************************************************************
* Programa de la presentacion del sistema SIAAC.                              *
*******************************************************************************
PROCEDURE PANTA

CLEAR
@ 11,39 TO 13,41 DOUBLE
ESPERAR (0.1)
CLEAR
@ 10,35 TO 14,43 DOUBLE
ESPERAR (0.1)
CLEAR
@ 9,31 TO 15,47 DOUBLE
ESPERAR (0.1)
CLEAR
@ 8,27 TO 16,51 DOUBLE
ESPERAR (0.1)
CLEAR
@ 7,23 TO 17,55 DOUBLE
ESPERAR (0.1)
CLEAR
@ 6,19 TO 18,59 DOUBLE
ESPERAR (0.1)
CLEAR
@ 5,15 TO 19,63 DOUBLE
ESPERAR (0.1)
CLEAR
@ 4,11 TO 20,67 DOUBLE
ESPERAR (0.1)
CLEAR
@ 3,7 TO 21,71 DOUBLE
ESPERAR (0.1)
CLEAR
@ 2,3 TO 22,75 DOUBLE
ESPERAR (0.1)
CLEAR
@ 1,1 TO 23,79 DOUBLE
DO PRESENTA
RETURN

PROCEDURE PRESENTA
******************

DECLARE TABLA[8]
TABLA[1]=" ∞∞∞∞∞∞∞∞∞∞  ∞        ∞               ∞         ∞∞∞∞∞∞∞∞∞∞   "
TABLA[2]=" ∞           ∞       ∞ ∞             ∞ ∞        ∞            "
TABLA[3]=" ∞           ∞      ∞   ∞           ∞   ∞       ∞            "
TABLA[4]=" ∞∞∞∞∞∞∞∞∞∞  ∞     ∞     ∞         ∞     ∞      ∞            "
TABLA[5]="          ∞  ∞    ∞∞∞∞∞∞∞∞∞       ∞∞∞∞∞∞∞∞∞     ∞            "
TABLA[6]="          ∞  ∞   ∞         ∞     ∞         ∞    ∞            "
TABLA[7]="          ∞  ∞  ∞           ∞   ∞           ∞   ∞            "
TABLA[8]=" ∞∞∞∞∞∞∞∞∞∞  ∞ ∞             ∞ ∞             ∞  ∞∞∞∞∞∞∞∞∞∞   "

LINEA_ABA=8
COL_ABA=8
TIEMPO=0.01
BORRA=.F.

CLEAR
SET CURSOR OFF
T_BORRA=0.05
PASOS=0
FOR CICLO=1 TO 8
   @ LINEA_ABA+CICLO,COL_ABA SAY TABLA[ciclo]
   SET COLOR TO
NEXT
FOR ZZ=1 TO 1
   FOR I=1 TO 1
      @ I,I TO 25-I,79-I DOUBLE
      INKEY(.1)
      @ I,I,25-I,79-I BOX "        "
   NEXT
NEXT
SET COLOR TO I
@ 18,43 say " SISTEMA DE VENTAS  V. 1.00          "
@ 19,43 say " Copyright DOGMAY Computacion 1992  "
@ 20,43 SAY " Software,Equipamientos y Accesorios"
@ 21,43 say " Gasc¢n 826 14 'F'  Capital Federal "
@ 22,43 say " Telefono : 87-8725 C.P. 1181       "
@ 23,43 say " Todos los derechos reservados.     "
SET COLOR TO
@ 1,0 TO 24,79 DOUBLE
SET CURSOR ON
RETURN


FUNCTION VERIFICA
*****************
RETURN(.T.)
SELE 1
USE AUXI00
GO TOP

SELE 2
USE AUXI01
GO TOP

RUN SI >COPIA.DAT

APPEND FROM COPIA.DAT SDF
ERASE C:COPIA.DAT
GO TOP
DO WHILE !EOF() .AND. RECNO() <= 4
   IF RTRIM(DATOS) <> TRIM(AUXI00->DATOS)
      @ 24,0 SAY 'SISTEMA PARADO'
      CLOSE ALL
      QUIT
   ELSE
      SELE 1
      SKIP
      SELE 2
      SKIP
   ENDIF
ENDDO
SELE 2
DELE ALL
PACK
CLOSE ALL

SELE 14
USE VERIFICA

IF TRIM(NOMBRE) = 'BARBETA'
   USE
   RETURN(.T.)
ELSE
   USE
   RETURN(.F.)
ENDIF
*: EOF: SIAAC1.PRG


PROCEDURE CONS_VEN
******************
*Consulta de Acumulados de Ventas

*IF !SEGURIDAD(MM_CLAVE,'T')
*     DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*     ESPERAR(0)
*     RETURN
*ENDIF

SELE 14
USE ACUM INDEX ACUM

SELE 15
USE AUXILI4 INDEX AUXILI4

R5 = .F.

DO WHILE .T.
    CLEAR
    DO TITULO
    @ 1,0 TO 23,79 DOUBLE
    IF R5
       @ 23,79 SAY '.'
    ENDIF
    SET COLOR TO I
    @ 3,20 SAY ' * CONSULTA DE ACUMULADOS DE VENTAS * '
    SET COLOR TO
    @ 10,2 TO 17,78
    M_DESDE = DATE()
    M_HASTA = DATE()
    @ 13,5 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
    @ 13,50 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
    ESPERAR(0)
    IF LASTKEY() = 106
          IF !R5
             ?? CHR(7)
             @ 23,79 SAY '.'
             R5 = .T.
          ELSE
             @ 1,0 TO 23,79 DOUBLE
             R5 = .F.
          ENDIF
    ENDIF
    IF LASTKEY() = 27
            EXIT
    ENDIF
    READ
    IF LASTKEY() = 27
          EXIT
    ENDIF
    MES_D = VAL(SUBSTR(DTOC(M_DESDE),4,2))
    MES_H = VAL(SUBSTR(DTOC(M_HASTA),4,2))
    DIA_D = VAL(SUBSTR(DTOC(M_DESDE),1,2))
    DIA_H = VAL(SUBSTR(DTOC(M_HASTA),1,2))
    IF R5
      SELE 15
    ELSE
      SELE 14
    ENDIF
    GO TOP
    M_COMPRO = 0
    M_ACUM = 0
    IMPRE = .F.
    IF APRUEBA(24,0,11)
       SET DEVICE TO PRINT
       IMPRE = .T.
    ENDIF
    DO WHILE !EOF()
       IF VAL(MES) >= MES_D .AND. VAL(MES) <= MES_H .AND. VAL(DIA) >= DIA_D .AND. VAL(DIA) <= DIA_H
          M_COMPRO = M_COMPRO + CANT_COMPR
          M_ACUM = M_ACUM + ACUM
          SKIP
       ELSE
          SKIP
       ENDIF
    ENDDO
    DO TITULO
    IF IMPRE
          @ 3,15 SAY CHR(14) + ' * ACUMULADO de VENTAS * '
          @ 5,3 SAY 'Desde Fecha: ' + DTOC(M_DESDE)
          @ 7,3 SAY 'Hasta Fecha: ' + DTOC(M_HASTA)
    ELSE
          CLEAR
          DO TITULO
          @ 1,0 TO 23,79
          @ 3,25 SAY  ' * ACUMULADO de VENTAS * '
          @ 5,3 SAY 'Desde Fecha: ' + DTOC(M_DESDE)
          @ 7,3 SAY 'Hasta Fecha: ' + DTOC(M_HASTA)
    ENDIF
    @ 10,3 SAY 'Total de Ventas                : ' + STR(M_ACUM,12,2)
    @ 12,3 SAY 'Total de Comprobantes Emitidos : ' + STR(M_COMPRO,6,0)
    IF !IMPRE
        DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
        ESPERAR(0)
    ELSE
        EJECT
        SET DEVICE TO SCREEN
    ENDIF
ENDDO
CLOSE ALL
RETURN


FUNCTION VALPROV
****************
*Valid Proveedores. TIENE QUE ESTAR ABIERTO EL ARCH. DE PROVEEDORES EN SELE 12
*SI M_FILA = 0 NO DISPLAYA NOMBRE DE PROVEEDOR

PARAMETERS M_FILA,M_COLU,M_PROVE

IF M_PROVE = '9999999999'
      SET COLOR TO W+
      @ M_FILA,M_COLU SAY 'TODOS'
      SET COLOR TO
      RETURN(.T.)
ENDIF
SELE 12
USE PROVEDOR INDEX PROVEDOR
SEEK M_PROVE
IF !FOUND()
     DO M_CARTEL WITH 13,24,0,.T.,.T.,.T.
     ESPERAR(0)
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     RETURN(.F.)
ELSE
     IF M_FILA <> 0
        SET COLOR TO I
        @ M_FILA,M_COLU SAY SUBSTR(NOMBRE,1,25)
        SET COLOR TO
     ENDIF
     RETURN(.T.)
ENDIF


FUNCTION VALCLI
***************
*Valida Clientes. TIENE QUE ESTAR ABIERTO EL ARCH. DE CLIENTES EN SELE 11
*SI M_FILA = 0 NO DISPLAYA NOMBRE.

PARAMETERS M_FILA,M_COLU,M_CLI

SELE 11
USE CLIENTES INDEX CLIENTES

IF VAL(M_CLI)  = 9999999999
    SET COLOR TO I
    @ M_FILA,M_COLU SAY 'TODOS'
    SET COLOR TO
    RETURN(.T.)
ENDIF
SEEK M_CLI
IF !FOUND()
     DO M_CARTEL WITH 40,24,0,.T.,.T.,.T.
     ESPERAR(0)
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     RETURN(.F.)
ELSE
     IF M_FILA <> 0
        SET COLOR TO I
        @ M_FILA,M_COLU SAY SUBSTR(NOMBRE,1,25)
        SET COLOR TO
     ENDIF
     RETURN(.T.)
ENDIF


FUNCTION ERROR_PRINT
********************
I = 1
DO WHILE I <= 20
    IF ISPRINTER()
        RETURN(.F.)
    ELSE
        DO M_CARTEL WITH 76,24,0,.T.,.T.,.T.
        ESPERAR(0)
        IF LASTKEY() = 27
            RETURN(.T.)
        ENDIF
        I = I + 1
    ENDIF
ENDDO
RETURN(.T.)


FUNCTION VALAR2
***************

PARAMETERS M_FILA,M_COLU,M_ART

IF M_ART = '9999999999'
     SET COLOR TO I
     @ M_FILA,M_COLU SAY 'TODOS'
     SET COLOR TO
     RETURN(.T.)
ENDIF
IF AT('?',M_ART) <> 0
      M_ART = BUS_ARTI2(M_ART,'1')
      V_ARTI[M_IT] = M_ART
ENDIF
SEEK M_ART
IF !FOUND()
     DO M_CARTEL WITH 15,24,0,.T.,.T.,.T.
     ESPERAR(0)
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     RETURN(.F.)
ELSE
     IF M_FILA <> 0
        SET COLOR TO W+
        @ M_FILA,M_COLU SAY SUBSTR(DESCR,1,25)
        SET COLOR TO
     ENDIF
     RETURN(.T.)
ENDIF


PROCEDURE MENPEDI
*****************
DO WHILE .T.
     DECLARE MENPEE[5]
     DECLARE OPPEE[5]
     OPPEE[1]='ABM DE PEDIDOS DE CLIENTES'
     OPPEE[2]='ABM DE PEDIDOS A PROVEEDORES'
     OPPEE[3]='LISTADO de PEDIDOS DE CLIENTES'
     OPPEE[4]='LISTADO de PEDIDOS DE PROVEEDORES'
     OPPEE[5]='DEPURAR ARCHIVO DE PEDIDOS'

     MENPEE[1]='          ∫ABM de Pedidos de Clientes'
     MENPEE[2]='          ∫ABM de Pedidos de Proveedores'
     MENPEE[3]='          ∫Listado de Pedidos de Clientes'
     MENPEE[4]='          ∫Listado de Pedidos de Proveedores'
     MENPEE[5]='          ∫Borrar Archivo de Pedidos'

     *    Displaya opciones y captura.
     OPPE=OPCIONES('SISTEMA DE VENTAS - PEDIDOS',OPPEE,MENPEE)
     *    Fin
     IF LASTKEY()=27
        EXIT
     ENDIF
     DO CASE
     CASE OPPE = 1
        DO ABMPEDI WITH 'C'
     CASE OPPE = 2
        DO ABMPEDI WITH 'P'
     CASE OPPE = 3
        DO LIS_PEDI WITH 'C'
     CASE OPPE = 4
        DO LIS_PEDI WITH 'P'
     CASE OPPE = 5
        DO BORRA_PEDI
     ENDCASE
ENDDO
RETURN


FUNCTION VALVEND
****************
*Valida Vendedores.

PARAMETERS M_FILA,M_COLU,M_CLI

SELE 9
USE VENDEDOR INDEX VENDEDOR

IF VAL(M_CLI)  = 9999999999
    SET COLOR TO I
    @ M_FILA,M_COLU SAY 'TODOS'
    SET COLOR TO
    RETURN(.T.)
ENDIF
SEEK M_CLI
IF !FOUND()
     DO M_CARTEL WITH 109,24,0,.T.,.T.,.T.
     ESPERAR(0)
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     RETURN(.F.)
ELSE
     IF M_FILA <> 0
        SET COLOR TO I
        @ M_FILA,M_COLU SAY SUBSTR(NOMBRE,1,25)
        SET COLOR TO
     ENDIF
     RETURN(.T.)
ENDIF


FUNCTION CONVER_LE
******** *********

PARAMETERS M_VALOR

PRIVATE MENSAJE,VALOR,SENIAL

*Definicion de vector de unidades y carga del mismo

DECLARE UNIDADES[21]

UNIDADES[1]='UNO'
UNIDADES[2]='DOS'
UNIDADES[3]='TRES'
UNIDADES[4]='CUATRO'
UNIDADES[5]='CINCO'
UNIDADES[6]='SEIS'
UNIDADES[7]='SIETE'
UNIDADES[8]='OCHO'
UNIDADES[9]='NUEVE'
UNIDADES[10]='DIEZ'
UNIDADES[11]='ONCE'
UNIDADES[12]='DOCE'
UNIDADES[13]='TRECE'
UNIDADES[14]='CATORCE'
UNIDADES[15]='QUINCE'
UNIDADES[16]='DIECISEIS'
UNIDADES[17]='DIECISIETE'
UNIDADES[18]='DIECIOCHO'
UNIDADES[19]='DIECINUEVE'
UNIDADES[20]='VEINTE'
UNIDADES[21]='VEINTIUN'

*Definicion del vector de decenas y carga del mismo

DECLARE DECENAS[9]

DECENAS[1]='DIEZ'
DECENAS[2]='VEINTE'
DECENAS[3]='TREINTA'
DECENAS[4]='CUARENTA'
DECENAS[5]='CINCUENTA'
DECENAS[6]='SESENTA'
DECENAS[7]='SETENTA'
DECENAS[8]='OCHENTA'
DECENAS[9]='NOVENTA'

*Definicion del vector de Centenas y carga del mismo

DECLARE CENTENAS[9]

CENTENAS[1]='CIEN'
CENTENAS[2]='DOSCIENTOS'
CENTENAS[3]='TRESCIENTOS'
CENTENAS[4]='CUATROCIENTOS'
CENTENAS[5]='QUINIENTOS'
CENTENAS[6]='SEICIENTOS'
CENTENAS[7]='SETECIENTOS'
CENTENAS[8]='OCHOCIENTOS'
CENTENAS[9]='NOVECIENTOS'


*******************
*bloque principal *
*******************

*Inicializacion de variables

SENIAL=.F.
SENIAL2=.F.
SENIAL3=.T.
MENSAJE=''
MENSAJE2=''
VALOR1=''

IF M_VALOR = 0
   RETURN('CERO')
ENDIF

VALOR=STR(M_VALOR,11,2)
IF AT('.',VALOR) <> 0
    VALOR1=RIGHT(VALOR,2)
    VALOR=LEFT(VALOR,AT('.',VALOR)-1)
    VALOR=SPACE(8-LEN(VALOR)) + VALOR
ENDIF

*Verifica decimales

IF VAL(VALOR1) <> 0
          IF VAL(SUBSTR(VALOR1,2,1)) = 0
                    MENSAJE2=' CON ' + MENSAJE2 + DECENAS[VAL(SUBSTR(VALOR1,1,1))] + ' CENTAVOS'
          ELSE
              IF VAL(SUBSTR(VALOR1,1,2)) < 22
                    MENSAJE2= ' CON ' + MENSAJE2 + UNIDADES[VAL(SUBSTR(VALOR1,1,2))] + ' CENTAVOS'
              ELSE
                   IF VAL(SUBSTR(VALOR1,1,2)) > 21 .AND. VAL(SUBSTR(VALOR1,1,2)) < 30
                        MENSAJE2= ' CON ' + MENSAJE2 + 'VEINTI' + UNIDADES[VAL(SUBSTR(VALOR1,2,1))] + ' CENTAVOS'
                    ELSE
                        MENSAJE2=' CON ' + MENSAJE2 + DECENAS[VAL(SUBSTR(VALOR1,1,1))] + ' Y ' + UNIDADES[VAL(SUBSTR(VALOR1,2,1))] + ' CENTAVOS'
                    ENDIF
              ENDIF
          ENDIF
ENDIF

IF VAL(VALOR) < 10000 .AND. VAL(VALOR) >=1000
   SENIAL=.T.
ENDIF

*10 Millones
************
IF SUBSTR(VALOR,1,1) <> ' '
       IF VAL(SUBSTR(VALOR,2,1)) = 0
            MENSAJE=MENSAJE + DECENAS[VAL(SUBSTR(VALOR,1,1))] + ' MILLONES '
       ELSE
            IF VAL(SUBSTR(VALOR,1,2)) < 22
                 MENSAJE= MENSAJE + UNIDADES[VAL(SUBSTR(VALOR,1,2))] + ' MILLONES '
            ELSE
                 IF VAL(SUBSTR(VALOR,1,2)) > 21  .AND. VAL(SUBSTR(VALOR,1,2)) < 30
                      MENSAJE=MENSAJE + 'VEINTI' + UNIDADES[VAL(SUBSTR(VALOR,2,1))] + ' MILLONES '
                 ELSE
                     MENSAJE=MENSAJE + DECENAS[VAL(SUBSTR(VALOR,1,1))] + ' Y ' + UNIDADES[VAL(SUBSTR(VALOR,2,1))] + ' MILLONES '
                 ENDIF
            ENDIF
       ENDIF
ENDIF

*1 millon
*********

IF SUBSTR(VALOR,2,1) <> ' '  .AND. VAL(VALOR) < 10000000
      IF VAL(SUBSTR(VALOR,2,1)) = 1
              MENSAJE=MENSAJE+'UN MILLON '
      ELSE
              MENSAJE=MENSAJE+UNIDADES[VAL(SUBSTR(VALOR,2,1))] + ' MILLONES '
      ENDIF
ENDIF

*Cien Mil

IF SUBSTR(VALOR,3,1)  <> ' '
  IF VAL(SUBSTR(VALOR,3,2)) < 21
         IF VAL(SUBSTR(VALOR,4,2)) <> 0 .AND. VAL(SUBSTR(VALOR,3,1)) <> 0
              MENSAJE=MENSAJE+'CIENTO '
         ELSE
              IF VAL(SUBSTR(VALOR,3,1)) <> 0
                 MENSAJE=MENSAJE + 'CIEN '
              ENDIF
         ENDIF
  ELSE
        MENSAJE=MENSAJE+CENTENAS[VAL(SUBSTR(VALOR,3,1))] + ' '
  ENDIF
  IF VAL(SUBSTR(VALOR,4,2)) < 21
         IF VAL(SUBSTR(VALOR,4,1)) <> 0
                 MENSAJE= MENSAJE + UNIDADES[VAL(SUBSTR(VALOR,4,2))] + ' MIL '
                 SENIAL3=.F.
         ELSE
                 SENIAL=.T.
                 SENIAL3=.F.
         ENDIF
  ENDIF
ENDIF

*Diez Mil

IF SUBSTR(VALOR,4,1) <> ' '
  IF VAL(SUBSTR(VALOR,4,2)) > 20
        IF VAL(SUBSTR(VALOR,4,2)) < 30
             MENSAJE=MENSAJE + 'VEINTI'
             SENIAL=.T.
        ELSE
             MENSAJE=MENSAJE + DECENAS[VAL(SUBSTR(VALOR,4,1))] + ' '
             IF VAL(SUBSTR(VALOR,5,1)) <> 0
                    MENSAJE=MENSAJE + 'Y '
                    SENIAL=.T.
             ELSE
                    IF VAL(SUBSTR(VALOR,4,1)) <> 0
                        MENSAJE=MENSAJE + 'MIL '
                    ENDIF
             ENDIF
         ENDIF
  ELSE
         IF SENIAL3
             MENSAJE=MENSAJE + UNIDADES[VAL(SUBSTR(VALOR,4,2))] + ' MIL '
         ENDIF
  ENDIF
ENDIF

*Miles

IF SENIAL
     IF VAL(SUBSTR(VALOR,5,1)) = 1
              MENSAJE = MENSAJE + 'UN MIL '
     ELSE
             IF VAL(SUBSTR(VALOR,5,1)) <> 0
                  MENSAJE = MENSAJE + UNIDADES[VAL(SUBSTR(VALOR,5,1))] + ' MIL '
             ELSE
                  IF VAL(SUBSTR(VALOR,3,3)) <> 0
                      MENSAJE=MENSAJE + ' MIL '
                  ENDIF
             ENDIF
     ENDIF
ENDIF
IF VAL(SUBSTR(VALOR,6,2)) < 20
       IF VAL(SUBSTR(VALOR,6,1)) <> 0
          IF VAL(SUBSTR(VALOR,6,3)) > 100
                 MENSAJE=MENSAJE + ' CIENTO '
          ELSE
                 MENSAJE=MENSAJE + ' CIEN '
          ENDIF
       ENDIF
ELSE
       IF VAL(SUBSTR(VALOR,6,1)) <> 0
             MENSAJE=MENSAJE + CENTENAS[VAL(SUBSTR(VALOR,6,1))] + ' '
       ENDIF
ENDIF

*Cientos y Decenas

IF VAL(SUBSTR(VALOR,7,2)) < 21
       IF VAL(SUBSTR(VALOR,7,1)) <> 0
              MENSAJE=MENSAJE + UNIDADES[VAL(SUBSTR(VALOR,7,2))] + ' '
              RETURN(MENSAJE + MENSAJE2)
       ELSE
              IF VAL(SUBSTR(VALOR,8,1)) <> 0
                 MENSAJE=MENSAJE + ' ' + UNIDADES[VAL(SUBSTR(VALOR,8,1))]
              ENDIF
       ENDIF
ENDIF
IF VAL(SUBSTR(VALOR,7,2)) > 20
       IF VAL(SUBSTR(VALOR,7,2)) < 30
            MENSAJE=MENSAJE + 'VEINTI' + UNIDADES[VAL(SUBSTR(VALOR,8,1))]
       ELSE
            MENSAJE=MENSAJE + DECENAS[VAL(SUBSTR(VALOR,7,1))] + ' '
            SENIAL2=.T.
       ENDIF
ENDIF

*Unidades

IF SENIAL2
       IF VAL(SUBSTR(VALOR,8,1)) > 1
              MENSAJE=MENSAJE + ' Y ' + UNIDADES[VAL(SUBSTR(VALOR,8,1))]
       ELSE
              IF VAL(SUBSTR(VALOR,8,1)) =1
                    IF VAL(SUBSTR(VALOR,7,2)) < 30
                          MENSAJE=MENSAJE + ' UNO '
                    ELSE
                          MENSAJE=MENSAJE + ' Y UNO '
                    ENDIF
               ENDIF
        ENDIF
ENDIF
RETURN(MENSAJE + MENSAJE2)

FUNCTION VALARTI
****************

PARAMETERS M_FILA,M_COLU,M_ART

IF M_ART = '9999999999'
     SET COLOR TO I
     @ M_FILA,M_COLU SAY 'TODOS'
     SET COLOR TO
     RETURN(.T.)
ENDIF
SEEK M_ART
IF !FOUND()
     DO M_CARTEL WITH 15,24,0,.T.,.T.,.T.
     ESPERAR(0)
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     RETURN(.F.)
ELSE
     IF M_FILA <> 0
        SET COLOR TO W+
        @ M_FILA,M_COLU SAY SUBSTR(DESCR,1,25)
        SET COLOR TO
     ENDIF
     RETURN(.T.)
ENDIF
