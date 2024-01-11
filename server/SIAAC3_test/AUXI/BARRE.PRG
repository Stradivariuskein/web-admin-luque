PARAMETERS M_FUNC
PRIVATE I
DECLARE TABLA[ADIR("*.DBF")]
ADIR("*.DBF",TABLA)
FOR I=1 TO LEN(TABLA)
    S=BASEPD(TABLA[I],M_FUNC)
    IF S<>0
       CLEAR
       @ 24,25 SAY "PROBLEMAS CON EL ARCHIVO: "+TABLA[I]
       INKEY(0)
       CLEAR
    ENDIF
NEXT I
CLEAR
CLOSE ALL
QUIT
*
FUNCTION BASEPD
* Protege o desprotege un archivo.
* Devuelve: 1- Archivo inexistente
*           2- Error de lectura / grabacion
*           0- Ok
PRIVATE _NOM_ARCH,_LLAVE,_ARCH,handle,sale
PARAMETERS _NOM_ARCH,_LLAVE
IF UPPER(SUBSTR(_NOM_ARCH,LEN(_NOM_ARCH)-3,4))<>".DBF"
   _ARCH=_NOM_ARCH+".DBF"
ELSE
   _ARCH=_NOM_ARCH
ENDIF
IF .NOT. FILE("&_ARCH")
   RETURN(1)
ENDIF
IF _LLAVE="D" .OR. _LLAVE="d"
   sale=""
ELSE
   sale=")"
ENDIF
handle = FOPEN ("&_ARCH",2)
IF FERROR() <> 0
   FCLOSE(handle)
   RETURN(2)
ENDIF
FSEEK(handle,0,0)
FWRITE(handle,sale,1)
FCLOSE(handle)
RETURN(0)
