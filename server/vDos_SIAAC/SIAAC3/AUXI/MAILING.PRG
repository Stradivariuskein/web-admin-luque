DO WHILE .T.
     CLEAR
     DO TITULO
     SET COLOR TO I
     DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
     SET COLOR TO
     @ 1,0 TO 23,79 DOUBLE
     SET COLOR TO I
     @ 3,25 SAY 'SISTEMA de MAILING de CLIENTES'
     SET COLOR TO
     @ 5,1 TO 5,78
     STOR SPACE(10) TO M_DESDEN,M_HASTAN,M_DESDEV,M_HASTAV
     M_DESDEL = 'A'
     M_HASTAL = 'Z'
     M_ORDEN = 'V'
     M_DESDEZ = '0   '
     M_HASTAZ = '9999'
     @ 8,3 SAY  'Desde Cliente Nro: ' GET M_DESDEN PICT '@!'
     @ 10,3 SAY 'Hasta Cliente Nro: ' GET M_HASTAN PICT '@!'
     @ 12,3 SAY 'Desde La Letra   : ' GET M_DESDEL PICT 'A'
     @ 14,3 SAY 'Hasta La Letra   : ' GET M_HASTAL PICT 'A'
     @ 16,3 SAY 'Desde Vendedor   : ' GET M_DESDEV PICT '@!'
     @ 18,3 SAY 'Hasta Vendedor   : ' GET M_HASTAV PICT '@!'
     @ 20,3 SAY 'Ordenado por (V)endedor, (A)lfabetico o (N)umerico : ' GET M_ORDEN PICT 'A' VALID M_ORDEN = 'V' .OR. M_ORDEN = 'A' .OR. M_ORDEN = 'N'
     @ 22,3 SAY 'Desde Zona: ' GET M_DESDEZ PICT '@!'
     @ 22,45 SAY 'Hasta Zona : ' GET M_HASTAZ PICT '@!'
     READ
     IF LASTKEY() = 27
          EXIT
     ENDIF
     SET COLOR TO I
     @ 24,1 SAY 'POSICIONE EL PAPEL EN LA IMPRESORA, PULSE UNA TECLA PARA SEGUIR. <ESC> CANCELA'
     SET COLOR TO
     ESPERAR(0)
     IF LASTKEY() = 27
          LOOP
     ENDIF
     SELE 1
     IF M_ORDEN = 'V'
          USE CLIENTES
          INDEX ON COD_VEND TO AUXILI0
          SEEK M_DESDEV
     ELSE
          IF M_ORDEN = 'A'
             USE CLIENTES
             INDEX ON NOMBRE TO AUXILI0
             SEEK M_DESDEL
          ELSE
             USE CLIENTES INDEX CLIENTES
             SEEK M_DESDEN
          ENDIF
     ENDIF
     SET DEVICE TO PRINT
     @ PROW(),PCOL() SAY CHR(27) + CHR(48)
     @ PROW(),PCOL() SAY SPACE(1)
     LINEAS = 0
     I = 0
     P = 1
     HACE = .F.
     NOMBRE1 = ''
     DIREC1 = ''
     LOC1 = ''
     CP1 = 0
     AT1=''
     NOMBRE2 = ''
     DIREC2 = ''
     LOC2 = ''
     CP2 = 0
     AT2=''
     DO WHILE !EOF()
        DO WHILE !EOF() .AND. .T.
            IF COD_CLI < M_DESDEN .OR. COD_CLI > M_HASTAN
                    SKIP
                    LOOP
            ENDIF
            IF SUBSTR(NOMBRE,1,1) < M_DESDEL .OR. SUBSTR(NOMBRE,1,1) > M_HASTAL
                    SKIP
                    LOOP
            ENDIF
            IF COD_VEND < M_DESDEV .OR. COD_VEND > M_HASTAV
                    SKIP
                    LOOP
            ENDIF
            IF VAL(LOC) < VAL(M_DESDEZ) .OR. VAL(LOC) > VAL(M_HASTAZ)
                    SKIP
                    LOOP
            ENDIF
            HACE = .T.
            IF P = 1
               NOMBRE1 = NOMBRE
               DIREC1 = DIRECC
               LOC1 = LOC
               CP1 = CP
               AT1 = AT
               SKIP
               P = P + 1
            ELSE
               NOMBRE2 = NOMBRE
               DIREC2 = DIRECC
               LOC2 = LOC
               CP2 = CP
               AT2=AT
               SKIP
               P = 1
               EXIT
            ENDIF
          ENDDO
          IF HACE
              @ LINEAS, 2 SAY CHR(27) + CHR(71) + SUBSTR(NOMBRE1,1,26)
              @ LINEAS ,43 SAY SUBSTR(NOMBRE2,1,26) + CHR(27) + CHR(72)
              @ LINEAS + 1,2 SAY DIREC1
              @ LINEAS + 1,41 SAY DIREC2
              @ LINEAS + 2,2 SAY STR(CP1,4,0) + ' ' + LOC1
              @ LINEAS + 2,41 SAY STR(CP2,4,0) + ' ' + LOC2
              @ LINEAS + 3,2 SAY 'At.' + SUBSTR(AT1,1,20)
              @ LINEAS + 3,41 SAY 'At.' + SUBSTR(AT2,1,20)
              @ LINEAS + 4,2 SAY '  ' + SUBSTR(AT1,21,20)
              @ LINEAS + 4,41 SAY '  ' + SUBSTR(AT2,21,20)
              @ LINEAS + 5,2 SAY REPLICATE('=',26)
              @ LINEAS + 5,41 SAY REPLICATE('=',26)
              @ LINEAS + 6,2 SAY CHR(15)+ 'Rtte: Hugo M. Otero. Calle 50 1541 (1650) S.Martin' + CHR(18)
              @ LINEAS + 6,41 SAY CHR(15)+ 'Rtte: Hugo M. Otero. Calle 50 1541 (1650) S.Martin' + CHR(18)
              @ LINEAS + 8,0 SAY SPACE(1)
              LINEAS = LINEAS + 12
              I = I + 2
              IF I > 15
                  EJECT
                  LINEAS = 0
                  I = 0
              ENDIF
              HACE = .F.
          ENDIF
     ENDDO
     @ PROW(),PCOL() SAY CHR(27) + CHR(50)
     EJECT
     SET DEVICE TO SCREEN
ENDDO
CLEAR
CLOSE ALL
RETURN
