*MENU DE CTA. CTE. DE CLIENTES
*
DO WHILE .T.
   DECLARE MENPEE[2]
   DECLARE OPPEE[2]
   OPPEE[1]=  'RESUMEN de CUENTA de CLIENTES'
   OPPEE[2]=  'AJUSTE de CTAS. CTES.'
   MENPEE[1]='          ºResumen de Movimientos de 1 Cliente'
   MENPEE[2]='          ºAjuste de Saldos de Clientes'

   *      Displaya opciones y captura.
   OPPE=OPCIONES('SISTEMA DE VENTAS - CUENTAS DE CLIENTES',OPPEE,MENPEE)
   *      Fin
   IF LASTKEY()=27
      EXIT
   ENDIF
   DO CASE
   CASE OPPE = 1
      DO RESU
   CASE OPPE = 2
      DO AJUS_SAL
   ENDCASE
ENDDO
CLOSE ALL
RETURN
*: EOF: MENCTE.PRG
