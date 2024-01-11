*IF !SEGURIDAD(MM_CLAVE,'Q')
*     DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*     ESPERAR(0)
*     RETURN
*ENDIF

DECLARE MENPEE[5]
DECLARE OPPEE[5]
OPPEE[1]='COPIA de COMPROBANTES'
OPPEE[2]='COPIA de ARCHIVOS de DATOS'
OPPEE[3]='RECUPERACION de COMPROBANTES'
OPPEE[4]='RECUPERACION de ARCHIVOS de DATOS'
OPPEE[5]='DEPURACION del ARCHIVO de COMPROBANTES'
MENPEE[1]='          º  Copia de Comprobantes de un periodo de Trabajo'
MENPEE[2]='          º  Copia diaria de Archivos'
MENPEE[3]='          º  Recuperaci¢n de Comprobantes de un Periodo'
MENPEE[4]='          º  Recuperaci¢n de Diaria de Archivos'
MENPEE[5]='          º  Borrado de Archivos de Comprobantes'

DO WHILE .T.
*  Displaya opciones y captura.
   OPPE=OPCIONES('SISTEMA DE VENTAS - COPIA DE ARCHIVOS EN DISKETTES',OPPEE,MENPEE)
   IF LASTKEY() = 27
         EXIT
   ENDIF
   DO CASE
      CASE OPPE = 1
            DO COP_COMP
      CASE OPPE = 2
            DO COP_ARCH
      CASE OPPE = 3
            DO RECU_COMP
      CASE OPPE = 4
            DO RECU_ARCH
      CASE OPPE = 5
            DO DEPURA
   ENDCASE
ENDDO
RETURN


PROCEDURE COP_COMP
******************
*Copia de Comprobantes en discos de un periodo

DECLARE MESES[12]
MESES[1]= 'EN - ENERO    '
MESES[2]= 'FE - FEBRERO  '
MESES[3]= 'MZ - MARZO    '
MESES[4]= 'AB - ABRIL    '
MESES[5]= 'MY - MAYO     '
MESES[6]= 'JN - JUNIO    '
MESES[7]= 'JL - JULIO    '
MESES[8]= 'AG - AGOSTO   '
MESES[9]= 'ST - SETIEMBRE'
MESES[10]='OC - OCTUBRE  '
MESES[11]='NO - NOVIEMBRE'
MESES[12]='DI - DICIEMBRE'


*Fecha de los meses (DESDE y HASTA)

DECLARE FECHA_D[12]
FECHA_D[1] = '01/01/ - 31/01/'
FECHA_D[2] = '01/02/ - 28/02/'
FECHA_D[3] = '01/03/ - 31/03/'
FECHA_D[4] = '01/04/ - 30/04/'
FECHA_D[5] = '01/05/ - 31/05/'
FECHA_D[6] = '01/06/ - 30/06/'
FECHA_D[7] = '01/07/ - 31/07/'
FECHA_D[8] = '01/08/ - 31/08/'
FECHA_D[9] = '01/09/ - 30/09/'
FECHA_D[10] = '01/10/ - 31/10/'
FECHA_D[11] = '01/11/ - 30/11/'
FECHA_D[12] = '01/12/ - 31/12/'

DO WHILE .T.
     SELE 1
     USE CAJAIG INDEX CAJAIG,CAJAIG2,CAJAIG3
     SET ORDER TO 1

     SELE 5
     USE COMPRO1 INDEX COMPRO1,COMPRO2
     SET ORDER TO 1

     SELE 6
     USE DETALLE1 INDEX DETALLE1

     SELE 9
     USE DOCUM INDEX DOCUM,DOCUM2
     SET ORDER TO 1

     SELE 10
     USE COMPRAS INDEX COMPRAS

     CLEAR
     DO TITULO
     @ 1,0 TO 23,79 DOUBLE
     SET COLOR TO I
     @ 3,25 SAY ' * COPIA DE COMPROBANTES EN DISCO * '
     SET COLOR TO
     @ 6,2 TO 6,78
     SAVE SCREEN TO M_PANTA
     L = VENTOPCION('MES A COPIAR',MESES,8,30,22,.T.,.T.,1)
     IF LASTKEY() = 27
         EXIT
     ENDIF
     RESTORE SCREEN FROM M_PANTA
     @ 8,3 SAY 'Mes Elegido : ' + SUBSTR(MESES[L],6,9)
     IF APRUEBA(24,0,27)
            DO M_CARTEL WITH 26,24,0,.T.,.F.,.T.
            ESPERAR(0)
            @ 24,0 SAY SPACE(79)
            IF LASTKEY() = 27
               LOOP
            ENDIF
            DO M_CARTEL WITH 28,24,0,.T.,.F.,.T.

            SET DEFA TO A:

            *Creacion del Archivo de Caja Ingresos Grande

            ARCHIVO = 'CAJAIG.' + 'D' + SUBSTR(MESES[L],1,2)
            INDICE =  'CAJAIG.' + 'N' + SUBSTR(MESES[L],1,2)
            INDICE2 =  'CAJAIG2.' + 'N' + SUBSTR(MESES[L],1,2)
            INDICE3 =  'CAJAIG3.' + 'N' + SUBSTR(MESES[L],1,2)
            SELE 1
            COPY STRU TO &ARCHIVO
            SELE 12
            USE &ARCHIVO
            INDEX ON RUBRO TO &INDICE
            INDEX ON FECHA TO &INDICE2
            INDEX ON NRO TO &INDICE3

            *Creacion del Archivo de Comprobantes

            ARCHIVO = 'COMPRO1.' + 'D' + SUBSTR(MESES[L],1,2)
            INDICE = 'COMPRO1.' + 'N' + SUBSTR(MESES[L],1,2)
            INDICE2 = 'COMPRO2.' + 'N' + SUBSTR(MESES[L],1,2)
            SELE 5
            COPY STRU TO &ARCHIVO
            SELE 16
            USE &ARCHIVO
            INDEX ON TIPO + STR(NUMERO,5,0) TO &INDICE
            INDEX ON CLIENTE TO &INDICE2

            *Creacion del archivo de Detalle

            ARCHIVO = 'DETALLE1.' + 'D' + SUBSTR(MESES[L],1,2)
            INDICE = 'DETALLE1.' + 'N' + SUBSTR(MESES[L],1,2)
            SELE 6
            COPY STRU TO &ARCHIVO
            SELE 17
            USE &ARCHIVO
            INDEX ON TIPO + STR(NUMERO,5,0) TO &INDICE

*Creacion Archivo de Documentos

             ARCHIVO = 'DOCUM.' + 'D' + SUBSTR(MESES[L],1,2)
             INDICE  = 'DOCUM.' + 'N' + SUBSTR(MESES[L],1,2)
             INDICE2  = 'DOCUM2.' + 'N' + SUBSTR(MESES[L],1,2)

             SELE 9
             COPY STRU TO &ARCHIVO
             SELE 20
             USE &ARCHIVO
             INDEX ON STR(NRO,5,0) + STR(NROINT,5,0) TO &INDICE
             INDEX ON NROINT TO &INDICE2

*Creacion Archivo de Compras

             ARCHIVO = 'COMPRAS.' + 'D' + SUBSTR(MESES[L],1,2)
             INDICE  = 'COMPRAS.' + 'N' + SUBSTR(MESES[L],1,2)
             SELE 10
             COPY STRU TO &ARCHIVO
             SELE 21
             USE &ARCHIVO
             INDEX ON N_INT TO &INDICE

*Copia de Datos Existentes

            DESDE = SUBSTR(FECHA_D[L],1,6) + SUBSTR(DTOC(DATE()),7,2)
            HASTA = SUBSTR(FECHA_D[L],10,6) + SUBSTR(DTOC(DATE()),7,2)
            DESDE = CTOD(DESDE)
            HASTA = CTOD(HASTA)

            SELE 12
            APPE FROM C:\SIAAC\CAJAIG FOR FECHA >= DESDE .AND. FECHA <= HASTA

            SELE 16
            APPE FROM C:\SIAAC\COMPRO1 FOR FECHA >= DESDE .AND. FECHA <= HASTA

            SELE 17
            APPE FROM C:\SIAAC\DETALLE1 FOR FECHA >= DESDE .AND. FECHA <= HASTA

            SELE 20
            APPE FROM C:\SIAAC\DOCUM FOR FECHA >= DESDE .AND. FECHA <= HASTA

            SELE 21
            APPE FROM C:\SIAAC\COMPRAS FOR FECHA >= DESDE .AND. FECHA <= HASTA

     ENDIF
     CLOSE ALL
     SET DEFA TO C:\SIAAC
     @ 24,0 SAY SPACE(79)
ENDDO
RETURN

PROCEDURE COP_ARCH
******************
*Copia de Archivos en Diskettes

DO WHILE .T.
     CLEAR
     DO TITULO
     @ 1,0 TO 23,79 DOUBLE
     SET COLOR TO I
     @ 3,20 SAY ' * COPIA DE ARCHIVOS EN DISKETTES * '
     SET COLOR TO
     DO M_CARTEL WITH 26,24,0,.T.,.T.,.T.
     ESPERAR(0)
     IF LASTKEY() = 27
            EXIT
     ENDIF
     @ 24,0 SAY SPACE(79)
     DO M_CARTEL WITH 28,24,0,.T.,.F.,.T.
     RUN COPY ARTIC*.* A: >NUL
     RUN COPY VENDEDOR.* A: >NUL
     RUN COPY CONTADOR.* A: >NUL
     RUN COPY PROVEDOR.* A: >NUL
     RUN COPY SEGURI.* A: >NUL
     RUN COPY CLIENTES.* A: >NUL
     RUN COPY DOMICILI.* A: >NUL
     RUN COPY IVA.* A: >NUL
     RUN COPY EXPRESO.* A: >NUL
     RUN COPY CONT*.* A: >NUL
     RUN COPY RUBRO*.* A: >NUL
     RUN COPY DOLAR*.* A: >NUL
     RUN COPY BANCOS.* A: >NUL
     RUN COPY CONJUN*.* A: >NUL
     RUN COPY PEDPROV*.* A: >NUL
     RUN COPY MOVSUB.* A: >NUL
     RUN COPY MPRIMA.* A: >NUL
     RUN COPY PEDIDOS*.* A: >NUL
     RUN COPY PROVI*.* A: >NUL
     RUN COPY SUBCONJ*.* A: >NUL
     RUN COPY VALES*.* A: >NUL
     @ 24,0 SAY SPACE(79)
     DO M_CARTEL WITH 29,24,0,.T.,.T.,.T.
     ESPERAR(0)
     RETURN
ENDDO
RETURN



PROCEDURE RECU_ARCH
*******************
*Recupera Arhivos del Diskette

DO WHILE .T.
     CLEAR
     DO TITULO
     @ 1,0 TO 23,79 DOUBLE
     SET COLOR TO I
     @ 3,20 SAY ' * RECUPERACION DE ARCHIVOS EN DISKETTES * '
     SET COLOR TO
     DO M_CARTEL WITH 26,24,0,.T.,.T.,.T.
     ESPERAR(0)
     IF LASTKEY() = 27
            EXIT
     ENDIF
     @ 24,0 SAY SPACE(79)
     DO M_CARTEL WITH 28,24,0,.T.,.F.,.T.
     RUN A:
     RUN COPY ARTIC*.* C:\SIAAC >NUL
     RUN COPY VENDEDOR.* C:\SIAAC >NUL
     RUN COPY CONTADOR.* C:\SIAAC >NUL
     RUN COPY PROVEDOR.* C:\SIAAC >NUL
     RUN COPY SEGURI.* C:\SIAAC >NUL
     RUN COPY CLIENTES.* C:\SIAAC >NUL
     RUN COPY DOMICILI.* C:\SIAAC >NUL
     RUN COPY IVA.* C:\SIAAC >NUL
     RUN COPY EXPRESO.* C:\SIAAC >NUL
     RUN COPY CONT*.* C:\SIAAC >NUL
     RUN COPY RUBRO*.* C:\SIAAC >NUL
     RUN COPY DOLAR*.* C:\SIAAC >NUL
     RUN COPY BANCOS.* C:\SIAAC >NUL
     RUN COPY CONJUN*.* C:\SIAAC >NUL
     RUN COPY PEDPROV*.* C:\SIAAC >NUL
     RUN COPY MOVSUB.* C:\SIAAC >NUL
     RUN COPY MPRIMA.* C:\SIAAC >NUL
     RUN COPY PEDIDOS*.* C:\SIAAC >NUL
     RUN COPY PROVI*.* C:\SIAAC >NUL
     RUN COPY SUBCONJ*.* C:\SIAAC >NUL
     RUN COPY VALES*.* C:\SIAAC >NUL
     RUN C:

     @ 24,0 SAY SPACE(79)
     DO M_CARTEL WITH 29,24,0,.T.,.T.,.T.
     ESPERAR(0)
     RETURN
ENDDO
RETURN

PROCEDURE RECU_COMP
*******************
*Recupera Comprobantes del Diskette

DECLARE MESES[12]
MESES[1]= 'EN - ENERO    '
MESES[2]= 'FE - FEBRERO  '
MESES[3]= 'MZ - MARZO    '
MESES[4]= 'AB - ABRIL    '
MESES[5]= 'MY - MAYO     '
MESES[6]= 'JN - JUNIO    '
MESES[7]= 'JL - JULIO    '
MESES[8]= 'AG - AGOSTO   '
MESES[9]= 'ST - SETIEMBRE'
MESES[10]='OC - OCTUBRE  '
MESES[11]='NO - NOVIEMBRE'
MESES[12]='DI - DICIEMBRE'


DO WHILE .T.
     SELE 1
     USE CAJAIG INDEX CAJAIG,CAJAIG2,CAJAIG3
     SET ORDER TO 1

     SELE 5
     USE COMPRO1 INDEX COMPRO1,COMPRO2
     SET ORDER TO 1

     SELE 6
     USE DETALLE1 INDEX DETALLE1

     SELE 9
     USE DOCUM INDEX DOCUM,DOCUM2
     SET ORDER TO 1

     SELE 10
     USE COMPRAS INDEX COMPRAS

     CLEAR
     DO TITULO
     @ 1,0 TO 23,79 DOUBLE
     SET COLOR TO I
     @ 3,20 SAY ' * RECUPERACION DE COMPROBANTES DEL DISKETTE * '
     SET COLOR TO
     @ 6,2 TO 6,78
     SAVE SCREEN TO M_PANTA
     L = VENTOPCION('MES A RECUPERAR',MESES,8,30,22,.T.,.T.,1)
     IF LASTKEY() = 27
         EXIT
     ENDIF
     RESTORE SCREEN FROM M_PANTA
     @ 8,3 SAY 'Mes Elegido Para Recuperar : ' + SUBSTR(MESES[L],6,9)
     IF APRUEBA(24,0,27)
           DO M_CARTEL WITH 26,24,0,.T.,.T.,.T.
           ESPERAR(0)
           IF LASTKEY() = 27
               LOOP
           ENDIF
           @ 24,0 SAY SPACE(79)
           DO M_CARTEL WITH  28,24,0,.T.,.F.,.T.

           ARCHIVO = 'CAJAIG.D' + SUBSTR(MESES[L],1,2)
           SELE 1
           APPE FROM A:&ARCHIVO

           ARCHIVO = 'COMPRO1.D' + SUBSTR(MESES[L],1,2)
           SELE 5
           APPE FROM A:&ARCHIVO

           ARCHIVO = 'DETALLE1.D' + SUBSTR(MESES[L],1,2)
           SELE 6
           APPE FROM A:&ARCHIVO

           ARCHIVO = 'DOCUM.D' + SUBSTR(MESES[L],1,2)
           SELE 9
           APPE FROM A:&ARCHIVO

           ARCHIVO = 'COMPRAS.D' + SUBSTR(MESES[L],1,2)
           SELE 10
           APPE FROM A:&ARCHIVO
     ENDIF
     @ 24,0 SAY SPACE(79)
     CLOSE ALL
ENDDO
RETURN

PROCEDURE DEPURA
*****************
*Depuracion de Archivos por Mes

DECLARE MESES[12]
MESES[1]= 'EN - ENERO    '
MESES[2]= 'FE - FEBRERO  '
MESES[3]= 'MZ - MARZO    '
MESES[4]= 'AB - ABRIL    '
MESES[5]= 'MY - MAYO     '
MESES[6]= 'JN - JUNIO    '
MESES[7]= 'JL - JULIO    '
MESES[8]= 'AG - AGOSTO   '
MESES[9]= 'ST - SETIEMBRE'
MESES[10]='OC - OCTUBRE  '
MESES[11]='NO - NOVIEMBRE'
MESES[12]='DI - DICIEMBRE'

*Fecha de los meses (DESDE y HASTA)

DECLARE FECHA_D[12]
FECHA_D[1] = '01/01/ - 31/01/'
FECHA_D[2] = '01/02/ - 28/02/'
FECHA_D[3] = '01/03/ - 31/03/'
FECHA_D[4] = '01/04/ - 30/04/'
FECHA_D[5] = '01/05/ - 31/05/'
FECHA_D[6] = '01/06/ - 30/06/'
FECHA_D[7] = '01/07/ - 31/07/'
FECHA_D[8] = '01/08/ - 31/08/'
FECHA_D[9] = '01/09/ - 30/09/'
FECHA_D[10] = '01/10/ - 31/10/'
FECHA_D[11] = '01/11/ - 30/11/'
FECHA_D[12] = '01/12/ - 31/12/'

SELE 1
USE CAJAIG INDEX CAJAIG,CAJAIG2,CAJAIG3
SET ORDER TO 1

SELE 5
USE COMPRO1 INDEX COMPRO1,COMPRO2
SET ORDER TO 2

SELE 6
USE DETALLE1 INDEX DETALLE1

SELE 9
USE DOCUM INDEX DOCUM,DOCUM2
SET ORDER TO 1

SELE 10
USE COMPRAS INDEX COMPRAS

SELE 12
USE CLIENTES INDEX CLIENTES

DECLARE V_CLI[300]
M_TOTCLI = 300
FOR I = 1 TO M_TOTCLI
    V_CLI[I] = 0
NEXT

SELE 13
USE RUBROS INDEX RUBROS
M_TOTRUB = RECCOUNT()
DECLARE V_RUB[M_TOTRUB]
FOR I = 1 TO M_TOTRUB
    V_RUB[I] = 0
NEXT

SELE 14
USE PROVEDOR INDEX PROVEDOR

M_TOTPRO = RECCOUNT()
DECLARE V_PROV[M_TOTPRO]
FOR I = 1 TO M_TOTPRO
     V_PROV[I] = 0
NEXT

SELE 15
USE CONTADO1 INDEX CONTADO1

SELE 25
USE RUBROS INDEX RUBROS

DO WHILE .T.
     CLEAR
     DO TITULO
     @ 1,0 TO 23,79 DOUBLE
     SET COLOR TO I
     @ 3,20 SAY ' * DEPURACION DE ARCHIVO DE COMPROBANTES * '
     SET COLOR TO
     @ 6,2 TO 6,78
     SAVE SCREEN TO M_PANTA
     L = VENTOPCION('MES A DEPURAR',MESES,8,30,22,.T.,.T.,1)
     IF LASTKEY() = 27
         EXIT
     ENDIF
     RESTORE SCREEN FROM M_PANTA
     @ 8,3 SAY 'Mes Elegido Para Depurar : ' + SUBSTR(MESES[L],6,9)
     IF APRUEBA(24,0,27)
           @ 24,0 SAY SPACE(79)
           DO M_CARTEL WITH 30,24,0,.T.,.F.,.T.
           DESDE = SUBSTR(FECHA_D[L],1,6) + SUBSTR(DTOC(DATE()),7,2)
           HASTA = SUBSTR(FECHA_D[L],10,6) + SUBSTR(DTOC(DATE()),7,2)
           DESDE = CTOD(DESDE)
           HASTA = CTOD(HASTA)

           SELE 16
           ARCHIVO = 'CAJAIG.' + 'D' + SUBSTR(MESES[L],1,2)
           INDICE =  'CAJAIG.' + 'N' + SUBSTR(MESES[L],1,2)
           INDICE2 =  'CAJAIG2.' + 'N' + SUBSTR(MESES[L],1,2)
           INDICE3 =  'CAJAIG3.' + 'N' + SUBSTR(MESES[L],1,2)

           USE A:&ARCHIVO INDEX A:&INDICE,A:&INDICE2,A:&INDICE3
           SET ORDER TO 1

           SELE 20
           ARCHIVO = 'COMPRO1.' + 'D' + SUBSTR(MESES[L],1,2)
           INDICE =  'COMPRO1.' + 'N' + SUBSTR(MESES[L],1,2)
           INDICE2 =  'COMPRO2.' + 'N' + SUBSTR(MESES[L],1,2)
           USE A:&ARCHIVO INDEX A:&INDICE,A:&INDICE2

           SELE 22
           ARCHIVO = 'COMPRAS.' + 'D' + SUBSTR(MESES[L],1,2)
           INDICE =  'COMPRAS.' + 'N' + SUBSTR(MESES[L],1,2)
           USE A:&ARCHIVO INDEX A:&INDICE

*Caja
           @ 24,0 SAY SPACE(79)
           @ 24,20 SAY 'DEPURANDO ARCHIVOS DE CAJA'

           FOR Z = 1 TO 1
               FOR T = 1 TO M_TOTRUB
                   V_RUB[T] = 0
               NEXT
               X = STR(Z,1,0)
               SELE &X
               GO TOP
               DO WHILE !EOF()
                     IF FECHA >=DESDE .AND. FECHA <= HASTA
                           V_RUB[RUBRO]= V_RUB[RUBRO]+ IMPESOS + IMPDOL + IMPDOC
                           DELETE
                     ENDIF
                     SKIP
               ENDDO
               PACK
               FOR I = 1 TO M_TOTRUB
                   IF V_RUB[I] <> 0
                       SELE &X
                       APPEND BLANK
                       REPLACE DETALLE WITH 'SALDO ANTERIOR'
                       REPLACE RUBRO WITH I
                       REPLACE IMPESOS WITH V_RUB[I]
                       REPLACE FECHA WITH DESDE
                       M_RUB = I
                       SELE 25
                       SEEK M_RUB
                       SELE &X
                       REPLACE TIPO WITH IIF(RUBROS->INGRES = 'I','I','E')
                       V = STR(Z + 15,2,0)
                       SELE &V
                       APPEND BLANK
                       REPLACE DETALLE WITH 'SALDO COPIADO'
                       REPLACE RUBRO WITH I
                       REPLACE IMPESOS WITH V_RUB[I] * (-1)
                       REPLACE FECHA WITH DESDE
                   ENDIF
               NEXT
           NEXT

*Comprobantes
           @ 24,0 SAY SPACE(79)
           @ 24,20 SAY 'DEPURANDO ARCHIVOS DE COMPROBANTES'
           V_TABLA = ARRAY(300,2)
           SELE 5
           GO TOP
           FOR I = 1 TO 300
                FOR J = 1 TO 2
                    IF J = 1
                       V_TABLA[I,J] = SPACE(10)
                    ELSE
                       V_TABLA[I,J] = 0
                    ENDIF
                NEXT
           NEXT
           I = 1
           DO WHILE !EOF()
                 M_CLIANT = CLIENTE
                 DO WHILE !EOF() .AND. CLIENTE = M_CLIANT
                       IF FECHA >=DESDE .AND. FECHA <= HASTA .AND. !ANULADA
                               IF TIPO = 'FAC' .OR. TIPO = 'CDO' .OR. TIPO = 'AJD' .OR. TIPO ='NDB'
                                   M_DESCU = BONIF
                                   V_CLI[I]= V_CLI[I] + TOTAL + IVA + REC_IVA - M_DESCU
                               ELSE
                                   IF TIPO = 'REC' .OR. TIPO = 'AJA' .OR. TIPO = 'NCR'
                                      V_CLI[I] = V_CLI[I] - (TOTAL + IVA + REC_IVA)
                                   ENDIF
                               ENDIF
                               DELETE
                       ENDIF
                       SKIP
                 ENDDO
                 V_TABLA[I,1] = M_CLIANT
                 V_TABLA[I,2] = V_CLI[I]
                 I = I + 1
           ENDDO
           FOR I = 1 TO 300
                 IF V_TABLA[I,2] <> 0
                     SELE 15
                     IF V_TABLA[I,2] < 0
                           SEEK 'AJA'
                     ELSE
                           SEEK 'AJD'
                     ENDIF
                     M_NUM = NUMERO
                     REPLACE NUMERO WITH NUMERO + 1
                     SELE 5
                     APPEND BLANK
                     REPLACE TIPO WITH IIF(V_TABLA[I,2]  < 0,'AJA','AJD')
                     REPLACE TOTAL WITH IIF(V_TABLA[I,2] < 0,V_TABLA[I,2] * (-1),V_CLI[I])
                     REPLACE CLIENTE WITH V_TABLA[I,1]
                     REPLACE FECHA WITH DESDE
                     REPLACE NUMERO WITH M_NUM
                     SELE 20
                     APPEND BLANK
                     REPLACE TIPO WITH IIF(V_TABLA[I,2]  < 0,'AJA','AJD')
                     REPLACE TOTAL WITH IIF(V_TABLA[I,2] < 0,V_TABLA[I,2],V_TABLA[I,2]*(-1))
                     REPLACE CLIENTE WITH M_CLIANT
                     REPLACE FECHA WITH DESDE
                     REPLACE NUMERO WITH M_NUM
                 ENDIF
           NEXT
           SELE 5
           PACK
*Detalle
          @ 24,0 SAY SPACE(79)
          @ 24,20 SAY 'DEPURANDO ARCHIVOS DE DETALLES'

           SELE 6
           GO TOP
           DELETE FOR FECHA >= DESDE .AND. FECHA <= HASTA
           PACK

*Documentos
           @ 24,0 SAY SPACE(79)
           @ 24,20 SAY 'DEPURANDO ARCHIVOS DE DOCUMENTOS'

           SELE 9
           GO TOP
           DELETE FOR FECHA >= DESDE .AND. FECHA <= HASTA
           PACK

*Compras
           @ 24,0 SAY SPACE(79)
           @ 24,20 SAY 'DEPURANDO ARCHIVOS DE COMPRAS'

           FOR I = 1 TO M_TOTPRO
                V_PROV[I] = 0
           NEXT
           V_TABLA = ARRAY(300,2)
           FOR I = 1 TO 300
                FOR J = 1 TO 2
                    IF J = 1
                       V_TABLA[I,J] = SPACE(10)
                    ELSE
                       V_TABLA[I,J] = 0
                    ENDIF
                NEXT
           NEXT
           SELE 10
           INDEX ON PROVEDOR TO AUXILI0
           GO TOP
           I = 1
           DO WHILE !EOF()
                 M_PROANT = PROVEDOR
                 DO WHILE !EOF() .AND. M_PROANT = PROVEDOR
                       IF FECHA >=DESDE .AND. FECHA <= HASTA
                               IF TIPO = 'FAC' .OR. TIPO = 'NDB' .OR. TIPO = 'AJD'
                                   V_PROV[I]= V_PROV[I] + IMP_BRUTO + IVA + ADIC
                               ELSE
                                   IF TIPO = 'REC' .OR. TIPO = 'AJA'
                                      V_PROV[I]= V_PROV[I] - (IMP_BRUTO + IVA + ADIC)
                                   ENDIF
                               ENDIF
                               DELETE
                       ENDIF
                       SKIP
                 ENDDO
                 V_TABLA[I,1] = M_PROANT
                 V_TABLA[I,2] = V_PROV[I]
                 I = I + 1
           ENDDO
           FOR I = 1 TO 300
                 IF V_TABLA[I,2] <> 0
                     SELE 15
                     IF V_TABLA[I,2] < 0
                           SEEK 'APA'
                     ELSE
                           SEEK 'APD'
                     ENDIF
                     M_NUM = NUMERO
                     REPLACE NUMERO WITH NUMERO + 1
                     SELE 10
                     APPEND BLANK
                     REPLACE TIPO WITH IIF(V_TABLA[I,2] < 0,'AJA','AJD')
                     REPLACE IMP_BRUTO WITH IIF(V_TABLA[I,2] < 0,V_TABLA[I,2] * (-1),V_TABLA[I,2])
                     REPLACE PROVEDOR WITH V_TABLA[I,1]
                     REPLACE FACTURA WITH M_NUM
                     REPLACE FECHA WITH DESDE
                     SELE 22
                     APPEND BLANK
                     REPLACE TIPO WITH IIF(V_TABLA[I,2] < 0,'AJA','AJD')
                     REPLACE IMP_BRUTO WITH IIF(V_TABLA[I,2] < 0,V_TABLA[I,2],V_TABLA[I,2]* (-1))
                     REPLACE PROVEDOR WITH V_TABLA[I,1]
                     REPLACE FACTURA WITH M_NUM
                     REPLACE FECHA WITH DESDE
                 ENDIF
           NEXT
           SELE 10
           PACK
     ENDIF
     @ 24,0 SAY SPACE(79)
ENDDO
CLOSE ALL
RETURN
