from django.urls import reverse_lazy
from django.http import HttpResponse, JsonResponse
from googleapiclient.errors import HttpError

from apps.core.models import ModelArtic, ModelFileDrive
from configs import RUTE_XLSX_AGRUPS, RUTE_XLSX_ORIGIN, RUTE_SIAAC_FILES
from apps.core.tools.apiDriveV2 import ApiDrive
from apps.core.tools.xlsxTools import get_artcis_from_xlsx, list_xlsx_to_folder, buscarPrecio

import os
import PyPDF2
import threading
import concurrent.futures



def test_prices_siaac(request):

    # resta dos numeros si el resultado absoluto es menor q max_diff, restorna el resultado sino restona -1
    def compare_prices(price_1,price_2, max_diff):
        result = abs(price_1 - price_2)
        
        if 0 <= result <= max_diff:
            return result
        return -1
    # busca un codigo en la cadena si lo encuentra, compara el precio de un articulo con el de la cadena. ma_mi hace referencia a cual de los precios tiene q comaprar 
    def find_and_compare_artics_pdf(page: str,artic: ModelArtic, ma_mi: str) -> dict:
        response = {artic.code: {}}
       
        code_in_page = page.find(f'\n {artic.code.strip().upper()}')
        if code_in_page > -1:
            code_in_page += 1
            i = 0
            lines = page[code_in_page:].split('\n')

            
            max_lines = len(lines) - 1 
            while i <= max_lines:
                line = lines[i]
                # esta validacion es para asegurarse q el codigo sea exactamente el mimso sino itero por cada linea restante
                if line[:fin_cod].strip().upper() == artic.code:
                    if ma_mi == 'ma':
                        db_price = round(artic.priceMa, 2)
                    else:
                        db_price = round(artic.priceMi, 2)
                    arch_price = round(float(line[init_price:fn_price].strip().replace(',','')),2)
                    
                    result = compare_prices(db_price, arch_price, margin)
                    response[artic.code] = {
                        'db': db_price,
                        'arch': arch_price,
                        'diff': result
                    }
                    if result != -1: # los numeros no son exactos por el rendodondeo por eso le doy marge de 0.19
                        response[artic.code]['pass'] = True
                    else:
                        response[artic.code]['pass'] = False
                        print(f"erroneo:\t{artic.code}\tarch: {arch_price}\tdb: {db_price}")
                    break
                i += 1


        return response
    
    #recive el pdf y los articulos mas el precio q hay q comaprar (ma_mi: 'ma'|'mi') lo hace un multiple hilos
    def threads_compare_prices(pdf_reader, artics, ma_mi):
        max_threads = 240
        response = {'msj': ''}
        with concurrent.futures.ThreadPoolExecutor(max_threads) as executor:
                for page in pdf_reader.pages:
                    # Adquirir el texto de la página antes de iniciar el hilo
                    page_text = page.extract_text()

                    # Mapear cada tarea a un hilo en el pool
                    futures = {executor.submit(find_and_compare_artics_pdf, page_text, artic, ma_mi): artic for artic in artics}
                    
                    for future in concurrent.futures.as_completed(futures):
                        
                        try:
                            result = future.result()

                            if result != {}:
                                for code, data in result.items():
                                    if data:
                                        if not data['pass']:

                                            msj = f"ERROR: codigo {code} inexitstente"
                                            response['msj'] += msj
                                        else:
                                            response.update(result)
   
                            else:
                                print('nada')

                        except Exception as e:
                            print(data)
                            print(f"Error para articulo {code}: {e}")
                
                            
        return response
    # comienzo
    pdf_paths = [os.path.abspath('./PRICES-PDF/prices_L_5.pdf'), os.path.abspath('./PRICES-PDF/prices_L_1.pdf')]

    fin_cod = 13
    init_price = 66
    fn_price = 76
    margin = 0.19
    
    response = {'msj': ''}
    for path in pdf_paths:
    
        # Abre el archivo PDF en modo de lectura binaria
        with open(path, "rb") as file:

            # Crea un objeto PDFReader
            pdf_reader = PyPDF2.PdfReader(file)
            name = f"{file.name}".split('/')[-1]
            if name == 'prices_L_1.pdf':
                ma_mi = 'mi'
            else:
                ma_mi = 'ma'
            
            
            artics = ModelArtic.objects.filter(active=True)

            response |= threads_compare_prices(pdf_reader,artics, ma_mi)

          
    return JsonResponse(response)

def test_prices_precent(request):
    pass

def test_prices_manual(request):
    pass

# test para verificar q los precios sean correctos
def test_prices_auto(request):

    xlsx_rutes = []
    #obtenemos las rutas de todos los archivos xlsx
    for _, rute in RUTE_XLSX_ORIGIN.items():
        xlsx_rutes += list_xlsx_to_folder(rute)
    response = {}
    #por cada archivo obtenemos los codigos y precios y los compaamos con los de la base de datos
    for rute in xlsx_rutes:
        split_rute = rute.split('/')
        
        artics = get_artcis_from_xlsx(rute)
        for code, data in artics.items():
            db_artic = {
                "priceMa": buscarPrecio(code, 5),
                "priceMi": buscarPrecio(code, 1)
            }
            if db_artic != None:
                # si la lista esta  contenida en la carpeta ma es precio mayorista
                if split_rute[-2].upper() == 'MA' or split_rute[-3].upper() == 'MA':
                    
                    if db_artic['priceMa'] != data['price']:
                        response[code] = f"{db_artic['priceMa']} != {data['price']} || rute: {rute}\t|{data['col']}|{data['row']}"
                        print(db_artic)
                # si la lista esta  contenida en la carpeta mi es precio menorista
                elif split_rute[-2].upper() == 'MI' or split_rute[-3].upper() == 'MI':
                    
                    if db_artic['priceMi'] != data['price']:
                        response[code] = f"{db_artic['priceMi']} != {data['price']}\t|{data['col']}|{data['row']}"
                else:
                    response[code] = f'error: no es ma ni mi [{split_rute[-2]}][{split_rute[-3]}]'
            else:
                response[code] = 'error: codigo inexistente'

    return JsonResponse(response)

# testea si todos los archivos existen en el drive
def test_files_drive(request):

    files = ModelFileDrive.objects.all()
    response = {'msj': ''}
    drive = ApiDrive('../service_account.json')
    for f in files:
        if f.driveId:
            result = drive.get_file(f.driveId)
            if not result:
               response['msj'] += f"{f.id} {f.name}: DriveID no fund"
               response[f.name] = "DriveID no fund"
            else:
                if f.name == result['name'] and f.parentId.driveId == result['parents'][0]:
                    pass
                else:
                    response[f.id] = f"{f.name}|{result['name']}  parents: {result['parents']} != {f.parentId.driveId}]|{f.name == result['name'] and f.parentId.driveId == result['parents']}"

    return JsonResponse(response)

def test_folders(request):
    pass


