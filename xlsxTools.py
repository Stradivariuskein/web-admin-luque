from openpyxl import load_workbook
import os
import re
from datetime import datetime


#verifica si es un numero
def es_numero(num):
    try:
        float(num)
        return True
    except ValueError:
        return False


def buscarPrecio(cod, lista_num):
    #BUSCA POR CODIGO EL PRECIO DEL ARTICULO en siaac
    
    long_precio = 11
    if lista_num == 1:
        inicioPrecio = 20
    if lista_num == 5:
        inicioPrecio = 66

    finprecio = inicioPrecio + long_precio
    patron = '^' + cod.upper().strip() + ' '
    file = open("DB//articDB.txt")
    #bandera = 0
    i=0
    
    
    for linea in file:
       
        result = re.findall(patron, linea)
        #i+=1
        
        #if i == 4909 and cod == 'TUA-104':
        #    print(linea)
       
        if result:
            precio = linea[inicioPrecio:finprecio]
           
            return precio.strip(" ")

    print(f"\n\n*********************************************\n ERROR: codigo {cod} no encontrado reviselo\n*********************************************\n")    
    return -1


def actualizarPrecio (wb,row,cod,lista_num):
    #ACTUALIZA EL PRECIO EN EL EXCEL
    
    sheet = wb['Hoja1']
    cell = 'D' + str(row)
    precio = buscarPrecio(cod, lista_num)
    if precio != -1:
        sheet[cell] = float(precio)


def actualizarLista(bExcel, lista_num):
    #recorre una lista de precios, obtiene los codigo, los busca en articDB.txt y actualiza el precio
    try:
        sh = bExcel['Hoja1']
    except:
        print ("Error no exixte la Hoja1 en el archivo excel!!!!")
   
    cell=""
    i=0
    columna = 1

    now = datetime.now()    
    sh['A1'] = now

    maxFila = sh.max_row

    for i in range(1,maxFila):
        cell=str(sh.cell(row=i,column=columna).value).upper()
    
        celda = str(cell).upper()
        
        
        if celda == "COD" or celda == "COD.":
            i += 1
            cell=str(sh.cell(row=i,column=columna).value).upper()
            result = re.findall(f"[A-Z]-", cell)

            while result:
                precioActual = str(sh.cell(row=i,column=columna+3).value)
                if es_numero(precioActual):
                    actualizarPrecio(bExcel,i,cell,lista_num)
                    
                i+=1
                cell=sh.cell(row=i,column=columna).value
                if cell:                    
                    result = re.findall(f"[A-Z]-", cell.upper())
                else:
                    result = 0


def update_file_xlsx(wb):
    pass

if __name__ == '__main__':
    
    wb = load_workbook()
    
