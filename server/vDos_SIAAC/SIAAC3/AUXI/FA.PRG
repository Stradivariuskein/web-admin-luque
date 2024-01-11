*******************************************************************************
*FA.PRG
*
*Facturacion Automatica de Remitos
*
*******************************************************************************


*IF !SEGURIDAD(MM_CLAVE,'U')
*     DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*     ESPERAR(0)
*     RETURN
*ENDIF

SELE 2
USE ARTIC INDEX ARTIC

SELE 4
USE COMPRO1 INDEX COMPRO1,COMPRO2
SET ORDER TO 1

SELE 5
USE DETALLE1 INDEX DETALLE1

SELE 9
USE VENDEDOR INDEX VENDEDOR

SELE 11
USE CLIENTES INDEX CLIENTES

SELE 13
USE CONTADO1 INDEX CONTADO1

SELE 14
USE ACUM INDEX ACUM

SELE 25
USE IVA

DO WHILE .T.
   CLEAR
   DO TITULO
   DO PANT_CONS
   DO PIDE_FAUT
   IF LASTKEY() = 27
      EXIT
   ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE PIDE_FAUT
*******************

*Pide Datos Para Consulta

DECLARE V_COMPRO[1]
V_COMPRO[1] = 'REMITO'

DECLARE COD_COMP[1]
COD_COMP[1]='REM'


DECLARE V_ARTI[21]
DECLARE V_CANTIDAD[21]
DECLARE V_PRECIO[21]
DECLARE V_TOTAL[21]
DECLARE FACTURA[21]
DECLARE IMPORTE[21]
DECLARE COMP_REC[21]
DECLARE V_DESCUEN[21]
DECLARE VALOR[21]
DECLARE V_CANTAUX[21]
DECLARE V_DESCR[21]
DECLARE REMI1[200]
DECLARE REMI2[200]
DECLARE ACTIVO[200]
DECLARE REMI4[200]
DECLARE V_DESCU[4]
DECLARE V_PORC[15]
FOR I = 1 TO 200
   REMI4[I] = ''
NEXT

PRIVATE R5,M_TOTPAR,M_COMPRO,M_FRASE,M_P,M_CONDP,REMITO,MENSAJE,M_OC,M_PREDOLAR,M_FECH,COPIAS,M_TIPOC,M_CLIENTE
PRIVATE C,CONTADO,M_VENDEDOR,DOLAR,M_FACTU,ADIC,M_IVA,M_BONIF,M_DESCU,TOTNETO,TOTALF,BIEN,M_DESDE2,REMI3,NUMCOMP,M_NROREM,M_COTIZA,M_PROVI

R5 = .F.
M_TOTPAR = 0
SAVE SCREEN TO M_PAUX
DO WHILE .T.
   IF !R5
      @ 1,0 TO 23,79 DOUBLE
   ELSE
      @ 1,0 TO 23,79 DOUBLE
      @ 23,79 SAY '.'
   ENDIF
   RESTORE SCREEN FROM M_PAUX
   M_NUM = SELE_REM()
   IF M_NUM = 0
      EXIT
   ENDIF
   BIEN = .F.
   M_DESDE2 = 1
   DO WHILE !BIEN
      M_CONTADOR = 1
      DO CARGA_VARIA WITH M_DESDE2
      IF !R5
         SELE 11
         USE CLIENTES INDEX CLIENTES
         SEEK M_CLIENTE
         ARCHIVO = 'CLIENTES'
      ELSE
         SELE 11
         USE AUXI_C INDEX AUXI_C
         SEEK M_CLIENTE
         ARCHIVO = 'AUXI_C'
      ENDIF
      SET COLOR TO I
      @ 3,28 SAY SUBSTR(NOMBRE,1,30)
      SET COLOR TO
      DO MUESTRA
      DO PIDE_DESCU
      DO PANT_TOT
      PEPE = 1
      IF !R5
         SELE 13
      ELSE
         SELE 18
      ENDIF
      SEEK 'FAC'
      M_NUMERO = NUMERO
      NUMCOMP = NUMERO
      IF APRUEBA(24,0,21)
         IF APRUEBA(24,0,49)
            DO IMPRIME2
         ENDIF
         @ 24,0 SAY SPACE(79)
         DO GRAB_ARCHI
         IF !R5
            SELE 4
         ELSE
            SELE 7
         ENDIF
         FOR I = 1 TO 200
            IF VAL(SUBSTR(REMI4[I],1,5)) <> 0
               IF ACTIVO[I]
                  SEEK 'REM' +  SUBSTR(REMI4[I],1,5)
                  REPLACE FACTURADO WITH .T.
               ENDIF
            ELSE
               I = 201
            ENDIF
         NEXT
      ENDIF
   ENDDO
ENDDO
CLOSE ALL
RETURN


*!*********************************************************************
*!
*!       Function: SELE_REM()
*!
*!      Called by: PIDE_FAUT      (procedure in FA.PRG)
*!
*!          Calls: ESPERAR()      (function  in SIAAC1.PRG)
*!               : LASTKEY()      (function  in ?)
*!               : RETURN()       (function  in ?)
*!               : CHR()          (function  in ?)
*!               : EOF()          (function  in ?)
*!               : STR()          (function  in ?)
*!               : SUBSTR()       (function  in ?)
*!               : M_CARTEL       (procedure in SIAAC1.PRG)
*!               : VENTOPCION()   (function  in SIAAC1.PRG)
*!
*!*********************************************************************
FUNCTION SELE_REM
*****************
*Selecciona Remitos a Facturar
DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
ESPERAR(0)
IF LASTKEY() = 27
   RETURN(0)
ENDIF

*IF LASTKEY() = 106
*   IF R5
*      R5 = .F.
*   ELSE
*      ?? CHR(7)
*      @ 23,79 SAY '.'
*      R5 = .T.
*   ENDIF
*ENDIF
IF !R5
   SELE 11
   USE CLIENTES INDEX CLIENTES
ELSE
   SELE 11
   USE AUXI_C INDEX AUXI_C
ENDIF

FOR I = 1 TO 200
   REMI1[I]  = ''
   REMI2[I]  = ''
   ACTIVO[I] = .F.
NEXT

IF !R5
   SELE 4
   ARCHIVO = 'COMPRO1'
ELSE
   SELE 7
   ARCHIVO = 'AUXILI2'
ENDIF
GO TOP
I = 0
DO WHILE !EOF()
   IF TIPO = 'REM' .AND. !FACTURADO .AND. !ANULADA
      I = I + 1
      SELE 11
      SEEK &ARCHIVO->CLIENTE
      IF !R5
         SELE 4
         REMI1[I] = STR(NUMERO,5,0) + ' ' + SUBSTR(CLIENTES->NOMBRE,1,20)
         REMI2[I] = STR(NUMERO,5,0) + ' ' + SUBSTR(CLIENTES->NOMBRE,1,20) + ' û'
      ELSE
         SELE 7
         REMI1[I] = STR(NUMERO,5,0) + ' ' + SUBSTR(AUXI_C->NOMBRE,1,20)
         REMI2[I] = STR(NUMERO,5,0) + ' ' + SUBSTR(AUXI_C->NOMBRE,1,20) + ' û'
      ENDIF
   ENDIF
   SKIP
ENDDO
IF I = 0
   DO M_CARTEL WITH 61,24,0,.T.,.T.,.T.
   ESPERAR(0)
   RETURN(0)
ENDIF

DECLARE REMI3[I]
FOR A = 1 TO I
   REMI3[A] = REMI1[A]
NEXT
ELIGIO = .F.
PRIMER = .T.
DO WHILE .T.
   SAVE SCREEN TO M_PANTA
   IF R5
      @ 23,79 SAY '.'
   ELSE
      @ 1,0 TO 23,79 DOUBLE
   ENDIF
   IF PRIMER
      L = 1
      PRIMER = .F.
   ELSE
      L = C
   ENDIF
   C = VENTOPCION('REMITOS PENDIENTES DE FACTURACION',REMI3,10,30,20,.T.,.T.,L)
   RESTORE SCREEN FROM M_PANTA
   IF LASTKEY() = 27
      IF ELIGIO
         FOR Z = 1 TO I
            REMI4[Z] = REMI3[Z]
         NEXT
         RETURN(1)
      ELSE
         RETURN(0)
      ENDIF
   ENDIF
   IF ACTIVO[C]
      ACTIVO[C] = .F.
      REMI3[C] = REMI1[C]
   ELSE
      ACTIVO[C] = .T.
      REMI3[C] = REMI2[C]
   ENDIF
   ELIGIO = .T.
ENDDO


*!*********************************************************************
*!
*!      Procedure: CARGA_VARIA
*!
*!      Called by: PIDE_FAUT      (procedure in FA.PRG)
*!
*!          Calls: BLANQ_VEC      (procedure in FACTURA.PRG)
*!               : VAL()          (function  in ?)
*!               : SUBSTR()       (function  in ?)
*!               : CARGA_VEC      (procedure in CONSULTA.PRG)
*!               : STR()          (function  in ?)
*!
*!*********************************************************************
PROCEDURE CARGA_VARIA
*********************
*Carga Variables para Imprimir
PARAMETERS M_DESDE

IF !R5
   SELE 4
ELSE
   SELE 7
ENDIF

DO BLANQ_VEC WITH .T.,0
M_NROREM = ''
M_BONIF = 0
ADIC = 0
M_IVA = 0
TOTALF = 0
TOTNETO = 0
FOR W = M_DESDE TO 200
   IF ACTIVO[W]
      M_COMPRO = 'REM'
      M_NUM = VAL(SUBSTR(REMI4[W],1,5))
      IF M_CONTADOR < 19
         DO CARGA_VEC WITH M_CONTADOR
         IF !R5
            SELE 4
         ELSE
            SELE 7
         ENDIF
         SEEK M_COMPRO + STR(M_NUM,5,0)
         M_CLIENTE = CLIENTE
         TOTALF = TOTAL + TOTALF
         M_NROREM = M_NROREM + SUBSTR(REMI4[W],1,5) + '-'
         M_DESDE2 = W + 1
      ELSE
         M_FRASE = ''
         M_P = 100
         M_CONDP = CONDP
         REMITO = .F.
         MENSAJE = .F.
         M_OC = ''
         M_PREDOLAR = COTIZA
         M_FECH = FECHA
         COPIAS = 1
         M_TIPOC = 1
         M_PROVI = PROVI
         M_COMPRO = 'FAC'
         C = 1
         CONTADO = .F.
         M_VENDEDOR = CAJERO
         DOLAR = .T.
         V_COMPRO[1] = 'FACTURA'
         COD_COMP[1] = 'FAC'
         M_COTIZA = COTIZA
         M_FACTU = .T.
         RETURN
      ENDIF
   ENDIF
NEXT

M_FRASE = ''
M_P = 100
M_CONDP = CONDP
REMITO = .F.
MENSAJE = .F.
M_OC = ''
M_PREDOLAR = COTIZA
M_FECH = FECHA
M_PROVI = PROVI
COPIAS = 1
M_TIPOC = 1
M_COMPRO = 'FAC'
C = 1
CONTADO = .F.
M_VENDEDOR = CAJERO
DOLAR = .T.
M_COTIZA=COTIZA
V_COMPRO[1] = 'FACTURA'
COD_COMP[1] = 'FAC'
M_FACTU = .T.
BIEN = .T.
RETURN
*: EOF: FA.PRG
