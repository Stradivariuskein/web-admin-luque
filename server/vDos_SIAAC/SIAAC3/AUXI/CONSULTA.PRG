*******************************************************************************
*CONSULTA.PRG
*
*Consulta de Comprobantes Anteriores
*
*******************************************************************************


*IF !SEGURIDAD(MM_CLAVE,'U')
*     DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*     ESPERAR(0)
*     RETURN
*ENDIF

SELE 2
USE ARTIC INDEX ARTIC

SELE 9
USE VENDEDOR INDEX VENDEDOR

SELE 11
USE CLIENTES INDEX CLIENTES

SELE 19
USE DOMICILI INDEX DOMICILI

SELE 25
USE IVA

SELE 22
USE PROVI INDEX PROVI

SELE 23
USE EXPRESO INDEX EXPRESO

DO WHILE .T.
   CLEAR
   DO TITULO
   DO PANT_CONS
   DO PIDE_CONS
   IF LASTKEY() = 27
      EXIT
   ENDIF
ENDDO
CLOSE ALL
RETURN


*!*********************************************************************
*!
*!      Procedure: PANT_CONS
*!
*!      Called by: FA.PRG
*!               : CONSULTA.PRG
*!
*!*********************************************************************
PROCEDURE PANT_CONS
*******************
*Pantalla de Consulta

@ 1,0 TO 23,79 DOUBLE
@ 8,1 TO 18,78
@ 2,3 SAY 'C¢digo de Comprobante :                                      '
@ 3,3 SAY 'Cliente               :                                      '
@ 4,3 SAY 'Comprobante N£mero    :                                      '
@ 6,3 SAY 'Fecha  :              '
@ 9,2 SAY 'ITEM         ARTICULO             CANTIDAD           PRECIO         TOTAL'
@ 10,2 SAY REPLICATE('=',76)
@ 11,2 CLEAR TO 17,77
RETURN



PROCEDURE PIDE_CONS
*******************
*Pide Datos Para Consulta

DECLARE V_COMPRO[6]
V_COMPRO[1] = 'FACTURA'
V_COMPRO[2] = 'CONSUMIDOR FINAL'
V_COMPRO[3] = 'NOTA DE DEBITO'
V_COMPRO[4] = 'NOTA DE CREDITO'
V_COMPRO[5] = 'REMITO'
V_COMPRO[6] = 'RECIBO AUTORIZADO'

DECLARE COD_COMP[6]
COD_COMP[1]='FAC'
COD_COMP[2]='CDO'
COD_COMP[3]='NDB'
COD_COMP[4]='NCR'
COD_COMP[5]='REM'
COD_COMP[6]='REC'

DECLARE V_ARTI[35]
DECLARE V_CANTIDAD[35]
DECLARE V_PRECIO[35]
DECLARE V_TOTAL[35]
DECLARE FACTURA[21]
DECLARE IMPORTE[21]
DECLARE COMP_REC[21]
DECLARE DESCUENTO[21]
DECLARE V_DESCUEN[35]
DECLARE VALOR[21]
DECLARE V_CANTAUX[35]
DECLARE V_DESCR[35]
DECLARE V_PORC[15]
DECLARE V_DETALLE[35]
DECLARE V_PRELIS[35]
AFILL(V_DETALLE,SPACE(70))

R5 = .F.
M_TOTPAR = 0
SAVE SCREEN TO M_PANTA
PIDE = .T.
DO WHILE .T.
      IF PIDE
            RESTORE SCREEN FROM M_PANTA
            IF R5
               @ 23,79 SAY '.'
            ELSE
               @ 1,0 TO 23,79 DOUBLE
            ENDIF
            C = VENTOPCION('CODIGO DE OPERACION',V_COMPRO,10,30,20,.T.,.T.,1)
            IF LASTKEY() <> 27
               M_COMPRO = COD_COMP[C]
            ELSE
               EXIT
            ENDIF
            RESTORE SCREEN FROM M_PANTA
            @ 2,28 SAY SPACE(30)
            SET COLOR TO I
            @ 2,28 SAY V_COMPRO[C]
            SET COLOR TO
            M_NUM = 1
            M_COD = 1
            @ 4,28 GET M_NUM PICT '#####' VALID M_NUM > 0
            READ
            IF LASTKEY() = 27
                EXIT
            ENDIF
            IF R5
               SELE 7
            ELSE
               SELE 5
               USE DETALLE1 INDEX DETALLE1
               SELE 4
               USE COMPRO1 INDEX COMPRO1
           ENDIF
           SEEK M_COMPRO + STR(M_NUM,5,0)
           IF !FOUND()
               DO M_CARTEL WITH 31,24,0,.T.,.T.,.T.
               ESPERAR(0)
               @ 24,0 SAY SPACE(79)
               LOOP
           ENDIF
      ENDIF
      M_NUMERO=NUMERO
      IF LASTKEY() = 27
           EXIT
      ENDIF
      IF ANULADA
         SET COLOR TO I
         @ 4,50 SAY 'ANULADA'
         SET COLOR TO
      ELSE
         @ 4,50 SAY SPACE(10)
      ENDIF
      M_CLIENTE = CLIENTE
      SELE 11
      IF !R5
         USE CLIENTES INDEX CLIENTES
         ARCHIVO = 'CLIENTES'
      ELSE
         USE AUXI_C INDEX AUXI_C
         ARCHIVO = 'AUXI_C'
      ENDIF
      SEEK M_CLIENTE
      SET COLOR TO I
      @ 3,28 SAY SUBSTR(NOMBRE,1,20)
      SET COLOR TO
      SELE 4
      M_FECH = FECHA
      @ 6,28 GET M_FECH PICT '99/99/99' VALID VALFECH(M_FECH)
      READ
      IF LASTKEY() = 27
         LOOP
      ENDIF
      IF M_COMPRO = 'FAC' .OR. M_COMPRO = 'REM' .OR. M_COMPRO = 'CDO' .OR. TIPO = 'NCR'
         DO BLANQ_VEC WITH .T.,0,0
         DECLARE V_PORC[15]
         M_CLIENTE = CLIENTE
         M_FRASE = FRASE
         M_BONIF = BONIF
         M_NROREM = NROREM
         M_IVA = IVA
         ADIC = REC_IVA
         TOTNETO = 0
         M_COND1 = COND1
         M_COND2 = COND2
         M_COND3 = COND3
         M_COND4 = COND4
         M_COND5 = COND5
         FOR I = 1 TO 15
             IF I < 10
                 M_PORC = 'PORC' + STR(I,1,0)
             ELSE
                 M_PORC = 'PORC' + STR(I,2,0)
             ENDIF
             V_PORC[I] = &M_PORC
         NEXT
         M_PAQUETES = PAQUETES
         M_KILOS = KILOS
         M_LIOS = LIOS
         M_CONTADOR = 1
         PEPE = DIREC
         MENSAJE = .F.
         DO CARGA_VEC WITH 1
         SELE 4
         TOTALF = TOTAL
         DO MUESTRA
         DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
         ESPERAR(0)
         @ 24,0 SAY SPACE(79)
         DO PANT_TOT
         IF VAL(M_NROREM) <> 0
            REMITO = .T.
         ELSE
            REMITO = .F.
         ENDIF
      ELSE
         IF M_COMPRO = 'REC' .OR. M_COMPRO = 'NDB'
            FOR I = 1 TO 21
               FACTURA[I] = 0
               IMPORTE[I] = 0
               COMP_REC[I] = 0
               VALOR[I] = 0
            NEXT
            NUMCOMP = NUMERO
            IF M_COMPRO = 'NCR' .OR. M_COMPRO = 'NDB'
               TOTNETO = TOTAL + IVA + REC_IVA
               TOT_REC = TOTAL
               M_IVA = IVA
               ADIC = REC_IVA
               M_CONC1 = SUBSTR(CONCEPTO,1,50)
               M_CONC2 = SUBSTR(CONCEPTO,51,49)
            ELSE
               TOT_REC = TOTAL
            ENDIF
            M_TIPOC = 1
            SELE 4
            M_NUMERO = M_NUM
            SEEK 'NC2' + STR(M_NUMERO,5,0)
            IF !FOUND()
                   M_IMPCREDI = 0
            ELSE
                   M_IMPCREDI = TOTAL
            ENDIF
            SEEK M_COMPRO + STR(M_NUMERO,5,0)
            DO MUES_REC
            @ 22,3 SAY 'Total : ' + IIF(M_COMPRO = 'REC',STR(TOT_REC,14,2),STR(TOTNETO,14,2))
         ENDIF
      ENDIF
      @ 23,0 SAY SPACE(79)
      @ 24,0 SAY SPACE(79)
      DESEO = 'C'
      @ 20,0 CLEAR TO 24,79
      @ 20,0 TO 23,79
      @ 21,1 SAY '(E)MITE,(A)NULA,(C)ONSULTA,(D)ESANULA,(S)ACAR PENDIENTE DE FACTURACION'
      @ 22,1 SAY 'COMISION (N)O PAGA,ELIMINAR DE COMISIONES (P)ENDIENTES DE LIQUIDACION 'GET DESEO PICT 'A' VALID DESEO = 'E' .OR. DESEO = 'C' .OR. DESEO = 'A' .OR. DESEO = 'D' .OR. DESEO = 'S' .OR. DESEO = 'Q' .OR. DESEO = 'N' .OR. DESEO = 'P'
      READ
      @ 24,0 SAY SPACE(79)
      IF DESEO = 'P'
            SELE 4
            REPLACE COMISION WITH .T.
            LOOP
      ENDIF
      IF DESEO = 'N'
            SELE 4
            REPLACE COMISION WITH .F.
            LOOP
      ENDIF
      IF DESEO = 'C' .AND. R5
           PIDE = .T.
           LOOP
      ENDIF
      IF DESEO = 'S'
           SELE 4
           IF !FACTURADO
              REPLACE FACTURADO WITH .T.
           ELSE
              REPLACE FACTURADO WITH .F.
           ENDIF
           LOOP
      ENDIF
      IF DESEO = 'D'
         IF !R5
            SELE 4
            REPLACE ANULADA WITH .F.
            IF TIPO = 'FAC' .OR. TIPO = 'NDB' .OR. TIPO = 'AJD'
               M_IMPAUX = TOTAL + IVA + REC_IVA
               SELE 11
               USE CLIENTES INDEX CLIENTES
               SEEK M_CLIENTE
               IF !R5
                  REPLACE SALDO WITH SALDO + M_IMPAUX
               ELSE
                  REPLACE SALDOI WITH SALDOI + M_IMPAUX
               ENDIF
            ELSE
               M_IMPAUX = TOTAL + IVA + REC_IVA
               SELE 11
               USE CLIENTES INDEX CLIENTES
               SEEK M_CLIENTE
               IF !R5
                  REPLACE SALDO WITH SALDO - M_IMPAUX
               ELSE
                  REPLACE SALDOI WITH SALDOI - M_IMPAUX
               ENDIF
            ENDIF
         ELSE
            SELE 7
            REPLACE ANULADA WITH .F.
         ENDIF
         LOOP
      ENDIF
      IF DESEO = 'A'
         IF APRUEBA(24,0,2)
            DO GRAB_ANUL
            @ 24,0 SAY SPACE(79)
         ENDIF
         @ 24,0 SAY SPACE(79)
      ELSE
         IF DESEO = 'E'
            IF APRUEBA(24,0,116)
                M_SI = .F.
            ELSE
                M_SI = .T.
            ENDIF
            IF M_COMPRO = 'REC'
                  LOOP
            ENDIF
            IF APRUEBA(24,0,21)
               IF M_COMPRO = 'FAC' .OR. M_COMPRO = 'REM' .OR. M_COMPRO = 'CDO' .OR. M_COMPRO = 'NCR'
                  IF M_COMPRO <> 'CDO'
                     CONTADO = .F.
                  ELSE
                     CONTADO = .T.
                  ENDIF
                  SELE 4
                  M_EXPRES = EXPRESO
                  M_CONDICIONES = CONDICIONES
                  FOR I = 1 TO 10
                        M_AUX = 'VDETALLE' + ALLTRIM(STR(I,2,0))
                        V_DETALLE[I] = &M_AUX
                  NEXT
                  IF M_SI
                      M_FECH = FECHA
                  ENDIF
                  SELE 19
                  ARCHI2 = 'DOMICILI'
                  IF PEPE <> 1
                       SEEK M_CLIENTE + STR(PEPE,3,0)
                  ENDIF
                  SELE 22
                  SEEK CLIENTES->TIPO_CLI
                  SELE 23
                  SEEK M_EXPRES
                  IF M_COMPRO = 'FAC'
                      IF APRUEBA(24,0,41)
                          MENSAJE = .T.
                          M_COTIZA = COMPRO1->COTIZA
                      ENDIF
                  ENDIF
                  m_copias = 1
                  @ 24,0 SAY SPACE(80)
                  @ 24,0 SAY 'Numero de Copias : ' get m_copias pict '#'
                  read
                  DO IMPRIME2 WITH M_SI,.F.
                  SELE 4
                  IF !M_SI
                      REPLACE FECHA WITH M_FECH
                  ENDIF
               ELSE
                  DO BLANQ_VEC WITH .T.,0,0
                  DECLARE V_PORC[15]
                  M_CLIENTE = CLIENTE
                  M_FRASE = FRASE
                  M_BONIF = BONIF
                  M_NROREM = NROREM
                  M_IVA = IVA
                  ADIC = REC_IVA
                  TOTNETO = TOTAL + M_IVA + ADIC
                  TOTALF = TOTAL
                  M_COND1 = COND1
                  M_COND2 = COND2
                  M_COND3 = COND3
                  M_COND4 = COND4
                  M_COND5 = COND5
                  FOR I = 1 TO 15
                      IF I < 10
                          M_PORC = 'PORC' + STR(I,1,0)
                      ELSE
                          M_PORC = 'PORC' + STR(I,2,0)
                      ENDIF
                      V_PORC[I] = &M_PORC
                  NEXT
                  M_PAQUETES = PAQUETES
                  M_KILOS = KILOS
                  M_LIOS = LIOS
                  IF M_COMPRO = 'NDB'
                       PEPE = 1
                       M_CONDICIONES = ''
                  ELSE
                       PEPE = DIREC
                  ENDIF
                  MENSAJE = .F.
                  TOT_REC = TOTAL
                  M_EXPRES = EXPRESO
                  IF M_COMPRO = 'REC'
                     DO IMP_RECI
                     SELE 4
                     REPLACE FECHA WITH M_FECH
                  ELSE
                     SELE 4
                     IF M_SI
                        M_FECH = FECHA
                     ENDIF
                     SELE 22
                     SEEK CLIENTES->TIPO_CLI
                     DO IMPRIME2 WITH M_SI
                     SELE 4
                     IF !M_SI
                        REPLACE FECHA WITH M_FECH
                     ENDIF
                  ENDIF
               ENDIF
               @ 24,0 SAY SPACE(79)
            ENDIF
            @ 24,0 SAY SPACE(79)
         ENDIF
      ENDIF
ENDDO
CLOSE ALL
RETURN


*!*********************************************************************
*!
*!      Procedure: CARGA_VEC
*!
*!      Called by: CARGA_VARIA    (procedure in FA.PRG)
*!               : PIDE_CONS      (procedure in CONSULTA.PRG)
*!
*!          Calls: STR()          (function  in ?)
*!               : EOF()          (function  in ?)
*!
*!*********************************************************************
PROCEDURE CARGA_VEC
*******************
*Carga Vector de Comprobantes
PARAMETERS M_CONTA
IF R5
   SELE 6
ELSE
   SELE 5
ENDIF

SEEK M_COMPRO + STR(M_NUM,5,0)
Q=M_CONTA
DO WHILE !EOF() .AND. TIPO = M_COMPRO .AND. NUMERO = M_NUM
   V_ARTI[Q] = ARTICULO
   V_CANTIDAD[Q] = CANTIDAD
   V_PRECIO[Q] = PRECIO
   V_TOTAL[Q] = PRECIO * CANTIDAD
   V_DESCUEN[Q] = DESCUENTO
   V_DESCR[Q] = DESCR
   V_PRELIS[Q] = PRELIS
   Q = Q + 1
   SKIP
   M_CONTADOR = M_CONTADOR + 1
ENDDO
RETURN



*!*********************************************************************
*!
*!      Procedure: GRAB_ANUL
*!
*!      Called by: PIDE_CONS      (procedure in CONSULTA.PRG)
*!
*!*********************************************************************
PROCEDURE GRAB_ANUL
*******************

SELE 4
REPLACE ANULADA WITH .T.
IF TIPO = 'REC'
     SEEK 'NC2' + STR(M_NUM,5,0)
     REPLACE ANULADA WITH .T.
ELSEIF TIPO = 'FAC'
     IF ALLTRIM(CONDICIONE) = 'CONTADO'
            SEEK 'RE2' + STR(RELAC,5,0)
            REPLACE ANULADA WITH .T.
     ENDIF
ENDIF
RETURN
