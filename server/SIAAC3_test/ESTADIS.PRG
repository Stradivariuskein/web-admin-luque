*******************************************************************************
*Fuente : ESTADIS.PRG                                                         *
*                                                                             *
*******************************************************************************
SET SOFTSEEK ON
DO WHILE .T.
   DECLARE MENPEE[1]
   DECLARE OPPEE[1]
   OPPEE[1]='VENTA DE ARTICULOS por FECHA DETALLADA por CLIENTE'

   MENPEE[1]='             Venta de Art. Acumulada por fechas Detallada'


   *    Displaya opciones y captura.
   OPPE=OPCIONES('SISTEMA DE VENTAS - ESTADISTICAS',OPPEE,MENPEE)
   *    Fin
   IF LASTKEY()=27
      EXIT
   ENDIF
   DO CASE
   CASE OPPE = 1
      DO ACUM_VTA
   ENDCASE
ENDDO
SET SOFTSEEK OFF
RETURN


PROCEDURE ACUM_VTA
******************
*Acumulado de ventas de articulos por fechas.

SELE 1
USE DETALLE1

SELE 2
USE ARTIC
SET INDEX TO ARTIC

SELE 3
USE COMPRO1
SET INDEX TO COMPRO1

SELE 11
USE CLIENTES
SET INDEX TO CLIENTES
DO WHILE .T.
      CLEAR
      DO TITULO
      DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
      SET COLOR TO I
      @ 3,30 SAY 'ACUMULADOS DE VENTA DE ARTICULOS'
      SET COLOR TO
      @ 5,1 TO 5,78
      STOR M_FECHA TO M_DESDE,M_HASTA
      STOR SPACE(11) TO M_ARTI1
      M_DESDEC = SPACE(10)
      M_HASTAC = SPACE(10)
      M_VENDEDOR = SPACE(10)
      SELE 2
      @ 6,3 SAY  'Desde Fecha        : ' GET M_DESDE PICT '99/99/99'
      @ 7,3 SAY  'Hasta Fecha        : ' GET M_HASTA PICT '99/99/99'
      @ 8,3 SAY  'Art.(ENTER=todos)  : ' get m_arti1 PICT '@!' VALID VALARTI(8,40,M_ARTI1)
      @ 9,3 SAY  'Cliente ENTER=TODOS: ' GET M_DESDEC PICT '@!'
      @ 10,3 SAY 'Zona ENTER=TODOS   : ' GET M_VENDEDOR PICT '@!'
      READ
      IF LASTKEY() = 27
           EXIT
      ENDIF
      IF APRUEBA(24,0,2)
              IMPRE = .F.
              IF APRUEBA(24,0,11)
                     IMPRE = .T.
                     DO M_CARTEL WITH 10,24,0,.T.,.F.,.T.
                     ESPERAR(0)
                     IF LASTKEY() = 27
                          LOOP
                     ENDIF
              ENDIF
              DO M_CARTEL WITH 44,24,0,.T.,.F.,.T.
              IF IMPRE
                   SET PRINT ON
                   SET PRINT TO &E_LISTADOS
                   IF ERROR_PRINT()
                        LOOP
                   ENDIF
                   SET DEVI TO PRINT
                   @ PROW(),PCOL() SAY CHR(27) + CHR(120) + '0'
                   @ PROW(),PCOL() SAY CHR(18)
              ELSE
                   SET PRINT TO ESTADIS.TXT
                   SET PRINT ON
                   SET DEVI TO PRINT
              ENDIF
              SELE 4
              USE AUXIACUM
              ZAP
              USE
              SELE 4
              USE AUXIACUM
              INDEX ON CLIENTE + ARTICULO TO AUXIACUM
              INDEX ON DESCEND(PESOS) TO AUXIAC2
              SET INDEX TO AUXIACUM,AUXIAC2
              SET ORDER TO 1
              SELE 1
              INDEX ON FECHA TO AUXLIAR
              SET ORDER TO 1
              M_AUX = M_DESDE
              M_VECES = 1
              SEEK M_AUX
              M_TOTAL = 0
              M_CANT = 0
              I = 1
              DO WHILE !EOF() .AND. FECHA <= M_HASTA
                           SELE 3
                           SEEK DETALLE1->TIPO + STR(DETALLE1->NUMERO,5,0)
                           SELE 11
                           SEEK COMPRO1->CLIENTE
                           IF !EMPTY(ALLTRIM(M_VENDEDOR))
                                IF CAJERO <> M_VENDEDOR
                                      SELE 1
                                      SKIP
                                      LOOP
                                ENDIF
                           ENDIF
                           SELE 1
                           IF !EMPTY(ALLTRIM(M_DESDEC))
                                IF COMPRO1->CLIENTE <> M_DESDEC
                                      SELE 1
                                      SKIP
                                      LOOP
                                ENDIF
                           ENDIF
                           SELE 1
                           IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA .AND. !COMPRO1->ANULADA
                                IF TIPO = 'FAC' .OR. TIPO = 'CDO'
                                     IF !EMPTY(ALLTRIM(M_ARTI1))
                                             M_BIEN = .F.
                                             FOR TT = 1 TO 1
                                                  M_VARI = 'M_ARTI' + ALLTRIM(STR(TT,2,0))
                                                  IF DETALLE1->ARTICULO = &M_VARI
                                                        M_BIEN = .T.
                                                  ENDIF
                                             NEXT
                                             IF !M_BIEN
                                                   SELE 1
                                                   SKIP
                                                   LOOP
                                             ENDIF
                                     ENDIF
                                     SELE 4
                                     SEEK COMPRO1->CLIENTE + DETALLE1->ARTICULO
                                     IF !FOUND()
                                           APPE BLANK
                                     ENDIF
                                     REPLACE ARTICULO WITH DETALLE1->ARTICULO
                                     REPLACE CLIENTE WITH COMPRO1->CLIENTE
                                     REPLACE CANTIDAD WITH DETALLE1->CANTIDAD + CANTIDAD
                                     REPLACE PESOS WITH PESOS + (DETALLE1->PRECIO * DETALLE1->CANTIDAD)
                                ELSEIF TIPO = 'NCR'
                                     IF !EMPTY(ALLTRIM(M_ARTI1))
                                             M_BIEN = .F.
                                             FOR TT = 1 TO 1
                                                  M_VARI = 'M_ARTI' + ALLTRIM(STR(TT,2,0))
                                                  IF DETALLE1->ARTICULO = &M_VARI
                                                        M_BIEN = .T.
                                                  ENDIF
                                             NEXT
                                             IF !M_BIEN
                                                   SELE 1
                                                   SKIP
                                                   LOOP
                                             ENDIF
                                     ENDIF
                                     SELE 4
                                     SEEK COMPRO1->CLIENTE + DETALLE1->ARTICULO
                                     IF !FOUND()
                                            APPE BLANK
                                     ENDIF
                                     REPLACE ARTICULO WITH DETALLE1->ARTICULO
                                     REPLACE CLIENTE WITH COMPRO1->CLIENTE
                                     REPLACE CANTIDAD WITH CANTIDAD - DETALLE1->CANTIDAD
                                     REPLACE PESOS WITH PESOS - (DETALLE1->PRECIO * DETALLE1->CANTIDAD)
                                ENDIF
                           ENDIF
                           SELE 1
                           SKIP
              ENDDO
              LINEAS = 66
              PRIMERA = .T.
              HOJA = 1
              SELE 4
              SET ORDER TO 2
              GO TOP
              DO WHILE !EOF()
                               IF LINEAS > 62
                                      DO ENC_ACUM
                               ENDIF
                               SELE 11
                               SEEK AUXIACUM->CLIENTE
                               SELE 2
                               SEEK AUXIACUM->ARTICULO
                               SELE 4
                               @ LINEAS,0 SAY SUBSTR(CLIENTES->NOMBRE,1,20) + ' ' + SUBSTR(ARTIC->COD_ART,1,11) + ' ' + SUBSTR(ARTIC->DESCR,1,19) + ' ' + STR(AUXIACUM->CANTIDAD,6,0) + ' ' + ;
                               TRANSFORM(AUXIACUM->PESOS,'###,###.##')
                               LINEAS = LINEAS + 1
                               SKIP
              ENDDO
              IF IMPRE
                   EJECT
                   SET DEVI TO SCREEN
                   SET PRINT OFF
              ELSE
                   SET PRINT TO
                   SET PRINT OFF
                   SET DEVI TO SCREEN
                   RUN LIST ESTADIS.TXT
              ENDIF
      ENDIF
ENDDO
CLOSE ALL
RETURN



PROCEDURE ENC_ACUM
******************
IF PRIMERA
      IF !IMPRE
           CLEAR
      ENDIF
      PRIMERA = .F.
ELSE
      IF IMPRE
          EJECT
      ENDIF
ENDIF

LINEAS = 1
@ LINEAS,20 SAY 'LISTADO DE ACUMULADO DE VENTAS DE ARTICULOS'
@ LINEAS + 2,1 SAY 'Desde Fecha : ' + DTOC(M_DESDE) + ' Hasta Fecha : ' + DTOC(M_HASTA)
@ LINEAS + 3,60 SAY 'Hoja : ' + STR(HOJA,3,0)
@ LINEAS + 5,1 SAY 'CLIENTE : ' + M_DESDEC
@ LINEAS + 6,0 SAY REPLICATE('=',80)
@ LINEAS + 7,0 SAY 'CLIENTE             COD.ART.       DESCRIPCION        CANTIDAD   TOTAL'
@ LINEAS + 8,0 SAY REPLICATE('=',80)
LINEAS = 10
HOJA = HOJA + 1
RETURN
