from django.shortcuts import render
from django.views.generic import CreateView
from django.urls import reverse_lazy
from django.http import HttpResponse
from django.views import View
from django.db import transaction

import os
import zipfile
import tempfile
import datetime
from datetime import datetime
import mimetypes

# mis bibliotecas
from siaacTools import reed_artics
from xlsxTools import update_xlsx, update_artics
from configs import *
from apiDriveV2 import ApiDrive

from .models import ModelListXlsx, ModelArtic, ModelToUpdateList, ModelFileDrive
from .forms import UpdateXlsxForm
 
# muestra todas las listas de precio para q las selecione el usuario
# arriba del todo apareceran las q se tiene q actualizar y despues las q no sufrieron cambios
class ViewSelectList(View):
    def get(self, request, *args, **kwargs):

        '''# comparamos la fecha del archivo de articulos de siaac con mi archivo de articulos
        last_update_siaac = os.path.getmtime(RUTE_SIAAC+'ARTIC.DBF')
        last_update_siaac = datetime.fromtimestamp(last_update_siaac)

        last_update_file = os.path.getmtime(RUTE_SIAAC_FILES+'articDB.txt')
        last_update_file = datetime.fromtimestamp(last_update_file)
        print('***********************')
        print(f"DBF:\t{last_update_siaac} > mi-file:\t{last_update_file}")
        print(last_update_siaac > last_update_file)
        print('***********************')
        # si la fecha de siaac es mayor entonses actualizo mi archivo
        # si no obtengo todos los articulos
        if last_update_siaac > last_update_file:
            print("actualizando articulos")
            siaac_artics = reed_artics()

        else:
            print("obteniendo articulos")
            siaac_artics = get_all_artics()'''

        
        siaac_artics = reed_artics()
        lists_xlsx = update_artics(siaac_artics)

        context = lists_xlsx

            
        return render(request, 'core/index.html', context)
            
#hola

#posterior a la seleccion de las lista te pedira si quieres actualizarlas automaticamente usando los precios de la db,
# actualizarlo manualmente o poniendo un porsentaje
class ViewUpdateXlsxStep1(View):
        
    def get(self, request, *args, **kwargs):
     

        lists_xlsx = request.GET.getlist("lists_xlsx")

        if lists_xlsx:
            xlsx_and_artics = []
            
            #buscar en la db los articulos y los precios, actualiza la lista y la sube al drive
            for xlsx in lists_xlsx:
                xlsx = xlsx.split(", ")
                artics_forms = []

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
            drive = ApiDrive("../service_account.json", "!sw3")
            with transaction.atomic():
                xlsx_to_download = ''
                for xlsx_id, xlsx_data in to_update.items():

                    
                    #actualiza la fecha de modificacion
                    current_xslx = ModelListXlsx.objects.filter(id=xlsx_id).first()
                    
                    results.append(update_xlsx(current_xslx.name, xlsx_data))
                    files_drive = ModelFileDrive.objects.filter(listXlsxID=current_xslx)

                    for file in files_drive:

                        drive.upload(file)


                    current_xslx.modDate = datetime.now()
                    current_xslx.save()

                    # elimina de ToUpdateList el registro q ya se actualizo
                    current_to_update = ModelToUpdateList.objects.filter(xlsxId=xlsx_id).first()
                    if current_to_update != None:
                        current_to_update.delete()
                    xlsx_to_download += str(xlsx_id) + ','
                xlsx_to_download = xlsx_to_download[:-1]
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
    def compress_files(list_files):
        # Nombre del archivo comprimido
        zip_file = 'listas_de_precios.zip'
        tmp_dir = tempfile.mkdtemp()
        # Ruta completa para el archivo zip
        rute_zip = os.path.join(tmp_dir, zip_file)

        with zipfile.ZipFile(rute_zip, 'w') as archivo_zip:
            # Recorre todos los archivos en la carpeta y agrégales al archivo zip

            for id in list_files:
                xlsx = ModelListXlsx.objects.filter(id=int(id)).first()

                #archivo_zip.write(xlsx.pathLocal) en despliegue
                for folder in RUTE_XLSX_ORIGIN:
                    archivo_zip.write(f"{RUTE_XLSX_ORIGIN[folder]}/{xlsx.name}",f'./{folder}/{xlsx.name}')

        return rute_zip

    if request.method == "GET":
        ids_param = request.GET.get('ids', '')  # Obtiene el parámetro 'ids' de la URL

        ids = ids_param.split(',') if ids_param else []  # Divide los IDs si existen, de lo contrario, lista vacía

        file_path = compress_files(ids)
        mime_type, _ = mimetypes.guess_type(file_path)
        try:
            file = open(file_path, 'rb')
        except:
            return HttpResponse("Error 500: error en la generacion del archivo")

        response = HttpResponse(file, content_type = mime_type)

        response['Content-Disposition'] = f"attachment; filename=listas-de-precios.zip"
        return response
    else:
        return HttpResponse(f"{request.method} no allowed")




