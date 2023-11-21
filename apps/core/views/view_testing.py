from django.urls import reverse_lazy
from django.http import HttpResponse, JsonResponse
from googleapiclient.errors import HttpError

from apps.core.models import ModelArtic, ModelFileDrive
from configs import RUTE_XLSX_AGRUPS, RUTE_XLSX_ORIGIN
from apps.core.tools.apiDriveV2 import ApiDrive

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

    def find_and_compare_artics_pdf(page: str,artic: ModelArtic) -> dict:
        response = {artic.code: {}}
        
        #print(page)
        print(artic.code)

        code_in_page = page.find(f'\n {artic.code.strip().upper()}')

        if code_in_page > -1:
            code_in_page += 1
            i = 0
            lines = page[code_in_page:].split('\n')

            
            len_lines = len(lines) - 1 
            while i <= len_lines:
                line = lines[i]
                print(line[:fin_cod].strip().upper())
                if line[:fin_cod].strip().upper() == artic.code:
                    db_price = round(artic.priceMa, 2)
                    arch_price = round(float(line[init_price:fn_price].strip().replace(',','')),2)
                    result = compare_prices(db_price, arch_price, margin)
                    response[artic.code] = {
                        'db': db_price,
                        'arch': arch_price,
                        'diff': result
                    }
                    if margin != -1: # los numeros no son exactos por el rendodondeo por eso le doy marge de 0.19
                        response[artic.code]['pass'] = True
                    else:
                        response[artic.code]['pass'] = False
                        print(f"erroneo:\t{artic.code}\tarch: {arch_price}\tdb: {db_price}")
                    break
                i += 1

        #print(response)
        return response

    pdf_path = os.path.abspath('./PRICES-PDF/prices_L_5.pdf')
    fin_cod = 13
    init_price = 66
    fn_price = 76
    margin = 0.19
    # Establecer el número máximo de hilos
    max_threads = 240


    
    # Abre el archivo PDF en modo de lectura binaria
    with open(pdf_path, "rb") as file:
        # Crea un objeto PDFReader
        pdf_reader = PyPDF2.PdfReader(file)
        response = {'msj': ''}
        
        artics = ModelArtic.objects.filter(active=True)

        i = 0
        
        with concurrent.futures.ThreadPoolExecutor(max_threads) as executor:
            for page in pdf_reader.pages:
                # Adquirir el texto de la página antes de iniciar el hilo
                page_text = page.extract_text()

                # Mapear cada tarea a un hilo en el pool
                futures = {executor.submit(find_and_compare_artics_pdf, page_text, artic): artic for artic in artics}
                
                for future in concurrent.futures.as_completed(futures):
                    res_thread = futures[future]
                    try:
                        result = future.result()
                        #print(result)
                        if result != {}:
                            for code, data in result.items():
                                if not data['pass']:

                                    msj = f"ERROR: codigo {code} inexitstente"
                                    response['msj'] += msj
                                else:
                                    response.update(result)
                                #print(msj)
                        else:
                            print('nada')

                    except Exception as e:
                        print(f"Error para articulo {code}: {e}")

                
    print(len(response))            
    return JsonResponse(response)

def test_prices_precent(request):
    pass

def test_prices_manual(request):
    pass


def test_files_drive(request):

    files = ModelFileDrive.objects.all()
    response = {'msj': ''}
    drive = ApiDrive('../service_account.json')
    for f in files:
        if f.driveId:
            result = drive.get_file(f.driveId)
            if isinstance(result,HttpError):
               response['msj'] += f"{f.id} {f.name}: DriveID no fund"
               response[f.id] = "DriveID no fund"
            else:
                response[f.id] = result

    return JsonResponse(response)

def test_folders(request):
    pass


