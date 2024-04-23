from django.shortcuts import render
from .models import Test
from configs import RUTE_XLSX_ORIGIN
from apps.core.tools.xlsxTools import list_xlsx_to_folder, get_artcis_from_xlsx, buscarPrecio
from django.http import JsonResponse

def index(request):
    all_tests = Test.objects.all()
    return render(request, "testing/index.html", {'all_tests': all_tests})

# test para verificar q los precios coincidan con la base de datos
def test_prices_from_db_for_xlsx(request):

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
                        #response[code] = f"{db_artic['priceMa']} != {data['price']} || rute: {rute}\t|{data['col']}|{data['row']}"
                        #print(db_artic)
                        pass
                # si la lista esta  contenida en la carpeta mi es precio menorista
                elif split_rute[-2].upper() == 'MI' or split_rute[-3].upper() == 'MI':
                    
                    if db_artic['priceMi'] != data['price']:
                        #response[code] = f"{db_artic['priceMi']} != {data['price']}\t|{data['col']}|{data['row']}"
                        pass
                else:
                    response[code] = f'error: no es ma ni mi [{split_rute[-2]}][{split_rute[-3]}]'
            else:
                response[code] = 'error: codigo inexistente'

    return JsonResponse(response)