import os
import re
from openpyxl import load_workbook
from openpyxl.styles import Font


def getListas():
    #CREA UNA LISTA CON TODOS LOS ARCHVOS .XLSX EN EL MISMO DIRECTORIO DE EJECUCON
    archivos = os.listdir('./')
    lista = []
    for line in archivos:
        result = re.findall("\S.xlsx", line)
        if result:
            lista.append(line)
            
    return lista

if __name__ == '__main__':

    listas = getListas()

    for arch in listas:
        try:
            book = load_workbook(filename= arch)
        except:
            print(F"\n\nERROR NO SE PUEDE ABRIR LA LISTA{arch}\nINTENTE CERRAR LAS LISTA E INTETELO NUEVAMENTE")
            
        
        try:
            sh = book['Hoja1']
        except:
            print ("Error no exixte la Hoja1 en el archivo excel!!!!")
    
        


    
        sh['A7'] = "BUENOS AIRES                   luquearti@gmail.com"

        sh['A7'].font = Font(name = 'Arial Black', size = 14)

        
        try:
            book.save(f"./{arch}")
        except:
            print(f"\n\nError no se puedo guardar el archivo {arch}. intetnte cerrar todos los archivos excel e intentelo nuevamente")

    input("\n\n--PRECIONE ENTER PARA SALIR--")
        