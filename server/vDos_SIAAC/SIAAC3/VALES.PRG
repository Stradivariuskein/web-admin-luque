*Vales al Personal
DO WHILE .T.
      CLEAR
      DO TITULO
      @ 1,0 TO 23,79 DOUBLE
      DECLARE MENPEE[3]
      DECLARE OPPEE[3]
      OPPEE[1]='VALES a VENDEDORES'
      OPPEE[2]='CONSULTA de VALES ENTREGADOS'
      OPPEE[3]='DEPURACION DEL ARCHIVO DE VALES'
      MENPEE[1]='          º  Vales A VENDEDORES, en Plata'
      MENPEE[2]='          º  Consulta de Vales Anteriores'
      MENPEE[3]='          º  Borra el Archivo de Vales'
*Displaya opciones y captura.
      OPPE=OPCIONES('SISTEMA DE VENTAS - MOVIMIENTO DE CAJA',OPPEE,MENPEE)
*Fin
      IF LASTKEY() = 27
           EXIT
      ENDIF
      DO CASE
           CASE OPPE  = 1
                DO VALE WITH .T.
           CASE OPPE  = 2
                DO CONS_VALES
           CASE OPPE  = 3
                DO DEP_VALES
      ENDCASE
ENDDO
RETURN

PROCEDURE VALE
**************
PARAMETERS CIERRA

IF CIERRA
    SELE 9
    USE VENDEDOR INDEX VENDEDOR

    SELE 21
    USE VALES
ENDIF

DO WHILE .T.
     CLEAR
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     DO TITULO
     @ 1,0 TO 23,79 DOUBLE
     SET COLOR TO I
     @ 3,30 SAY '* VALES a VENDEDORES *'
     SET COLOR TO
     @ 5,2 TO 5,78
     DO WHILE .T.
        SELE 9
        M_EMPL = SPACE(10)
        @ 10,3 SAY 'N£mero de Vendedor : ' GET M_EMPL PICT '@!'
        READ
        IF LASTKEY() = 27
              EXIT
        ENDIF
        SEEK M_EMPL
        IF FOUND()
              SET COLOR TO I
              @ 10,30 SAY NOMBRE
              SET COLOR TO
              EXIT
        ELSE
              DO M_CARTEL WITH 19,24,0,.T.,.T.,.T.
              ESPERAR(0)
              @ 24,0 SAY SPACE(79)
        ENDIF
     ENDDO
     IF LASTKEY() = 27
           EXIT
     ENDIF
     FECH_VAL = M_FECHA
     M_IMP = 0
     @ 12,3 SAY 'Fecha : ' GET FECH_VAL PICT '99/99/99' VALID VALFECH(FECH_VAL)
     @ 14,3 SAY 'Importe : ' GET M_IMP PICT '#########.##' VALID M_IMP >=0
     READ
     IF LASTKEY() = 27
           LOOP
     ENDIF
     IF APRUEBA(24,0,2)
            SELE 21
            APPEND BLANK
            REPLACE EMPL WITH M_EMPL
            REPLACE FECHA WITH FECH_VAL
            REPLACE IMP WITH M_IMP
     ENDIF
     @ 24,0 SAY SPACE(79)
ENDDO
IF CIERRA
  CLOSE ALL
ENDIF
RETURN


PROCEDURE CONS_VALES
********* **********
*Consulta de Vales Anteriores

SELE 21
USE VALES

SELE 9
USE VENDEDOR INDEX VENDEDOR

DO WHILE .T.
     CLEAR
     DO TITULO
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     @ 1,0 TO 23,79 DOUBLE
     SET COLOR TO I
     @ 3,30 SAY '* CONSULTA DE VALES ANTERIORES *'
     SET COLOR TO
     @ 5,2 TO 5,78
     DO WHILE .T.
        SELE 9
        M_EMPL = SPACE(10)
        @ 10,3 SAY 'N£mero de VENDEDOR : ' GET M_EMPL PICT '@!'
        READ
        IF LASTKEY() = 27
              EXIT
        ENDIF
        SEEK M_EMPL
        IF FOUND()
              SET COLOR TO I
              @ 10,30 SAY NOMBRE
              SET COLOR TO
              EXIT
        ELSE
              DO M_CARTEL WITH 19,24,0,.T.,.T.,.T.
              ESPERAR(0)
              @ 24,0 SAY SPACE(79)
        ENDIF
     ENDDO
     IF LASTKEY() = 27
           EXIT
     ENDIF
     IF APRUEBA(24,0,2)
            CLEAR
            DO TITULO
            @ 1,0 TO 23,79
            @ 3,2 SAY 'Vales del VENDEDOR : ' + VENDEDOR->NOMBRE
            @ 5,1 TO 5,78
            SELE 21
            GO TOP
            LINEAS = 25
            HOJA = 1
            TOTAL = 0
            PRIMERA = .T.
            DO WHILE !EOF()
                   IF LINEAS > 20
                          IF !PRIMERA
                              DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
                              ESPERAR (0)
                              @ 24,0 SAY SPACE(79)
                          ELSE
                              PRIMERA = .F.
                          ENDIF
                          @ 6,1 CLEAR TO 22,78
                          LINEAS = 8
                          HOJA = HOJA + 1
                   ENDIF
                   IF EMPL = M_EMPL
                        @ LINEAS,3 SAY 'Fecha : ' + DTOC(FECHA) + '   Importe : ' + STR(IMP,13,2)
                        LINEAS = LINEAS + 1
                        TOTAL = TOTAL + IMP
                   ENDIF
                   SKIP
            ENDDO
            @ LINEAS + 2,1 SAY 'Total de Vales ................' + STR(TOTAL,13,2)
            DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
            ESPERAR(0)
            @ 24,0 SAY SPACE(79)
     ENDIF
     @ 24,0 SAY SPACE(79)
ENDDO
CLOSE ALL
RETURN



PROCEDURE DEP_VALES
********* *********
*Borra Archivo de Vales

SELE 21
USE VALES

SELE 9
USE VENDEDOR INDEX VENDEDOR

DO WHILE .T.
     CLEAR
     DO TITULO
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     @ 1,0 TO 23,79 DOUBLE
     SET COLOR TO I
     @ 3,30 SAY '* DEPURACION DEL ARCHIVO DE VALES *'
     SET COLOR TO
     @ 5,2 TO 5,78
     DO WHILE .T.
        SELE 9
        M_EMPL = SPACE(10)
        @ 10,3 SAY 'N£mero de Empleado : ' GET M_EMPL PICT '@!'
        READ
        IF LASTKEY() = 27
              EXIT
        ENDIF
        SEEK M_EMPL
        IF FOUND()
              SET COLOR TO I
              @ 10,30 SAY NOMBRE
              SET COLOR TO
              EXIT
        ELSE
              DO M_CARTEL WITH 19,24,0,.T.,.T.,.T.
              ESPERAR(0)
              @ 24,0 SAY SPACE(79)
        ENDIF
     ENDDO
     IF LASTKEY() = 27
           EXIT
     ENDIF
     IF APRUEBA(24,0,2)
            SELE 21
            GO TOP
            DO WHILE !EOF()
                   IF M_EMPL = EMPL
                         DELETE
                   ENDIF
                   SKIP
            ENDDO
            PACK
     ENDIF
     @ 24,0 SAY SPACE(79)
ENDDO
CLOSE ALL
RETURN
