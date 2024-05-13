from django.shortcuts import render
from django.views.generic import CreateView
from django.urls import reverse_lazy
from django.http import HttpResponse, JsonResponse
from django.views import View
from django.db import transaction

import os
import shutil
from pathlib import Path
import zipfile
import tempfile
import datetime
from datetime import datetime
import mimetypes

import time

# mis bibliotecas
from apps.core.tools.siaacTools import reed_artics
from apps.core.tools.xlsxTools import update_xlsx, update_artics
from configs import *
from apps.core.tools.apiDriveV2 import ApiDrive

import threading
import requests

from apps.core.models import ModelListXlsx, ModelArtic, ModelToUpdateList, ModelFileDrive, ModelToUploadDrive
from apps.core.forms import UpdateXlsxForm
 



def test(request):
    siaac_artics = reed_artics()
    
# muestra todas las listas de precio para q las selecione el usuario
# arriba del todo apareceran las q se tiene q actualizar y despues las q no sufrieron cambios
class ViewSelectList(View):
    def get(self, request, *args, **kwargs):
        # verifico si hay archivos pendiantes a subir
        url = f"http://{IP}/reuploadDrive/"
    
        try:
            # Realiza la solicitud sin esperar la respuesta
            thread = threading.Thread(target=requests.get, args=(url,)) 
            thread.start()
            
        except requests.exceptions.RequestException as e:
            print(f"Error en la solicitud: {e}")
        
        # actualizamos la db
        siaac_artics = reed_artics()
        # calculamos las listas q se tiene q actualizar
        lists_xlsx = update_artics(siaac_artics)

        context = lists_xlsx

            
        return render(request, 'core/index.html', context)
            


#posterior a la seleccion de las lista te pedira si quieres actualizarlas automaticamente usando los precios de la db,
# actualizarlo manualmente o poniendo un porsentaje
class ViewUpdateXlsxStep1(View):
        
    def post(self, request, *args, **kwargs):
     

        lists_xlsx = request.POST.getlist("lists_xlsx")

        if lists_xlsx:
            xlsx_and_artics = []
            
            #buscar en la db los articulos y los precios, actualiza la lista y la sube al drive
            for xlsx in lists_xlsx:
                xlsx = xlsx.split(", ")
                artics_forms = []

                list_artics = ModelArtic.objects.filter(listXlsxID=int(xlsx[0].split(' ')[1]), active=True).order_by('code')
                for artic in list_artics:
                    if not artic.priceXlsx:
                        artic.priceMa = None
                        artic.priceMi = None
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
            files = []

            with transaction.atomic():

                xlsx_to_download = ''
                for xlsx_id, xlsx_data in to_update.items():

                    
                    #actualiza la fecha de modificacion
                    current_xslx = ModelListXlsx.objects.filter(id=xlsx_id).first()

                    update = update_xlsx(current_xslx.name, xlsx_data)
                    
                   

                    current_xslx.modDate = datetime.now()
                    current_xslx.save()

                    # elimina de ToUpdateList el registro q ya se actualizo
                    current_to_update = ModelToUpdateList.objects.filter(xlsxId=xlsx_id).first()
                    if current_to_update != None:
                        current_to_update.delete()
                    xlsx_to_download += str(xlsx_id) + ','


                    results.append(update)

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

# recive los ids separados por ','(ej: '1,50,28,36...') de 
# las lista a subir busca en la db todos los archivos q tenga esos ids
# los sube al drive y actualiza la db
# es una pecion ajax por post
class ViewUploadDrive(View):
    def post(self, request, *args, **kwargs):
        def gen_bachs(elementes, bach_sisze):
            if bach_sisze >= len(elementes):
                return [elementes]
            else:
                return [elementes[i:i + bach_sisze] for i in range(0, len(elementes), bach_sisze)]

        results_threads = []
        def upload_save_file(file):

            drive = ApiDrive(FILE_CREDENTIALS_DRIVE)
            results_threads.append(drive.upload(file))


        
        results = {}
        print("subiendo")
        data = request.POST
        xlsx_ids = data['xlsx_id'].split(',')
        files = ModelFileDrive.objects.none()
        
        for id in xlsx_ids:

            try:
                xlsx = ModelListXlsx.objects.get(id=id)
                if not xlsx.name in results:
                    results[xlsx.name] = {}
                current_files = ModelFileDrive.objects.filter(listXlsxID=xlsx)
                if current_files:
                    files |= current_files
                else:
                    results[xlsx.name]['no_drive'] = True
            except ModelListXlsx.DoesNotExist:
                results[xlsx.name] = {'error': f"ID({id}) does not exist. "}
        
        
        
        threads = []

        for file in files:

            
            thread = threading.Thread(target=upload_save_file, args=(file,))
            threads.append(thread)
            thread.start()
            #delay para evitar la limitacion de peticiones de google
            time.sleep(0.5)

        for thread in threads:
            thread.join()

        for file in results_threads:
        
            if isinstance(file, ModelFileDrive):
                
                file.save()
                if file.parentId.name == "ma":
                    results[file.name]['Link comun mayorista'] = f"https://docs.google.com/spreadsheets/d/{file.driveId}/edit#gid=813836489" 
                    
                elif file.parentId.name == "mi":
                    results[file.name]['Link comun minorista'] = f"https://docs.google.com/spreadsheets/d/{file.driveId}/edit#gid=813836489" 
                
                elif file.parentId.parentId.name == "ma":
                    results[file.name]['Link ordenado mayorista'] = f"https://docs.google.com/spreadsheets/d/{file.driveId}/edit#gid=813836489" 
                    
                elif file.parentId.parentId.name == "mi":
                    results[file.name]['Link ordenado minorista'] = f"https://docs.google.com/spreadsheets/d/{file.driveId}/edit#gid=813836489"
                
                
                
            else:
                error = file['response']
                file = file['file']
                exist_file_to_upload = ModelToUploadDrive.objects.filter(fileDrive=file)
                if not exist_file_to_upload:
                    to_upload = ModelToUploadDrive(fileDrive=file)
                    to_upload.save()
                
                if 'error' in results[file.name]:
                    results[file.name]['error'] += f'Error uploading file to drive. {error}'
                else:
                    results[file.name]['error'] = f'Error uploading file to drive. {error}'


        return JsonResponse(results)
    
class ReuploadFileDrive(View):
    def get(self, request, *args, **kwargs):
        results_threads = []
        def upload_save_file(file):
            drive = ApiDrive(FILE_CREDENTIALS_DRIVE)
            results_threads.append(drive.upload(file))

        files_to_upload = ModelToUploadDrive.objects.all()
        threads = []
        for file in files_to_upload:
            
            thread = threading.Thread(target=upload_save_file, args=(file.fileDrive,))
            threads.append(thread)
            thread.start()

        for thread in threads:
            thread.join()
        results = {}
        for file in results_threads:
            if isinstance(file, ModelFileDrive):
                file.save()
                files_to_upload.get(fileDrive=file).delete()
                if file.parentId.name.lower() == 'ma':
                    link_name = 'Lista comun mayorista'
                elif file.parentId.name.lower() == 'mi':
                    link_name = 'Lista comun minorista'
                elif file.parentId.parentId.name.lower() == 'ma':
                    link_name = 'Lista ordenada mayorista'
                elif file.parentId.parentId.name.lower() == 'mi':
                    link_name = 'Lista ordenada minorista'
                results[file.name] = {link_name: f"https://docs.google.com/spreadsheets/d/{file.driveId}/edit#gid=813836489"}
            else:
                results[file['file'].name] = {}
                
        return JsonResponse(results)
            
    

# recive los ids separados por ','(ej: '1,50,28,36...') de 
# las listas a descargar, las comprime en un zip 
def download_xlsx(request):
    #comprime los archivo en un zip
    def compress_files(list_files):
        # Nombre del archivo comprimido
        date_now_str = datetime.now().date().strftime("%d-%m-%Y")
        zip_file = f'listas_de_precios-{date_now_str}.zip'
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


def get_prices_form_code(request):

    code = request.GET.get('code', None)
    priceMa = None
    priceMi = None

    if code:
        artic = ModelArtic.objects.filter(code=code.strip().upper()).first()
        if artic:
            priceMa = artic.priceMa
            priceMi = artic.priceMi

    return JsonResponse({'priceMa': priceMa, 'priceMi': priceMi})