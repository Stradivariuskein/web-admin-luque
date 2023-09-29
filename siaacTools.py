from shutil import copy
from re import findall

# quita los caracteres q no son legible y los reeemplaza
def normalizar(linea):
    linea = linea.replace('¤', 'ñ')
    linea = linea.replace('§', '°')
    linea = linea.replace('ø', '°')
    linea = linea.replace('£', 'Ú')
    linea = linea.replace('¥', 'ñ')
    return linea


def reed_artics():
    #PASA EL ARCHIVO DE LOS ARTICULOS DE SISTEMA A UN ARCHIVO DE TEXTO FACIL DE LEER
    copy("Y:/SIAAC3/ARTIC.DBF","siaac/ARTIC.DBF")
    file = open("siaac/ARTIC.DBF", errors="ignore")
    articdb = open("siaac//articDB.txt", "w")
    for i in range(0,6):
    #se descarta las pimeras lineas
        linea = file.readline()


    linea = file.readline(2)
    linea = file.readline(200)

    dic_artics = {}
    whith_max_line = 184
    index_fin_desc = -131
    index_ini_price = 86
    index_price_1 = 84
    while linea != "":
        
        result = findall("[A-Z]$", linea)
        if result: # si termina en una letra la quito y corrijo el largo de la cadena
            lineaAux = linea[199]
            linea = linea[:index_fin_desc-1] + " " + linea[68:-1] + '\n' 
            articLine = linea[:index_fin_desc].lstrip('\x00').lstrip() + linea[index_ini_price:]
            #articdb.write(linea[:index_fin_desc].lstrip('\x00').lstrip() + linea[index_ini_price:])
            linea = lineaAux + file.readline(199) # leo un caracter menos
        else:
            articLine = linea[:index_fin_desc].lstrip('\x00').lstrip() + linea[index_ini_price:] + '\n'
            #articdb.write(linea[:index_fin_desc].lstrip('\x00').lstrip() + linea[index_ini_price:] + '\n')
            linea = file.readline(200)
        
        len_artic = len(articLine)
        #print(f"{articLine} {len(articLine)}")
        if len_artic > whith_max_line:
            articLine = articLine[:64] + articLine[65:]
            

        try:
            price1 = float(articLine[79:91])
        except ValueError:
            price1 = 0

        if price1 != 0:
            articLine = normalizar(articLine)
            artic_cod = articLine[:11].strip()
            artic_desc = articLine[11:67].strip()
            artic_price_mi = float(articLine[79:90].strip())
            artic_price_ma = float(articLine[127:138].strip())
            #usar el diccionara dic_artic para retornar
            articdb.write(articLine)
            dic_artics[artic_cod] = {
                'description': artic_desc,
                'price_ma': artic_price_ma,
                'price_mi': artic_price_mi
                }


    file.close()
    articdb.close()
    return dic_artics


if __name__ == '__main__':
    print(reed_artics())