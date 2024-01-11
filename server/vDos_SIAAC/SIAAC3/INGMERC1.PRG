*Ingreso de Mercaderias.PARA DISTRIBUIDORAS QUE DETALLAN ARTICULO TIPO P.T.

*IF !SEGURIDAD(MM_CLAVE,'H')
*     DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
*     ESPERAR(0)
*     RETURN
*ENDIF

SELE 1
USE RESUMEN INDEX RESUMEN

SELE 2
USE ARTIC INDEX ARTIC

*SELE 8
*USE AUXILI8 INDEX AUXILI8

SELE 9
USE CONTADO1 INDEX CONTADO1

SELE 12
USE PROVEDOR INDEX PROVEDOR

SELE 20
USE DOLAR INDEX DOLAR
SEEK M_FECHA

SELE 21
USE COMPRAS INDEX COMPRAS

*SELE 22
*USE AUXIPRIM INDEX AUXIPRIM

SELE 25
USE IVA

PRIVATE M_BRUTO,M_NETO,M_IVA,M_INT,M_NROF,M_FECHF,M_PAGO,M_ADIC,M_TOTAL,M_FVEC,M_SUBT1

DECLARE V_CANTI[11]

R5 = .F.

STOR 0 TO M_SUBT1,M_SUBT2

DO WHILE .T.
   CLEAR
   @ 3,0 TO 23,79 DOUBLE
   IF R5
      @ 23,79 SAY '.'
   ENDIF
   DO TITULO
   @ 2,3 SAY 'C╒digo de Proveedor: '
   M_PROV = SELE_PROV(5,40,15)
   IF EMPTY(M_PROV)
      EXIT
   ENDIF
   SELE 12
   SEEK M_PROV
   SET COLOR TO I
   @ 1,2 SAY TRIM(NOMBRE)
   SET COLOR TO
   M_NROF = 0
   M_FECHF = DATE()
   SELE 9
   IF !R5
      SEEK 'INT'
   ELSE
      SEEK 'R5I'
   ENDIF
   M_INT =NUMERO
   M_TIPO = 'FAC'
   @ 2,1 CLEAR TO 2,79
   @ 2,2 SAY 'Tipo : ' GET M_TIPO VALID M_TIPO = 'FAC' .OR. M_TIPO = 'NDB' .OR. M_TIPO = 'NCR' .OR. M_TIPO = 'REM'
   @ 2,15 SAY 'Nro: ' GET M_NROF PICT '##########'
   @ 2,32 SAY 'Fecha : ' GET M_FECHF PICT '99/99/99' VALID VALFECH(M_FECHF)
   @ 2,60 SAY 'Nro. Int : ' + STR(M_INT,5,0)
   READ
   IF LASTKEY() = 27
      EXIT
   ENDIF
   DECLARE M_ARTI[20]
   FOR M = 1 TO 20
      M_ARTI[M] =  SPACE(10)
   NEXT
   @ 5,2 SAY 'Art.: '
   @ 7,2 SAY 'Cant: '
   @ 19,2 SAY 'Pre : '
   @ 21,2 SAY 'Tot.: '
   FI = 5
   CO = 9
   IT = 1
   TOTALF = 0
   TOTPAR = 0
   DO DIBUJA
   FOR  MA = 1 TO 20
      DO PIDE_INGRES WITH MA,FI,CO
      IF LASTKEY() = 27
         SAVE SCREEN TO M_PANTA
         IF M_TIPO <> 'REM'
             DO MUES_TTL
         ELSE
             M_IVA = 0
             M_ADIC = 0
             M_FVEC = DATE()
             M_PAGO = 'I'
             M_TOTAL = 0
         ENDIF
         IF APRUEBA(24,0,2)
            IF !R5
               SELE 21
            ELSE
               SELE 22
            ENDIF
            APPEND BLANK
            REPLACE N_INT WITH M_INT
            REPLACE FACTURA WITH M_NROF
            REPLACE IMP_BRUTO WITH M_SUBT1
            REPLACE IVA WITH IIF(!R5,M_IVA,0)
            REPLACE IMP_NETO WITH IIF(!R5,M_TOTAL,TOTALF)
            REPLACE PROVEDOR WITH M_PROV
            REPLACE ESTADO WITH IIF(M_PAGO = 'S','P','I')
            REPLACE ACTA WITH 0
            REPLACE FECHA WITH M_FECHF
            REPLACE TIPO WITH M_TIPO
            REPLACE ADIC WITH M_ADIC
            REPLACE VENC WITH M_FVEC
            SELE 9
            REPLACE NUMERO WITH NUMERO + 1
            MA = 21
         ELSE
            IF APRUEBA(24,0,60)
               MA = 21
            ELSE
               RESTORE SCREEN FROM M_PANTA
            ENDIF
         ENDIF
         @ 24,0 SAY SPACE(79)
      ELSE
         IT = IT + 1
         CO = CO + 14
         IF IT > 5
            FI = 5
            CO = 9
            IT = 1
            @ 5,12 CLEAR TO 22,78
            DO DIBUJA
         ENDIF
      ENDIF
   NEXT
ENDDO
CLOSE ALL
RETURN

PROCEDURE PIDE_INGRES
********* ***********
PARAMETERS ARTIC,F,C

FOR I = 1 TO 11
   V_CANTI[I] = 0
NEXT

DO WHILE .T.
   SELE 2
   @ F,C GET M_ARTI[ARTIC] PICT '@!'
   READ
   IF LASTKEY() = 27
      EXIT
   ENDIF
   SEEK M_ARTI[ARTIC]
   IF !FOUND()
      DO M_CARTEL WITH 15,24,0,.T.,.T.,.T.
      ESPERAR(0)
      @ 24,0 SAY SPACE(79)
      IF APRUEBA(24,0,39)
         SAVE SCREEN TO M_PAUXI
         M_F = F
         M_C = C
         DO ABMARTI

         SELE 2
         USE ARTIC INDEX ARTIC

         SELE 9
         USE CONTADO1 INDEX CONTADO1
         IF !R5
            SEEK 'INT'
         ELSE
            SEEK 'R5I'
         ENDIF
         M_INT = NUMERO

         SELE 12
         USE PROVEDOR INDEX PROVEDOR
         SEEK M_PROV

         SELE 20
         USE DOLAR INDEX DOLAR
         SEEK M_FECHA

         SELE 21
         USE COMPRAS INDEX COMPRAS

*         SELE 22
*         USE AUXIPRIM INDEX AUXIPRIM

         C = M_C
         F = M_F
         RESTORE SCREEN FROM M_PAUXI
      ENDIF
      @ 24,0 SAY SPACE(79)
      LOOP
   ENDIF
   @  F + 2,C+6  GET V_CANTI[1] PICT '#####' VALID V_CANTI[1] >= 0
   M_PRECOM = 0
   @ F + 14,C GET M_PRECOM PICT '########.##' VALID M_PRECOM >= 0
   READ
   IF APRUEBA(24,0,2)
      SELE 2
      CUE = 1
      IF M_TIPO = 'REM'
         SELE 2
         REPLACE STOCK WITH STOCK + V_CANTI[1]
         REPLACE COSTO WITH M_PRECOM
         IF !R5
            SELE 1
         ELSE
            SELE 8
         ENDIF
         APPEND BLANK
         REPLACE ARTICULO WITH M_ARTI[ARTIC]
         REPLACE FECHA WITH M_FECHF
         REPLACE COMPRA WITH V_CANTI[1]
         REPLACE VENTA WITH 0
         REPLACE PCOSTO WITH M_PRECOM
         REPLACE PVENTA WITH 0
      ENDIF
      @ 24,0 SAY SPACE(79)
      TOT_ARTI = 0
      TOT_ARTI = TOT_ARTI + (V_CANTI[1] * M_PRECOM)
      TOTALF = TOTALF + TOT_ARTI
      @ F + 16,C SAY TOT_ARTI PICT '########.##'
      EXIT
   ENDIF
   @ 24,0 SAY SPACE(79)
ENDDO
RETURN

PROCEDURE MUES_TTL
******************
*Muestra Totales de Factura Provedor
DO WHILE .T.
        @ 8,20 TO 21,70 DOUBLE
        @ 9,21 CLEAR TO 20,69
        SET COLOR TO I
        @ 9,38 SAY 'FACTURA PROVEDOR'
        SET COLOR TO
        M_COTIZA = 0
        @ 11,22 SAY 'Cotizacion Dolar...' GET M_COTIZA PICT '#####.##' VALID M_COTIZA > 0
        READ
        IF LASTKEY() = 27
            RETURN
        ENDIF
        TOTALF = TOTALF * M_COTIZA
        M_PORC = PROVEDOR->POR_PAGO
        @ 12,22 SAY 'Subtotal ....  : '
        SET COLOR TO W+
        @ 12,55 SAY TOTALF PICT '###,###,###.##'
        SET COLOR TO
        @ 13,22 SAY '% Financiacion : ' GET M_PORC PICT '###.##'
        READ
        IF LASTKEY() = 27
           LOOP
        ENDIF
        @ 13,55 SAY (TOTALF * M_PORC / 100) PICT '###,###,###.##'
        M_SUBT1 = (TOTALF * M_PORC / 100) + TOTALF
        @ 14,22 SAY 'Subtotal ....  : '
        SET COLOR TO W+
        @ 14,55 SAY M_SUBT1 PICT '###,###,###.##'
        SET COLOR TO
        IF !R5
            M_IVA = M_SUBT1 * IVA->IVA / 100
            M_ADIC = M_SUBT1 * IVA->DIFE / 100
            @ 15,22 SAY 'Iva            : '
            @ 15,55 SAY M_IVA PICT '###,###,###.##'
            @ 16,22 SAY 'Recargo de Iva : ' GET M_ADIC
            READ
            IF LASTKEY() = 27
              LOOP
            ENDIF
            @ 16,55 SAY M_ADIC PICT '###,###,###.##'
        ELSE
            M_IVA = 0
            M_ADIC = 0
        ENDIF
        @ 17,22 SAY 'Total Factura  : '
        M_TOTAL =M_SUBT1 + M_IVA + M_ADIC
        SET COLOR TO W+
        @ 17,55 SAY M_TOTAL PICT '###,###,###.##'
        SET COLOR TO
        M_FVEC = M_FECHA
        @ 18,22 SAY 'Fecha Venc.    : ' GET M_FVEC PICT '99/99/99' VALID VALFECH(M_FVEC)
        M_PAGO = 'N'
        @ 19,22 SAY 'Esta Factura se pago s/n : ' GET M_PAGO PICT 'A' VALID M_PAGO = 'S' .OR. M_PAGO = 'N'
        READ
        IF LASTKEY() = 27
              LOOP
        ENDIF
        EXIT
ENDDO
RETURN

PROCEDURE DIBUJA
********* ******
*Dibuja Pantalla de Compras

@ 4,7 SAY  'здддддддддддддбдддддддддддддбдддддддддддддбдддддддддддддбддддддддддддд©'
@ 5,7 SAY  'Ё             Ё             Ё             Ё             Ё             Ё'
@ 6,7 SAY  'цдддддддддддддедддддддддддддедддддддддддддедддддддддддддеддддддддддддд╢'
@ 7,7 SAY  'Ё             Ё             Ё             Ё             Ё             Ё'
@ 8,7 SAY  'цдддддддддддддедддддддддддддедддддддддддддедддддддддддддеддддддддддддд╢'
@  9,7 SAY 'Ё             Ё             Ё             Ё             Ё             Ё'
@ 10,7 SAY 'Ё             Ё             Ё             Ё             Ё             Ё'
@ 11,7 SAY 'Ё             Ё             Ё             Ё             Ё             Ё'
@ 12,7 SAY 'Ё             Ё             Ё             Ё             Ё             Ё'
@ 13,7 SAY 'Ё             Ё             Ё             Ё             Ё             Ё'
@ 14,7 SAY 'Ё             Ё             Ё             Ё             Ё             Ё'
@ 15,7 SAY 'Ё             Ё             Ё             Ё             Ё             Ё'
@ 16,7 SAY 'Ё             Ё             Ё             Ё             Ё             Ё'
@ 17,7 SAY 'Ё             Ё             Ё             Ё             Ё             Ё'
@ 18,7 SAY 'цдддддддддддддедддддддддддддедддддддддддддедддддддддддддеддддддддддддд╢'
@ 19,7 SAY 'Ё             Ё             Ё             Ё             Ё             Ё'
@ 20,7 SAY 'цдддддддддддддедддддддддддддедддддддддддддедддддддддддддеддддддддддддд╢'
@ 21,7 SAY 'Ё             Ё             Ё             Ё             Ё             Ё'
@ 22,7 SAY 'юдддддддддддддадддддддддддддадддддддддддддадддддддддддддаддддддддддддды'
RETURN
