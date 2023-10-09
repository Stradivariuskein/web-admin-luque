from openpyxl import load_workbook
import os
import re
from datetime import datetime


ABC = ['', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

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


# dado un archivo xlsx devuelve un dic con todos los codgos descripcion, precios, y cleda
def get_artcis_from_xlsx(rute_xlsx):
    
    try:
        wb = load_workbook(rute_xlsx)
    except FileNotFoundError:
        return None
    sheet = wb['Hoja1']

    maxRow = sheet.max_row
    
    code_pattern = "^[A-Z]+-"

    list_codes = {}
    col = 1
    row = 1
    while row < maxRow:
        cell=str(sheet.cell(row=row,column=col).value).upper()
        cell_title = cell
        if cell.strip() == 'T-246':
            print(cell)
        if cell_title == "COD" or cell_title == "COD.":
            row += 1
            cell=str(sheet.cell(row=row,column=col).value).upper()
            
            # valido q sea un codigo. el codigo se compone de letras mayusculas seguidas por un guion (ej: TIR-250)
            result = re.findall(code_pattern, cell)
            
            while result:

                
                price = sheet.cell(row=row,column=col+3).value
                if isinstance(price, str):
                    try:
                        price = float(price.strip())
                    except ValueError:
                        price = None
                list_codes[cell] = {
                    'description': str(sheet.cell(row=row,column=col+1).value).upper(),
                    'price': price,
                    'row': row,
                    'col': col
                }
                

                row += 1
                cell=str(sheet.cell(row=row,column=col).value).strip().upper()
                if cell:                    
                    result = re.findall(code_pattern, cell.upper())
                else:
                    result = None
        if cell == 'COD' or cell == 'COD.':
            pass
        else:
            row += 1

    return list_codes


def update_xlsx(xlsx_id, xlsx_data):
    
    #rute_xlsx = xlsx_data['rute'] # en despligue
    rute_xlsx = "./LISTAS/" + xlsx_data['rute'].split('\\')[-1] # en desarollo
    try:
        wb = load_workbook(rute_xlsx)
    except FileNotFoundError:
        return None
    
    list_msj = []
    sheet = wb['Hoja1']
    len_codes = len(xlsx_data)
    for code, data in xlsx_data.items():
        if code != 'rute':
            try:
                row = data['row']
                col = data['col'] - 1
                code = sheet[row][col].value 
                if code:
                    cell = f"{ABC[col+4]}{row}"
                    percent = int(data['price_percent'])
                    if percent > 0:
                        try:  
                            cell_value = sheet[row][col+3].value
                            cell_value = float(cell_value)                      
                            sheet[cell] = cell_value * (1 + (percent/100))
                            list_msj.append(f"{code}: price_percent , value: {sheet[cell].value}, cell: {cell}")
                        except ValueError:
                            list_msj.append(f"{code}: el precio {cell_value} no es un numero")
                    elif data['price_manual_may'] != None and data['price_manual_min'] != None:
                        try:
                            sheet[cell] = float(data['price_manual_may'].strip())
                        except ValueError:
                            sheet[cell] = '********'
                        list_msj.append(f"{code}: manual , value: {sheet[cell].value}, cell: {cell}")
                    else:
                        list_msj.append(f"{code}: nada para hacer")
            except Exception as e:
                list_msj.append(f"Error: {e}")
    list_msj.append(f"longitud: {len_codes}")

    wb.save(rute_xlsx)
    return list_msj



if __name__ == '__main__':

    rute = './LISTAS/BISAGRA LIBRO-5005.xlsx'
    result = get_artcis_from_xlsx(rute)

    print(result)
    print(len(result))
    print()

    rute = 'TIRAFONDOS.xlsx'
    current_id = 1
    to_update = {}
    to_update[current_id] = {'rute': rute}
    to_update[current_id]["T-232"] = {
        'price_auto': False,
        'price_percent': 0,
        'price_manual_may': 1250.30,
        'price_manual_min': 1600.00,
        'row': 50,
        'col': 1,
        'db_price': [1256.33, 1565.50]
    }

    results = update_xlsx('1', to_update[1])

    print(results)



    
    
