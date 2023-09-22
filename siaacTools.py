from shutil import copy
from re import findall

def leerArtic():
    #PASA EL ARCHIVO DE LOS ARTICULOS DE SISTEMA A UN ARCHIVO DE TEXTO FACIL DE LEER
    copy("Y:/SIAAC3/ARTIC.DBF","siaac/ARTIC.DBF")
    file = open("siaac/ARTIC.DBF", errors="ignore")
    articdb = open("siaac//articDB.txt", "w")
    for i in range(0,6):
    #se descarta las pimeras lineas
        linea = file.readline()


    linea = file.readline(2)
    linea = file.readline(200)

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
        
        try:
            price1 = float(articLine[79:91])
        except ValueError:
            price1 = 0

        if price1 != 0:
            articdb.write(articLine)

    file.close()
    articdb.close()

if __name__ == '__main__':
    leerArtic()