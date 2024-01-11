*ABM de PEDIDOS
PARAMETERS M_CUAL

IF M_CUAL = 'C'
  SELE 1
  USE ARTIC INDEX ARTIC,AR2

  SELE 11
  USE CLIENTES INDEX CLIENTES

  SELE 3
  USE PEDIDOS INDEX PEDIDOS

  SELE 4
  USE PEDIDOS2 INDEX PEDIDOS2
ELSE
  SELE 1
  USE MPRIMA INDEX MPRIMA

  SELE 12
  USE PROVEDOR INDEX PROVEDOR

  SELE 3
  USE PEDPROV INDEX PEDPROV

  SELE 4
  USE PEDPROV2 INDEX PEDPROV2

  SELE 5
  USE ARTIC INDEX ARTIC
ENDIF

V_ARTI = ARRAY(35)
V_CANTIDAD = ARRAY(35)
V_PRECIO = ARRAY(35)
V_DESCR = ARRAY(35)
V_MP = ARRAY(35)
V_DESCU = ARRAY(35)

PRIVATE M_ITEM,M_CANCELA,M_TOTAL

DO WHILE .T.
   CLEAR
   DO TITULO
   @ 1,0 TO 23,79 DOUBLE
   DO M_CARTEL WITH 1,24,0,.T.,.F.,.T.
   SET COLOR TO W+
   IF M_CUAL = 'C'
       @ 1,30 SAY 'ABM de PEDIDOS de CLIENTES'
   ELSE
       @ 1,30 SAY 'ABM de PEDIDOS a PROVEEDORES'
   ENDIF
   SET COLOR TO
   SELE 3
   GO BOTTOM
   M_NUMERO = NUMERO + 1
   @ 2,1 SAY 'Pedido Numero : ' GET M_NUMERO PICT '#####'
   READ
   IF LASTKEY() = 27
        EXIT
   ENDIF
   SEEK M_NUMERO
   IF !FOUND()
        M_FE = M_FECHA
        @ 2,35 SAY 'Fecha : ' GET M_FE PICT '99/99/99' VALID VALFECH(M_FE)
        READ
        IF LASTKEY() = 27
             LOOP
        ENDIF
        IF M_CUAL = 'C'
             M_CLI = SPACE(10)
             @ 3,1 SAY 'Cliente       : ' GET M_CLI PICT '@!' VALID VALCLI(3,35,M_CLI)
             READ
             IF LASTKEY() = 27
                  LOOP
             ENDIF
        ELSE
             M_PROV = SPACE(10)
             @ 3,1 SAY 'Proveedor     : ' GET M_PROV PICT '@!' VALID VALPROV(3,35,M_PROV)
             READ
             IF LASTKEY() = 27
                  LOOP
             ENDIF
        ENDIF
        DO BLAN_PED WITH .T.
        DO CARGA_PED WITH .T.,1
        IF LASTKEY() = 27
             LOOP
        ENDIF
        IF !M_CANCELA
           DO TOT_PEDI
           IF APRUEBA(24,0,2)
               DO GRAB_PED WITH .T.
               IF APRUEBA(24,0,49)
                   DO IMP_PEDI
               ENDIF
           ENDIF
        ENDIF
   ELSE
        DO M_CARTEL WITH 35,24,0,.T.,.F.,.T.
        M_LETRA = 'M'
        @ 24,70 GET M_LETRA PICT 'A' VALID M_LETRA = 'M' .OR. M_LETRA = 'B'
        READ
        IF M_LETRA = 'B'
            IF APRUEBA(24,0,3)
                SELE 3
                DELETE
                PACK
            ENDIF
            LOOP
        ENDIF
        SELE 3
        M_FE = FECHA
        @ 2,35 SAY 'Fecha : ' GET M_FE PICT '99/99/99' VALID VALFECH(M_FE)
        READ
        IF LASTKEY() = 27
             LOOP
        ENDIF
        IF M_CUAL = 'C'
             M_CLI = CLIENTE
             @ 3,1 SAY 'Cliente       : ' GET M_CLI PICT '@!' VALID VALCLI(3,35,M_CLI)
             READ
             IF LASTKEY() = 27
                  LOOP
             ENDIF
        ELSE
             M_PROV = PROVEDOR
             @ 3,1 SAY 'Proveedor     : ' GET M_PROV PICT '@!' VALID VALPROV(3,35,M_PROV)
             READ
             IF LASTKEY() = 27
                  LOOP
             ENDIF
        ENDIF
        DO BLAN_PED WITH .F.
        DO MUES_PEDI
        DO CARGA_PED WITH .F.,M_ITEM
        IF LASTKEY() = 27
             LOOP
        ENDIF
        IF !M_CANCELA
            DO TOT_PEDI
            IF APRUEBA(24,0,2)
                DO GRAB_PED WITH .F.
                IF APRUEBA(24,0,49)
                      DO IMP_PEDI
                ENDIF
            ENDIF
        ENDIF
   ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE BLAN_PED
******************
PARAMETERS M_ALTA

IF M_ALTA
    FOR I = 1 TO 35
        V_ARTI[I] = SPACE(10)
        V_CANTIDAD[I] = 0
        V_PRECIO[I] = 0
        V_DESCR[I] = SPACE(30)
        V_DESCU[I] = 0
        IF M_CUAL = 'C'
           V_MP[I] = 'N'
        ELSE
           V_MP[I] = 'S'
        ENDIF
    NEXT
ELSE
    FOR I = 1 TO 35
        V_ARTI[I] = SPACE(10)
        V_CANTIDAD[I] = 0
        V_PRECIO[I] = 0
        V_DESCR[I] = SPACE(40)
        V_DESCU[I] = 0
        IF M_CUAL = 'C'
           V_MP[I] = 'N'
        ELSE
           V_MP[I] = 'S'
        ENDIF
    NEXT
    SELE 4
    SEEK STR(M_NUMERO,5,0)
    I = 1
    M_ITEM = 1
    DO WHILE !EOF() .AND. NUMERO = M_NUMERO
         V_ARTI[I] = ARTICULO
         V_CANTIDAD[I] = CANTIDAD - ENTREGADO
         V_PRECIO[I] = PRECIO
         V_DESCR[I] = DESCR
         IF M_CUAL = 'C'
             V_DESCU[I] = DESCU
             V_MP[I] = 'N'
         ELSE
             V_MP[I] = MP
         ENDIF
         SKIP
         M_ITEM = M_ITEM + 1
         I = I + 1
    ENDDO
ENDIF
RETURN


PROCEDURE CARGA_PED
*******************
PARAMETERS M_ALTA,M_IT

@ 24,0 SAY SPACE(79)
@ 4,1 TO 4,78
IF M_CUAL = 'C'
    @ 5,1 SAY 'ITEM              ARTICULO                         CANTIDAD       PRECIO DTO'
ELSE
    @ 5,1 SAY 'ITEM              ARTICULO                         CANTIDAD       PRECIO'
ENDIF
@ 6,1 TO 6,78
M_CANCELA = .F.
DO WHILE .T.
     SELE 1
     @ 19,0 CLEAR TO 23,79
     @ 19,0 TO 23,79
     M_AU = M_IT
     @ 20,1 SAY 'Item (-1=FIN) : ' GET M_IT PICT '##' VALID VALITEM() .AND. M_IT <= 35
     READ
     IF LASTKEY() = 27
          IF APRUEBA(24,0,96)
               M_CANCELA = .T.
               @ 24,0 SAY SPACE(79)
               EXIT
          ELSE
               @ 24,0 SAY SPACE(79)
               LOOP
          ENDIF
     ENDIF
     IF M_IT > 35
          M_IT = -1
     ENDIF
     IF M_IT = -1
          EXIT
     ENDIF
     IF M_IT < M_AU
         M_HACE = 'M'
         @ 24,0 SAY '(A)nula Item o (M)odifica : ' GET M_HACE PICT 'A' VALID M_HACE = 'A' .OR. M_HACE = 'M'
         READ
         @ 24,0 SAY SPACE(79)
         IF LASTKEY() = 27
              @ 24,0 SAY SPACE(79)
              LOOP
         ELSE
              IF M_HACE = 'A'
                   V_ARTI[M_IT] = SPACE(10)
                   V_PRECIO[M_IT] = 0
                   V_CANTIDAD[M_IT] = 0
                   V_DESCR[M_IT] = SPACE(30)
                   V_MP[M_IT] = 'N'
                   DO ANULA_ITPE WITH M_IT
                   DO MUES_PEDI
                   M_IT = M_AU - 1
                   LOOP
              ENDIF
         ENDIF
     ENDIF
     IF M_CUAL = 'C'
          @ 20,22 SAY 'Art. : ' GET V_ARTI[M_IT] PICT '@!' VALID VALAR2(22,1,V_ARTI[M_IT])
     ELSE
          @ 20,22 SAY 'M.Prima S/N: ' GET V_MP[M_IT] PICT 'A' VALID V_MP[M_IT] = 'S' .OR. V_MP[M_IT] = 'N'
          READ
          IF LASTKEY() = 27
              LOOP
          ENDIF
          IF V_MP[M_IT] = 'N'
                SELE 5
          ELSE
                SELE 1
          ENDIF
          @ 20,38 SAY 'Art. : ' GET V_ARTI[M_IT] PICT '@!' VALID VALAR2(22,1,V_ARTI[M_IT])
     ENDIF
     READ
     IF LASTKEY() = 27
          LOOP
     ENDIF
     IF M_CUAL = 'C'
        M_LIS = 'LISTA' + STR(CLIENTES->QLIST,1,0)
        V_PRECIO[M_IT] = &M_LIS
        V_DESCR[M_IT] = ARTIC->DESCR
     ELSE
        IF V_MP[M_IT] = 'N'
            V_PRECIO[M_IT] = COSTO
        ENDIF
        V_DESCR[M_IT] = DESCR
     ENDIF
     @ 21,1 GET V_DESCR[M_IT] PICT '@!'
     @ 20,56 SAY 'Cantidad : ' GET V_CANTIDAD[M_IT] PICT '#####.###'
     @ 21,56 SAY 'Precio: ' GET V_PRECIO[M_IT] PICT '#######.####'
     IF M_CUAL = 'C'
         @ 22,56 SAY 'Dto   : ' GET V_DESCU[M_IT] PICT '###.##'
     ENDIF
     READ
     IF APRUEBA(24,0,2)
          @ 24,0 SAY SPACE(79)
          DO MUES_PEDI
          IF M_IT = M_AU
             M_IT = M_IT + 1
          ELSE
             M_IT = M_AU
          ENDIF
          IF M_IT = 36
             M_IT = -1
             EXIT
          ENDIF
     ELSE
          @ 24,0 SAY SPACE(79)
     ENDIF
ENDDO
RETURN

PROCEDURE MUES_PEDI
*******************
SELE 1
M_FILA = 7
@ 7,1 CLEAR TO 19,78
FOR I = 1 TO 35
     IF !EMPTY(ALLTRIM(V_ARTI[I]))
           IF V_MP[I] = 'N'
               SELE 5
           ELSE
               SELE 1
           ENDIF
           SEEK V_ARTI[I]
           IF M_CUAL = 'C'
              @ M_FILA,1 SAY STR(I,2,0) + '  ' + SUBSTR(V_DESCR[I],1,43) + '   ' + TRANSFORM(V_CANTIDAD[I],'#####.###') + ' ' + TRANSFORM(V_PRECIO[I],'###,###.####') + ' ' + IIF(V_DESCU[I] <> 0,STR(V_DESCU[I],5,2),'')
           ELSE
              @ M_FILA,1 SAY STR(I,2,0) + '  ' + SUBSTR(V_DESCR[I],1,30) + SPACE(13) + '   ' + TRANSFORM(V_CANTIDAD[I],'#####.###') + ' ' + TRANSFORM(V_PRECIO[I],'###,###.####')
           ENDIF
           M_FILA = M_FILA + 1
           IF M_FILA = 19
                DO M_CARTEL WITH 20,24,0,.T.,.F.,.T.
                ESPERAR(0)
                M_FILA = 7
                @ 7,1 CLEAR TO 19,78
           ENDIF
     ENDIF
NEXT
RETURN


PROCEDURE ANULA_ITPE
********************
PARAMETERS M_I

J = 1
M = 1
DO WHILE .T.
   IF J > 35
      EXIT
   ENDIF
   IF J <> M_I
      V_ARTI[M] = V_ARTI[J]
      V_CANTIDAD[M] =V_CANTIDAD[J]
      V_PRECIO[M]=V_PRECIO[J]
      V_DESCR[M]=V_DESCR[J]
      V_MP[M] = V_MP[J]
      M = M + 1
      J = J + 1
   ELSE
      V_ARTI[J] = SPACE(10)
      J = J + 1
   ENDIF
ENDDO
RETURN

FUNCTION VALITEM
*****************

IF M_IT >= 1 .AND. M_IT <= M_AU
    RETURN(.T.)
ELSE
    IF M_IT = -1
        RETURN(.T.)
    ELSE
        RETURN(.F.)
    ENDIF
ENDIF


PROCEDURE GRAB_PED
******************
PARAMETERS M_ALTA

SELE 3
IF M_ALTA
   APPEND BLANK
ENDIF
REPLACE NUMERO WITH M_NUMERO
IF M_CUAL = 'C'
   REPLACE CLIENTE WITH M_CLI
ELSE
   REPLACE PROVEDOR WITH M_PROV
ENDIF
REPLACE FECHA WITH M_FE
SELE 4
IF !M_ALTA
     SEEK STR(M_NUMERO,5,0)
     DO WHILE !EOF() .AND. NUMERO = M_NUMERO
            DELETE
            SKIP
     ENDDO
     PACK
ENDIF
FOR I = 1 TO 35
    IF !EMPTY(ALLTRIM(V_ARTI[I]))
            SEEK STR(M_NUMERO,5,0) + STR(I,2,0)
            IF !FOUND()
                 APPE BLANK
            ENDIF
            REPLACE NUMERO WITH M_NUMERO
            REPLACE ITEM WITH I
            REPLACE ARTICULO WITH V_ARTI[I]
            REPLACE CANTIDAD WITH V_CANTIDAD[I]
            REPLACE PRECIO WITH V_PRECIO[I]
            REPLACE DESCR WITH V_DESCR[I]
            IF M_CUAL <> 'C'
               REPLACE MP WITH V_MP[I]
            ELSE
               REPLACE DESCU WITH V_DESCU[I]
            ENDIF
    ENDIF
NEXT
RETURN



PROCEDURE LIS_PEDI
******************
PARAMETERS M_CUAL

M_DESEO = 'P'
@ 23,0 SAY 'Desea listar (T)odos los pedidos o los (P)endientes solamente : ' GET M_DESEO PICT 'A' VALID M_DESEO = 'T' .OR. M_DESEO = 'P'
READ
IMPRE = .F.
IF APRUEBA(24,0,11)
    IMPRE = .T.
ENDIF

DO M_CARTEL WITH 10,24,0,.T.,.T.,.T.
ESPERAR(0)
IF LASTKEY() = 27
   RETURN
ENDIF
IF IMPRE
   IF ERROR_PRINT()
      RETURN
   ENDIF
   SET DEVI TO PRINT
ENDIF

HOJA = 1
LINEAS = 70
PRIMERA = .T.

SELE 1
IF M_CUAL = 'C'
    USE PEDIDOS INDEX PEDIDOS
    SELE 11
    USE CLIENTES INDEX CLIENTES
ELSE
    USE PEDPROV INDEX PEDPROV
    SELE 11
    USE PROVEDOR INDEX PROVEDOR
ENDIF
SELE 1
GO TOP
DO WHILE !EOF()
     IF LINEAS > 65 .AND. IMPRE
          DO ENC_PEDI
     ENDIF
     IF LINEAS > 20 .AND. !IMPRE
          DO ENC_PEDI
          IF LASTKEY() = 27
              GO BOTTOM
              SKIP
              LOOP
          ENDIF
      ENDIF
      IF M_DESEO = 'P'
            IF PENDIENTE
                SKIP
                LOOP
            ENDIF
      ENDIF
      IF M_CUAL = 'C'
           SELE 11
           SEEK PEDIDOS->CLIENTE
      ELSE
           SELE 11
           SEEK PEDPROV->PROVEDOR
      ENDIF
      SELE 1
      IF M_CUAL = 'C'
         @ LINEAS,1 SAY STR(NUMERO,5,0) + ' ' + DTOC(FECHA) + ' ' + CLIENTES->NOMBRE
      ELSE
         @ LINEAS,1 SAY STR(NUMERO,5,0) + ' ' + DTOC(FECHA) + ' ' + PROVEDOR->NOMBRE
      ENDIF
      LINEAS = LINEAS + 1
      SKIP
ENDDO
IF IMPRE
   EJECT
   SET DEVI TO SCREEN
ELSE
   DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
   ESPERAR(0)
ENDIF
CLOSE ALL
RETURN


PROCEDURE ENC_PEDI
******************

IF PRIMERA
    IF !IMPRE
        CLEAR
    ENDIF
    PRIMERA = .F.
ELSE
    IF IMPRE
        EJECT
    ELSE
        DO M_CARTEL WITH 20,24,0,.T.,.T.,.T.
        ESPERAR(0)
        CLEAR
    ENDIF
ENDIF
LINEAS = 1
IF M_CUAL = 'C'
   @ LINEAS,30 SAY 'LISTADO DE PEDIDOS DE CLIENTES'
ELSE
   @ LINEAS,30 SAY 'LISTADO DE PEDIDOS A PROVEEDORES'
ENDIF
IF M_DESEO = 'P'
    @ LINEAS + 1,1 SAY 'PEDIDOS PENDIENTES DE ENTREGA'
ENDIF
@ LINEAS + 1,50 SAY 'Hoja : ' + STR(HOJA,3,0)
@ LINEAS + 2,1 SAY REPLICATE('=',79)
IF M_CUAL = 'C'
   @ LINEAS + 3,1 SAY 'PEDIDO  FECHA           CLIENTE'
ELSE
   @ LINEAS + 3,1 SAY 'PEDIDO  FECHA           PROVEEDOR'
ENDIF
@ LINEAS + 4,1 SAY REPLICATE('=',79)
LINEAS = 6
HOJA = HOJA + 1
RETURN


PROCEDURE BORRA_PEDI
********************

STOR M_FECHA-180 TO M_DESDE,M_HASTA
M_DESEO = 'C'
@ 21,0 to 23,79
@ 22,1 SAY 'Desea Borrar Pedidos de (C)lientes o de (P)roveedores : ' GET M_DESEO PICT 'A' VALID M_DESEO = 'C' .OR. M_DESEO = 'P'
@ 23,1 SAY 'Desde Fecha : ' GET M_DESDE PICT '99/99/99' VALID VALFECH(M_DESDE)
@ 23,50 SAY 'Hasta Fecha : ' GET M_HASTA PICT '99/99/99' VALID VALFECH(M_HASTA)
READ
IF LASTKEY() = 27
   RETURN
ENDIF


IF APRUEBA(24,0,3)
     IF M_DESEO = 'C'
         SELE 1
         USE PEDIDOS INDEX PEDIDOS
         SELE 2
         ARCHIVO = 'PEDIDOS2'
         USE PEDIDOS2 INDEX PEDIDOS2
     ELSE
         SELE 1
         USE PEDPROV INDEX PEDPROV
         SELE 2
         USE PEDPROV2 INDEX PEDPROV2
         ARCHIVO = 'PEDPROV2'
     ENDIF
     DO M_CARTEL WITH 100,24,0,.T.,.F.,.T.
     SELE 1
     DO WHILE !EOF()
            IF FECHA >= M_DESDE .AND. FECHA <= M_HASTA
                  SELE 2
                  SEEK STR(&ARCHIVO->NUMERO,5,0)
                  DO WHILE !EOF() .AND. NUMERO = &ARCHIVO->NUMERO
                         DELETE
                         SKIP
                  ENDDO
                  SELE 1
                  DELETE
            ENDIF
            SELE 1
            SKIP
     ENDDO
ENDIF
SELE 1
PACK
SELE 2
PACK
CLOSE ALL
RETURN

PROCEDURE TOT_PEDI
******************

M_TOTAL = 0
M_DESCU = 0
FOR I = 1 TO 35
    IF V_DESCU[I] <> 0
         M_DESCU = (V_PRECIO[I] * V_CANTIDAD[I]) * V_DESCU[I] / 100
    ELSE
         M_DESCU = 0
    ENDIF
    M_TOTAL = M_TOTAL  + (V_PRECIO[I] * V_CANTIDAD[I]) - M_DESCU
NEXT

@ 20,0 CLEAR TO 23,79
@ 20,0 TO 23,79
SET COLOR TO W+
@ 21,1 SAY 'Total del Pedido en Pesos : ' + TRANSFORM(M_TOTAL,'###,###.##')
SET COLOR TO
RETURN


PROCEDURE IMP_PEDI
******************

IF ERROR_PRINT()
     RETURN
ENDIF

SET DEVI TO PRINT

IF M_CUAL = 'C'
     @ 2,15 SAY CHR(14) + 'NOTA DE PEDIDO DE CLIENTES'
ELSE
     @ 2,15 SAY CHR(14) + 'NOTA DE PEDIDO DE PROVEEDORES'
ENDIF

@ 4,1 SAY 'Pedido Numero : ' + STR(M_NUMERO,5,0)
IF M_CUAL = 'C'
    @ 5,1 SAY 'Cliente       : ' + CLIENTES->NOMBRE
ELSE
    @ 5,1 SAY 'Proveedor     : ' + PROVEDOR->NOMBRE
ENDIF
@ 6,1 SAY 'Fecha Pedido  : ' + DTOC(M_FE)
@ 7,1 SAY REPLICATE('=',79)
IF M_CUAL = 'C'
    @ 8,1 SAY 'CODIGO                   DESCRIPCION       CANTIDAD    P.U.      TOTAL   %DESC'
ELSE
    @ 8,1 SAY 'CODIGO                   DESCRIPCION                             CANTIDAD'
ENDIF
@ 9,1 SAY REPLICATE('=',79)
LINEAS = 11
FOR I = 1 TO 35
        IF !EMPTY(ALLTRIM(V_ARTI[I]))
          IF M_CUAL = 'C'
            @ LINEAS,0 SAY V_ARTI[I] + ' ' + CHR(15) + SUBSTR(V_DESCR[I],1,55) + CHR(18) + ' ' + STR(V_CANTIDAD[I],5,0) +' ' + TRANSFORM(V_PRECIO[I],'###,###.##') + ' ' + TRANSFORM(V_PRECIO[I] * V_CANTIDAD[I],'###,###.##') + ' ' + STR(V_DESCU[I],5,2)
          ELSE
            @ LINEAS,0 SAY V_ARTI[I] + ' ' + SUBSTR(V_DESCR[I],1,55) + ' ' + STR(V_CANTIDAD[I],5,0)
          ENDIF
          LINEAS = LINEAS + 1
        ENDIF
NEXT
@ LINEAS + 3,1 SAY 'TOTAL : ' + TRANSFORM(M_TOTAL,'###,###.##')
EJECT
SET DEVI TO SCREEN
RETURN
