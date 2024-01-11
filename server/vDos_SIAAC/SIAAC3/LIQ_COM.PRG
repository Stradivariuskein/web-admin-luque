*Liquidacion de Comisiones a Vendedores.

SELE 1
USE VENDEDOR INDEX VENDEDOR

SELE 2
USE COMPRO1 INDEX COMPRO1,COMPRO2

SELE 4
USE VALES

SELE 5
USE CLIENTES INDEX CLIENTES

DECLARE V_AUXI1[200]
DECLARE V_AUXI2[200]
DECLARE ACTIVO[200]
DECLARE TOTALES[2]
DECLARE V_NUMERO[200]
DECLARE V_COMI[200]
DECLARE V_REGI[200]

M_VEND = SPACE(10)
R5 = .F.

DO WHILE .T.
    CLEAR
    DO TITULO
    @ 1,0 TO 23,79 DOUBLE
    DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
    SET COLOR TO I
    @ 3,20 SAY ' * LIQUIDACION de COMISIONES a VENDEDORES * '
    SET COLOR TO
    @ 5,1 TO 5,78
    STOR M_FECHA TO M_DESDE,M_HASTA
    M_DEFI = 'B'
    DO WHILE .T.
        SELE 1
        @ 7,2 SAY  'Numero de Vendedor : ' GET M_VEND PICT '@!'
        @ 9,2 SAY  'Desde Fecha        : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
        @ 11,2 SAY 'Hasta Fecha        : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
        @ 13,2 SAY '(D)efinitiva o (B)orrador : ' get m_defi pict '@A' valid m_defi = 'D' .or. m_defi = 'B'
        READ
        IF LASTKEY() = 27
           EXIT
        ENDIF
        SEEK M_VEND
        IF !FOUND()
             DO M_CARTEL WITH 109,24,0,.T.,.T.,.T.
             ESPERAR(0)
             @ 24,79 SAY SPACE(79)
        ELSE
             EXIT
        ENDIF
    ENDDO
    IF LASTKEY() = 27
          EXIT
    ENDIF
    DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
    @ 2,1 CLEAR TO 22,78
    SET COLOR TO I
    @ 3,1 SAY 'Liquidacion de Comisiones del Vendedor : ' + SUBSTR(VENDEDOR->NOMBRE,1,30)
    SET COLOR TO
    SELE 2
    INDEX ON CAJERO + DTOS(FECHA) TO AUXILI0
    SEEK M_VEND
    TOTALES[1] = 0
    TOTALES[2] = 0
    Z = 0
    TOTVAL = 0
    DO SUMA_VALES
    FOR A = 1 TO 200
        V_AUXI1[A] = ''
        V_AUXI2[A] = ''
        V_NUMERO[A] = 0
        ACTIVO[A] = .T.
        V_COMI[A] = 0
        V_REGI[A] = 0
    NEXT
    FOR I = 1 TO 1
       SELE 2
       DO WHILE !EOF() .AND. CAJERO = M_VEND
                IF TIPO = 'FAC' .OR. TIPO = 'CDO'
                   IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA .AND. !COMISION .AND. CANCELADA .AND. !ANULADA
                       Z = Z + 1
                       IF TIPO = 'CDO'
                           M_T = TOTAL / 1.21
                       ELSE
                           M_T = TOTAL
                       ENDIF
                       SUBT = M_T - DESPAGO
                       SELE 5
                       SEEK COMPRO1->CLIENTE
                       M_R = 'RUBRO' + RUBRO
                       SELE 2
                       COMI = SUBT * VENDEDOR->&M_R / 100
                       TOTALES[1] = TOTALES[1] + 1
                       TOTALES[2] = TOTALES[2] + COMI
                       V_COMI[Z] = COMI
                       V_NUMERO[Z] = NUMERO
                       V_REGI[Z] = RECNO()
                       V_AUXI1[Z] = DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + ' ' + TRANSFORM(COMI,'###,###.##') + ' ' + SUBSTR(CLIENTES->NOMBRE,1,25) + ' û'
                       V_AUXI2[Z] = DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + ' ' + TRANSFORM(COMI,'###,###.##') + ' ' + SUBSTR(CLIENTES->NOMBRE,1,25)
                   ENDIF
                ELSEIF (TIPO = 'NCR'.OR.TIPO='NCB') .AND. !ANULADA .AND. CANCELADA .AND. !COMISION
                   IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA
                       Z = Z + 1
                       IF TIPO = 'NCB'
                           M_T = TOTAL / 1.21
                       ELSE
                           M_T = TOTAL
                       ENDIF
                       SUBT = M_T - DESPAGO
                       SELE 5
                       SEEK COMPRO1->CLIENTE
                       M_R = 'RUBRO' + RUBRO
                       SELE 2
                       COMI = SUBT * VENDEDOR->&M_R / 100
                       TOTALES[1] = TOTALES[1] + 1
                       TOTALES[2] = TOTALES[2] - COMI
                       V_COMI[Z] = COMI * -1
                       V_NUMERO[Z] = NUMERO
                       V_REGI[Z] = RECNO()
                       V_AUXI1[Z] = DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + ' ' + TRANSFORM(COMI,'-##,###.##') + ' ' + SUBSTR(CLIENTES->NOMBRE,1,25) + ' û'
                       V_AUXI2[Z] = DTOC(FECHA) + ' ' + TIPO + ' ' + STR(NUMERO,5,0) + ' ' + TRANSFORM(COMI,'-##,###.##') + ' ' + SUBSTR(CLIENTES->NOMBRE,1,25)
                   ENDIF
                ENDIF
                SKIP
       ENDDO
    NEXT
    IF Z = 0
        DO M_CARTEL WITH 85,24,0,.T.,.T.,.T.
        ESPERAR(0)
        LOOP
    ENDIF
    DECLARE COMISI[Z]
    FOR W = 1 TO Z
        COMISI[W] = V_AUXI1[W]
    NEXT
    PRIMERA = .T.
    M_GASTOS = 0
    DO WHILE .T.
        DO PONE_TOT WITH .F.
        IF PRIMERA
             L = 1
             PRIMERA = .F.
        ENDIF
        L = VENTOPCION('FECHA  FAC   NUMERO    IMPORTE     CLIENTE',COMISI,4,0,15,.T.,.T.,L)
        IF LASTKEY() = 27
             EXIT
        ENDIF
        IF LASTKEY() = 13
               IF ACTIVO[L]
                     ACTIVO[L] = .F.
                     COMISI[L] = V_AUXI2[L]
                     TOTALES[1] = TOTALES[1] - 1
                     TOTALES[2] = TOTALES[2] - V_COMI[L]
               ELSE
                     ACTIVO[L] = .T.
                     COMISI[L] = V_AUXI1[L]
                     TOTALES[1] = TOTALES[1] + 1
                     TOTALES[2] = TOTALES[2] + V_COMI[L]
               ENDIF
        ENDIF
    ENDDO
    @ 20,0 CLEAR TO 22,79
    @ 20,0 to 22,79
    @ 21,1 SAY 'GASTOS del VENDEDOR : ' GET M_GASTOS PICT '#######.##'
    READ
    IF LASTKEY() = 27
        LOOP
    ENDIF
    IF APRUEBA(24,0,21)
          @ 24,0 SAY SPACE(79)
          M_COPIAS = 2
          @ 24,1 SAY 'Cantidad de Copias : ' GET M_COPIAS PICT '#'
          READ
          SELE 2
          USE COMPRO1 INDEX COMPRO1,COMPRO2
          DO IMP_LIQ
    ENDIF
ENDDO
CLOSE ALL
RETURN

PROCEDURE IMP_LIQ
********* *******
*Graba Liquidacion e Imprime
SET DEVICE TO PRINT
LINEAS = 70
PRIMERA = .T.
HOJA = 1
FOR L = 1 TO M_COPIAS
       FOR A = 1 TO Z
           IF LINEAS > 66
                DO ENC_LIQ
           ENDIF
           IF ACTIVO[A]
              @ LINEAS,1 SAY COMISI[A]
              LINEAS = LINEAS + 1
              SELE 2
              GO V_REGI[A]
              IF M_DEFI = 'D'
                   REPLACE COMISION WITH .T.
              ENDIF
           ENDIF
       NEXT
       DO PONE_TOT WITH .T.
       LINEAS = 70
NEXT
EJECT
SET DEVICE TO SCREEN
RETURN



PROCEDURE ENC_LIQ
********* *******

IF PRIMERA
    PRIMERA = .F.
ELSE
    EJECT
ENDIF
LINEAS = 1
@ LINEAS,1 SAY 'Liquidacion de Comisiones del Vendedor : ' + VENDEDOR->NOMBRE
@ LINEAS + 2,1 SAY 'Fecha de Liquidacion : ' + DTOC(M_FECHA)
@ LINEAS + 2,60 SAY 'Hoja Nro : ' + STR(HOJA,3,0)
@ LINEAS + 4,1 SAY 'Fecha        Factura  Importe         Cliente'
@ LINEAS +5,1 SAY REPLICATE('=',79)
LINEAS = 7
HOJA = HOJA + 1
RETURN


PROCEDURE SUMA_VALES
********************
SELE 4
GO TOP
TOTVAL = 0
DO WHILE !EOF()
     IF M_VEND = EMPL
         TOTVAL = TOTVAL + IMP
     ENDIF
     SKIP
ENDDO
RETURN

PROCEDURE PONE_TOT
********* ********
PARAMETERS IMPRE
*Pone Totales Al Margen de la Pantalla o IMPRESORA.
IF !IMPRE
   @ 1,0 TO 15,79 DOUBLE
   @ 15,0 CLEAR TO 23,79
   @ 15,0 TO 20,79
ENDIF
IF !IMPRE
    @ 16,1 SAY 'Gastos ............. '
    @ 17,1 SAY 'Total en Comisiones. '
    @ 18,1 SAY 'Total de Vales...... '
    @ 19,1 SAY 'Total a Pagar ...... '
    @ 16,30 SAY M_GASTOS PICT '###,###,###.##'
    @ 17,30 SAY  TOTALES[2] PICT '###,###,###.##'
    @ 18,30 SAY TOTVAL PICT '###,###,###.##'
    @ 19,30 SAY  TOTALES[2]  + M_GASTOS - TOTVAL PICT '###,###,###.##'
ELSE
    @ LINEAS + 2,2 SAY 'Gastos ............. ' + STR(M_GASTOS,14,2)
    @ LINEAS + 3,2 SAY 'Total en Comisiones. ' + STR(TOTALES[2],14,2)
    @ LINEAS + 4,2 SAY 'Total de Vales...... ' + STR(TOTVAL,14,2)
    @ LINEAS + 5,2 SAY 'Total a Pagar ...... ' + STR(TOTALES[2]-TOTVAL + M_GASTOS,14,2)
ENDIF
RETURN
