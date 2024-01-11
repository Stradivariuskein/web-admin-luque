*******************************************************************************
*Fuente : ABMCLAV.PRG  - SIAAC
*
*Funcion : Alta, Baja y Modificaciones de Claves de Seguridad
*
* Opcion 1 Menu de ABM.
*******************************************************************************
IF !SEGURIDAD(MM_CLAVE,'B')
        DO M_CARTEL WITH 4,24,0,.T.,.T.,.T.
        ESPERAR(0)
        RETURN
ENDIF

SELE 11
USE SEGURI INDEX SEGURI

PRIVATE M_CLAVE,M_HABILITA

DECLARE NIVELES[3]
NIVELES[1] = 'EMPLEADOS'
NIVELES[2] = 'ENCARGADOS'
NIVELES[3] = 'JEFE'


DECLARE PROCESOS[12]

DECLARE PROCESOS2[12]

DECLARE AUXILI[12]

DECLARE ACTIVO[12]

BAJA = .F.
DO WHILE .T.
     CLEAR
     DO TITULO
     @ 1,0 TO 23,79 DOUBLE
     SET COLOR TO I
     @ 3,20 SAY ' * ABM de CLAVES DE SEGURIDAD DEL SISTEMA * '
     SET COLOR TO
     @ 5,2 TO 5,78
     M_CLAVE = SPACE(10)
     @ 7,3 SAY 'Ingrese Clave : ' GET M_CLAVE PICT '@!'
     READ
     IF LASTKEY() = 27
         EXIT
     ENDIF
     SEEK M_CLAVE
     IF !FOUND() .OR. DELETE()
          IF APRUEBA(24,0,7)
                @ 24,0 SAY SPACE(79)
                @ 10,3 SAY 'Su Clave Habilita Los Siguientes Procesos: '
                SAVE SCREEN TO M_PANTA
                CLEAR
                DO INI_VECTOR
                PRIMER = .T.
                DO WHILE .T.
                   IF PRIMER
                        L = 1
                        PRIMER = .F.
                   ENDIF
                   L = VENTOPCION('PROCESOS PARA HABILITAR AL USUARIO',AUXILI,4,20,20,.T.,.T.,L)
                   IF LASTKEY() = 27
                       EXIT
                   ENDIF
                   IF LASTKEY() = 13
                        IF ACTIVO[L]
                            ACTIVO[L] = .F.
                            AUXILI[L] = PROCESOS[L]
                        ELSE
                            ACTIVO[L] = .T.
                            AUXILI[L] = PROCESOS2[L]
                        ENDIF
                   ENDIF
                ENDDO
                DO ASIGNA_HABI
                RESTORE SCREEN FROM M_PANTA
                @ 10,3 SAY 'Su Clave Habilita Los Siguientes Procesos: '
                @ 12,3 SAY M_HABILITA
                @ 14,3 SAY 'Nivel de Jerarquia : '
                SAVE SCREEN TO M_PANTA
                I = VENTOPCION('NIVELES DE JERARQUIA',NIVELES,17,30,21,.T.,.F.,1)
                IF LASTKEY() = 27
                     LOOP
                ENDIF
                RESTORE SCREEN FROM M_PANTA
                @ 14,25 SAY NIVELES[I]
                M_NIVEL = I
                IF APRUEBA(24,0,2)
                     APPEND BLANK
                     REPLACE NIVEL WITH M_NIVEL
                     REPLACE CLAVE WITH M_CLAVE
                     REPLACE HABILITA WITH M_HABILITA
                ENDIF
          ENDIF
      ELSE
          DO M_CARTEL WITH 5,7,40,.T.,.F.,.T.
          M_CLAVE = CLAVE
          @ 7,20 GET M_CLAVE PICT '@!'
          READ
          IF LASTKEY() = 27
                 EXIT
          ENDIF
          IF TRIM(M_CLAVE) = 'LIBRE'
                 IF APRUEBA(24,0,6)
                       DELETE
                       BAJA = .T.
                 ENDIF
                 LOOP
          ENDIF
          @ 10,3 SAY 'Su Clave Habilita Los Siguientes Procesos: '
          SAVE SCREEN TO M_PANTA
          DO INI_VECTOR
          DO CARGA_HABI
          PRIMER = .T.
          CLEAR
          DO WHILE .T.
             IF PRIMER
                  L = 1
                  PRIMER = .F.
             ENDIF
             L = VENTOPCION('PROCESOS PARA HABILITAR AL USUARIO',AUXILI,4,20,20,.T.,.T.,L)
             IF LASTKEY() = 27
                 EXIT
             ENDIF
             IF LASTKEY() = 13
                  IF ACTIVO[L]
                      ACTIVO[L] = .F.
                      AUXILI[L] = PROCESOS[L]
                  ELSE
                      ACTIVO[L] = .T.
                      AUXILI[L] = PROCESOS2[L]
                  ENDIF
             ENDIF
          ENDDO
          DO ASIGNA_HABI
          RESTORE SCREEN FROM M_PANTA
          @ 10,3 SAY 'Su Clave Habilita Los Siguientes Procesos: '
          @ 12,3 SAY M_HABILITA
          @ 14,3 SAY 'Nivel de Jerarquia : '
          SAVE SCREEN TO M_PANTA
          I = VENTOPCION('NIVELES DE JERARQUIA',NIVELES,17,30,21,.T.,.F.,NIVEL)
          IF LASTKEY() = 27
              LOOP
          ENDIF
          RESTORE SCREEN FROM M_PANTA
          M_NIVEL = I
          @ 14,25 SAY NIVELES[I]
          IF LASTKEY() = 27
               LOOP
          ENDIF
          IF APRUEBA(24,0,2)
               REPLACE NIVEL WITH M_NIVEL
               REPLACE CLAVE WITH M_CLAVE
               REPLACE HABILITA WITH M_HABILITA
          ENDIF
      ENDIF
ENDDO
IF BAJA
    PACK
ENDIF
CLOSE ALL
RETURN


PROCEDURE ASIGNA_HABI
*********************
M_HABILITA = ' '
FOR I = 1 TO 12
     IF ACTIVO[I]
          M_HABILITA = M_HABILITA + SUBSTR(PROCESOS[I],1,1)
     ENDIF
NEXT
RETURN

PROCEDURE CARGA_HABI
********************

DECLARE LETRAS[12]
LETRAS[1] = 'A'
LETRAS[2] = 'B'
LETRAS[3] = 'C'
LETRAS[4] = 'D'
LETRAS[5] = 'E'
LETRAS[6] = 'F'
LETRAS[7] = 'G'
LETRAS[8] = 'H'
LETRAS[9] = 'I'
LETRAS[10] = 'J'
LETRAS[11] = 'K'
LETRAS[12] = 'M'


FOR I = 4 TO 15
     IF AT(LETRAS[I-3],HABILITA) <> 0
           AUXILI[I-3] = PROCESOS2[I-3]
           ACTIVO[I-3] = .T.
     ENDIF
NEXT
RETURN



PROCEDURE INI_VECTOR
********************

PROCESOS[1] = 'A = ABM GENERAL (Menu)'
PROCESOS[2] = 'B = ABM de CLAVES del SISTEMA'
PROCESOS[3] = 'C = COMPRAS DE MERCADERIA'
PROCESOS[4] = 'D = FACTURACION'
PROCESOS[5] = 'E = STOCK'
PROCESOS[6] = 'F = MOVIMIENTOS DE CAJA'
PROCESOS[7] = 'G = PEDIDOS'
PROCESOS[8] = 'H = COPIA ARCHIVOS'
PROCESOS[9] = 'I = LISTADOS VARIOS'
PROCESOS[10] = 'J = CONSULTAS DE COMPROBANTES'
PROCESOS[11] = 'K = CTAS.CTES. DE CLIENTES'
PROCESOS[12] = 'M = LIQUIDACION DE COMISIONES A VENDEDORES'


PROCESOS2[1] = 'A = ABM GENERAL (Menu) û'
PROCESOS2[2] = 'B = ABM de CLAVES del SISTEMA û'
PROCESOS2[3] = 'C = COMPRAS DE MERCADERIA û'
PROCESOS2[4] = 'D = FACTURACION û'
PROCESOS2[5] = 'E = STOCK û'
PROCESOS2[6] = 'F = MOVIMIENTOS DE CAJA û'
PROCESOS2[7] = 'G = PEDIDOS û'
PROCESOS2[8] = 'H = COPIA ARCHIVOS û'
PROCESOS2[9] = 'I = LISTADOS VARIOS û'
PROCESOS2[10] = 'J = CONSULTAS DE COMPROBANTES û'
PROCESOS2[11] = 'K = CTAS.CTES. DE CLIENTES û'
PROCESOS2[12] = 'M = LIQUIDACION DE COMISIONES A VENDEDORES û'

AUXILI[1] =  'A = ABM GENERAL (Menu)'
AUXILI[2] =  'B = ABM de CLAVES del SISTEMA'
AUXILI[3] =  'C = COMPRAS DE MERCADERIA'
AUXILI[4] =  'D = FACTURACION'
AUXILI[5] =  'E = STOCK'
AUXILI[6] =  'F = MOVIMIENTOS DE CAJA'
AUXILI[7] =  'G = PEDIDOS'
AUXILI[8] =  'H = COPIA ARCHIVOS'
AUXILI[9] =  'I = LISTADOS VARIOS'
AUXILI[10] =  'J = CONSULTAS DE COMPROBANTES'
AUXILI[11] =  'K = CTAS.CTES. DE CLIENTES'
AUXILI[12] =  'M = LIQUIDACION DE COMISIONES A VENDEDORES'

ACTIVO[1] = .F.
ACTIVO[2] = .F.
ACTIVO[3] = .F.
ACTIVO[4] = .F.
ACTIVO[5] = .F.
ACTIVO[6] = .F.
ACTIVO[7] = .F.
ACTIVO[8] = .F.
ACTIVO[9] = .F.
ACTIVO[10] = .F.
ACTIVO[11] = .F.
ACTIVO[12] = .F.
RETURN
