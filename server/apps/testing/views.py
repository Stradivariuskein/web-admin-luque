from django.shortcuts import render
from .models import Test
from configs import RUTE_XLSX_ORIGIN
from apps.core.tools.xlsxTools import list_xlsx_to_folder, get_artcis_from_xlsx, buscarPrecio
from django.http import JsonResponse
from apps.core.models import ModelFileDrive, ModelArtic
from apps.core.tools.apiDriveV2 import ApiDrive
from apps.core.tools.siaacTools import reed_artics

# vista de pruevas
def pruevas(request):
    artic = reed_artics()
    return JsonResponse(artic['F-004/1'])

# interfaz para la gestion de tests
def index(request):
    all_tests = Test.objects.all()
    return render(request, "testing/index.html", {'all_tests': all_tests})

# test para verificar q los precios de los excels coincidan con el archivo articDB.txt
def test_prices_from_db_for_xlsx(request):

    xlsx_rutes = []
    ###### cambiar q las rutas las saque de la db y no del directorio #########
    #obtenemos las rutas de todos los archivos xlsx
    for _, rute in RUTE_XLSX_ORIGIN.items():
        xlsx_rutes += list_xlsx_to_folder(rute)
    response = {'errors': ''}
    #por cada archivo obtenemos los codigos y precios y los compaamos con los de la base de datos
    for rute in xlsx_rutes:
        split_rute = rute.split('/')
        
        artics = get_artcis_from_xlsx(rute)
        for code, data in artics.items():
            if data['price'] != None:# puede no tener precio en el archivo excel
                try:
                    db_artic = {
                        "priceMa": float(buscarPrecio(code, 5)),
                        "priceMi": float(buscarPrecio(code, 1))
                    }
                except ValueError:
                    response['errors'] += f"[{code}] Error en el archivo articdb.txt"
                    continue

                if db_artic != None:
                    # si la lista esta  contenida en la carpeta ma es precio mayorista
                    if split_rute[-2].upper() == 'MA' or split_rute[-3].upper() == 'MA':
                        
                        if db_artic['priceMa'] != data['price']:
                            response['errors'] += f" | {db_artic['priceMa']} != {data['price']} || rute: {rute}\t|{data['col']}|{data['row']}"
                            #print(db_artic)
                            pass
                    # si la lista esta  contenida en la carpeta mi es precio menorista
                    elif split_rute[-2].upper() == 'MI' or split_rute[-3].upper() == 'MI':
                        
                        if db_artic['priceMi'] != data['price']:
                            response['errors'] += f" | {code}: precios no coinciden. {db_artic['priceMi']} != {data['price']}\t|{data['col']}|{data['row']}"
                            
                    else:
                        response['errors'] += f' | error{code}: no es ma ni mi [{split_rute[-2]}][{split_rute[-3]}]'
                else:
                    response['errors'] += f' | error: codigo {code} inexistente'

    return JsonResponse(response)

# testea si todos los archivos existen en el drive
def test_files_exist_in_drive(request):

    files = ModelFileDrive.objects.all()
    response = {'errors': ''}
    drive = ApiDrive('../service_account.json')
    for f in files: # por cada archivo en la base de datos verifica q el id exista en el drive
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