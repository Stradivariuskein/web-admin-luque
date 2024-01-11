********************************************************************************
*Nombre de la Funcion : CONVER_LE                                              *
*                                                                              *
*Funcion de Conversion a Letras de una variable Numerica                       *
*                                                                              *
*Parametros : Debe enviarse como parametro Una variable numerica.              *
*----------   Maxima Longitud de la variable = 8 Caracteres enteros y          *
*             2 decimales (99999999.99) - No necesariamente debe tener         *
*             los decimales, lo que si se tiene que respetar es que cuando     *
*             se pasa un numero con decimales, estos deben estar separados por *
*             un punto (.) y NO por una coma (,) si o si, como por ejemplo     *
*             1234.50, etc.                                                    *
********************************************************************************


**************************************
*EJEMPLO DE INVOCACION A ESTA FUNCION*
**************************************
*
 PRIVATE NUMERO,FRASE
 CLEAR
 NUMERO=0
 @ 1,3 SAY 'NUMERO: ' GET NUMERO PICT '99999999.99'
 READ
*************************
 FRASE=CONVER_LE(NUMERO)
*************************
 @ 23,1 SAY FRASE

*==============================================================================
*==============================================================================

*************************
*COMIENZO DE LA FUNCION *
*************************

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
