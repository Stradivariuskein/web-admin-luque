from django.shortcuts import render
from django.views.generic import ListView, CreateView
from django.urls import reverse_lazy
from django.http import HttpResponse
from django.views import View
from django.db import transaction

import os
import zipfile
import tempfile
from re import findall
import datetime
from datetime import datetime

# mis bibliotecas
from siaacTools import reed_artics, get_all_artics
from xlsxTools import get_artcis_from_xlsx, update_xlsx
from configs import *

from .models import ModelListXlsx, ModelArtic, ModelToUpdateList
from .forms import UpdateXlsxForm
#no es una vista
# recive una lista con todos los registros de listXlsx
# devuelve las listas con los codigos correspondientes
def get_codes_to_xlsx_list(lists_xlsx):
    len_list_xlsx = len(lists_xlsx)
    for i in range(len_list_xlsx,0,-1):
        xlsx = lists_xlsx.pop()
        if xlsx != None:
            artics = ModelArtic.objects.filter(listXlsxID=xlsx).values("code")
            codes = ""
            for artic in artics:
                codes += artic['code'] + ', '

            codes = codes[:-2]
            
            lists_xlsx = [(xlsx, codes)] + lists_xlsx
    return lists_xlsx

# no es una vista
# compara si hay diferencia en los precios y devuelve una lista con todos los archivos xlsx 
# q requieren una actualizacion
def update_artics(artics):
    with transaction.atomic():
        
        db_artics = ModelArtic.objects.all()
        artic_exist = False
        to_update = []
        no_changes = []

        to_change_db = ModelToUpdateList.objects.all()
        for xlsx_change in to_change_db:
            to_update.append(xlsx_change.xlsxId)
        # verifico q los precios esten actualizados, si no los actualiza
        for code, data in artics.items():
            for artic in db_artics:
                if artic.code == code:
                    try:
                        diff_ma = abs(round(artic.priceMa,1) - round(data['priceMa'],1))
                        diff_mi = abs(round(artic.priceMi,1) - round(data['priceMi'],1))
                        if diff_ma > 0.19  or diff_mi > 0.19:
                            
                            
                            artic.priceMa = data['priceMa']
                            artic.priceMi = data['priceMi']
                            artic.description = data['description']
                            artic.save()

                            xlsx = ModelToUpdateList.objects.filter(xlsxId=artic.listXlsxID).first()
                            if xlsx == None:
                                xlsx = ModelToUpdateList(xlsxId=artic.listXlsxID)
                                xlsx.save()

                            if not xlsx.xlsxId in to_update:
                                to_update.append(xlsx.xlsxId)

                        else:
                            if not artic.listXlsxID in no_changes:
                                no_changes.append(artic.listXlsxID)
                    except KeyError:
                        print(KeyError("Error en la data"))
                    except Exception as e:
                        print("*************************************")
                        print(f"Error: {e}")
                        print("*************************************")
                    artic_exist = True

            if not artic_exist:
                new_artic = ModelArtic(code=code, description=[data['description']], priceMa=data['priceMa'], priceMi=data['priceMi'])
                new_artic.save()

    # se puede crear una funcion aparte  para no repetir
    to_update = get_codes_to_xlsx_list(to_update)
    # no repetir
    no_changes = get_codes_to_xlsx_list(no_changes)

    return {
        'to_update': to_update,
        'no_changes': no_changes
        }

def compress_files(list_files):
    # Nombre del archivo comprimido
    zip_file = 'listas_de_precios.zip'
    tmp_dir = tempfile.mkdtemp()
    # Ruta completa para el archivo zip
    rute_zip = os.path.join(tmp_dir, zip_file)

    with zipfile.ZipFile(rute_zip, 'w') as archivo_zip:
        # Recorre todos los archivos en la carpeta y agrégales al archivo zip

        for file in list_files:

            archivo_zip.write(file)

    return rute_zip
 
# muestra todas las listas de precio para q las selecione el usuario
# arriba del todo apareceran las q se tiene q actualizar y despues las q no sufrieron cambios
class ViewSelectList(View):
    def get(self, request, *args, **kwargs):
        lists_xlsx = ModelListXlsx.objects.all().order_by('-modDate')

        # comparamos la fecha del archivo de articulos de siaac con mi archivo de articulos
        last_update_siaac = os.path.getmtime(RUTE_SIAAC+'ARTIC.DBF')
        last_update_siaac = datetime.fromtimestamp(last_update_siaac)

        last_update_file = os.path.getmtime(RUTE_SIAAC_FILES+'articDB.txt')
        last_update_file = datetime.fromtimestamp(last_update_file)
        # si la fecha de siaac es mayor entonses actualizo mi archivo
        # si no obtengo todos los articulos
        if last_update_siaac > last_update_file:
            siaac_artics = reed_artics()

        else:
            siaac_artics = get_all_artics()

        lists_xlsx = update_artics(siaac_artics)

        context = lists_xlsx
        print(context)
            
        return render(request, 'core/index.html', context)
            
#hola

#posterior a la seleccion de las lista te pedira si quieres actualizarlas automaticamente usando los precios de la db,
# actualizarlo manualmente o poniendo un porsentaje
class ViewUpdateXlsxStep1(View):
        
    def get(self, request, *args, **kwargs):
     

        lists_xlsx = request.GET.getlist("lists_xlsx")
        #print(IDs_xlsx)
        if lists_xlsx:
            xlsx_and_artics = []
            
            #buscar en la db los articulos y los precios, actualiza la lista y la sube al drive
            for xlsx in lists_xlsx:
                xlsx = xlsx.split(", ")
                artics_forms = []
                print(f"id-xlsx: {int(xlsx[0].split(' ')[1])}")
                list_artics = ModelArtic.objects.filter(listXlsxID=int(xlsx[0].split(' ')[1])).order_by('code')
                for artic in list_artics:
                    artic_dic = {
                        'code': artic.code,
                        'price_auto': True,
                        'price_percent': 0,
                        'price_manual_may': artic.priceMa,
                        'price_manual_min': artic.priceMi,
                        'xlsx_id': artic.listXlsxID
                    }
                    form = UpdateXlsxForm(initial=artic_dic)
                    artics_forms.append((artic,form))



                current_xlsx = {
                    'list_ID': xlsx[0],
                    'list_name': xlsx[1],
                    'artics': artics_forms
                    }
                xlsx_and_artics.append(current_xlsx)
                
            
            return render(request, 'core/update_xlsx_step1.html', {'listXlsx': xlsx_and_artics})
        else:
            return HttpResponse("[Request error 422] No se selecciono nunguna lista")

# actualiza las lista de precios seleccionadas con los datos del formulario
class ViewUpdateXlsxStep2(View):

    def post(self, request, *args, **kwargs):
        data = request.POST

    
        brute_data = {

            'codes': data.getlist('code'),
            #'prices_auto': data.getlist('price_auto'),
            'price_percent': data.getlist('price_percent'),
            'price_manual_may': data.getlist('price_manual_may'),
            'price_manual_min': data.getlist('price_manual_min'),
            'xlsx_ids': data.getlist('xlsx_id'),

        }
        

        len_artics = len(brute_data['codes'])
        to_update = {}
        # ordeno todo en un diccionaraio para q sea mas fasil de tratar a posteriori
        for i in range(len_artics):
            artic = ModelArtic.objects.get(code=brute_data['codes'][i].strip())
            current_id = brute_data['xlsx_ids'][i].split(',')[0].strip()
            rute = brute_data['xlsx_ids'][i].split(',')[3].strip()
            name = rute.split("\\")[-1]
            rutes = []
            for id, rute_xlsx in RUTE_XLSX_ORIGIN.items():
                rutes.append(f"{rute_xlsx}{name}")
            try:
                to_update[current_id]['rutes'] = rutes
            except:
                to_update[current_id] = {}
                to_update[current_id]['rutes'] = rutes
            

            to_update[current_id][brute_data['codes'][i]] = {
                
                'price_percent': brute_data['price_percent'][i],
                'price_manual_may': brute_data['price_manual_may'][i].strip(),
                'price_manual_min': brute_data['price_manual_min'][i].strip(),
                'row': artic.row,
                'col': artic.col,
                
            }

            
        if len_artics == len(brute_data['price_percent']) ==  len(brute_data['xlsx_ids']) == len(brute_data['price_manual_may']) == len(brute_data['price_manual_min']):
            results = []
            with transaction.atomic():
                xlsx_to_download = ''
                for xlsx_id, xlsx_data in to_update.items():

                    
                    #actualiza la fecha de modificacion
                    current_xslx = ModelListXlsx.objects.filter(id=xlsx_id).first()

                    results.append(update_xlsx(current_xslx.name, xlsx_data))
                    current_xslx.modDate = datetime.now()
                    current_xslx.save()

                    # elimina de ToUpdateList el registro q ya se actualizo
                    current_to_update = ModelToUpdateList.objects.filter(xlsxId=xlsx_id).first()
                    if current_to_update != None:
                        current_to_update.delete()
                    xlsx_to_download += str(xlsx_id) + ','
                xlsx_to_download = xlsx_to_download[:-2]
                context = {
                    'listXlsx': results,
                    'download': xlsx_to_download
                    }

        return render(request, 'core/update_xlsx_step2.html', context)


class CreateXlsx(CreateView):
    model = ModelListXlsx
    template_name = 'core/createXlsx.html'
    success_url = reverse_lazy('create-list-xlsx')
    fields = ['name', 'driveId', 'modDate', 'img', 'pathlocal']


def download_xlsx(request):
    if request.method == "GET":
        return HttpResponse(f"{request.GET}")
    else:
        return HttpResponse(f"{request.method} no allowed")

#funcion temporal para registrar listas xlsx en la db
def temp_create_listXlsx(request):
    carpeta = 'Y:\\Lista de Precio\\LISTA MAYORISTA\\'
    if os.path.exists(carpeta):
        # Obtener una lista de todos los archivos en la carpeta
        archivos = os.listdir(carpeta)

    filtered_archs = []
    # Imprimir el nombre de cada archivo
    for archivo in archivos:
        is_xlsx = findall(".xlsx$", archivo)
        is_tmp_file = findall("^~", archivo)
        if is_xlsx and not is_tmp_file:
            local_rute_file = carpeta + archivo
            mod_date_file = os.path.getmtime(local_rute_file)
            # Convertir el timestamp a un objeto datetime
            mod_date_datetime = datetime.datetime.fromtimestamp(mod_date_file)
            # Extraer la fecha del objeto datetime
            mod_date_file = mod_date_datetime.date()
            print(f"{mod_date_file}\n\n\n\n")
            xlsx_file = ModelListXlsx(name=archivo, modDate=mod_date_file, pathLocal=local_rute_file)
            if xlsx_file:
                print(xlsx_file)
                xlsx_file.save()
            print(xlsx_file)
            filtered_archs.append(archivo)
    print(len(filtered_archs))
    return HttpResponse(archivos)


# funcion temporal par ingresar todos los articulos
def tmp_create_artics(request):
    dic_artics = reed_artics()

    for cod, artic in dic_artics.items():

        artic = ModelArtic(code=cod, description=artic['description'], priceMa=artic['price_ma'], priceMi=artic['price_mi'])
        artic.save()
    
    return HttpResponse("Echo")


# funcion temporal para vincular los articulos con las listas
def view_vincular_xlsx_artic(request):
    list_xlsx = ModelListXlsx.objects.all()
    lists_rute = '/home/mrkein/Documentos/python/web-admin-luque/web-admin-luque/LISTAS/'
    
    for xlsx in list_xlsx:
        current_xlsx = f"{lists_rute}{xlsx.name}"
        
        list_codes = get_artcis_from_xlsx(current_xlsx)
        if list_codes:
            print(f"{xlsx.name}: {list_codes}")
            for code, values in list_codes.items():
                code = code.strip().upper()
                current_artic = ModelArtic.objects.get(code=code)
                current_artic.col = values['col']
                current_artic.row = values['row']
                current_artic.listXlsxID = xlsx
                current_artic.save()
        else:
            print("el archivo no exites")

    return HttpResponse("echo")

