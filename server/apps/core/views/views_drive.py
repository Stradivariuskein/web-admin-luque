import os
from django.views.generic import CreateView
from django.urls import reverse_lazy
from django.http import HttpResponse, JsonResponse
from django.views import View
from django.db import transaction

import threading
import time

from apps.core.models import ModelFileDrive, ModelFolderDrive, ModelListXlsx, ModelToUploadDrive
from apps.core.forms import CreateFolderForm

from apps.core.tools.apiDriveV2 import ApiDrive
from configs import RUTE_XLSX_AGRUPS, FILE_CREDENTIALS_DRIVE

# def upload_file_drive(request):
#     def listar_archivos_recursivamente(ruta):
#         files = []
#         for raiz, directorios, archivos in os.walk(ruta):
#             for archivo in archivos:
#                 # Imprime la ruta completa del archivo
#                 ruta_completa = os.path.join(raiz, archivo)
#                 files.append(ruta_completa)
#         return files

#     drive = ApiDrive(FILE_CREDENTIALS_DRIVE, "1mupKCvLb4Gccpp2R9zx9vnylUVdIVgvW")



#     folderMa = ModelFolderDrive(driveId='1O25qycAFLlP6IMTJD3IahC_fXIBwHuJ4' )
#     folderMa.save()
#     files = listar_archivos_recursivamente(RUTE_XLSX_AGRUPS['ma'])
#     name = os.path.basename(files[0])
#     xlsx = ModelListXlsx.objects.filter(name=name).first()
#     fileDrive = ModelFileDrive(driveId="",parentId=folderMa, listXlsxID=xlsx, name=xlsx.name)
#     fileDrive.save()
#     file = drive.retry_execute(drive.upload, fileDrive)

    
    

   
#     return HttpResponse(file)
    

# def view_sinc_folder_drive(request):
#     drive = ApiDrive(FILE_CREDENTIALS_DRIVE, "1mupKCvLb4Gccpp2R9zx9vnylUVdIVgvW")
#     files = drive.list_drive()
#     print(f"archs: {files}")
#     folder_list = []
#     for id, value in files.items():
#         name = value['name'].strip().lower()
#         if name[-5:] != '.xlsx':
#             folder_exist_db = ModelFolderDrive.objects.filter(driveId=id).first()
            
#             if folder_exist_db == None:

#                 parent_folder = ModelFolderDrive.objects.filter(driveId=value['parents'][0]).first()

#                 if parent_folder:
#                     new_folder = ModelFolderDrive(parentId=parent_folder, driveId=value['id'], name=value['name'])
#                     print(f"save:\t {value['name']}\tID:\t{id}")
#                     new_folder.save()
#                 else:
#                     print(f"La carpeta con id {value['parents'][0]} no existe")
#             else:
#                 # si no existe el archivo lo tengo q borrar
#                 folder_list.append(folder_exist_db)
            
#             childrens_files = drive.list_drive(parent_id=id)
#             for child_id, child_values in childrens_files.items():
#                 name = child_values['name'].strip().lower()
#                 if name[-5:] == '.xlsx':
#                     file = ModelFileDrive.objects.filter(driveId=child_id).first()
#                     if file is None:
#                         xlsx = ModelListXlsx.objects.filter(name=child_values['name']).first()
#                         if xlsx is not None:
#                             folder = ModelFolderDrive.objects.filter(driveId=child_values['parents'][0]).first()
#                             if folder is not None:
#                                 file = ModelFileDrive(driveId=child_id, listXlsxID=xlsx, name=child_values['name'], parentId=folder)
#                                 file.save()



#         else:
#             file = ModelFileDrive.objects.filter(driveId=id).first()
#             if file is None:
#                 xlsx = ModelListXlsx.objects.filter(name=value['name']).first()
#                 if xlsx is not None:
#                     folder = ModelFolderDrive.objects.filter(driveId=value['parents'][0]).first()
#                     if folder is not None:
#                         file = ModelFileDrive(driveId=id, listXlsxID=xlsx, name=value['name'], parentId=folder)
#                         file.save()
            

#     # si hay una carpeta q no este en el drive la eliminamos
#     folders_drive = ModelFolderDrive.objects.all()        
#     for folder in folders_drive:
#         if not folder in folder_list:
#             folder.adelete()

                

#     return HttpResponse(files)


# recive los ids separados por ','(ej: '1,50,28,36...') de 
# las lista a subir busca en la db todos los archivos q tenga esos ids
# los sube al drive y actualiza la db
# es una pecion ajax por post
class ViewUploadDrive(View):
    def post(self, request, *args, **kwargs):
    
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
                # agregar la carpeta contenedora de cada archivo
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


class ChangeRootDrive(View):
    @transaction.atomic
    def post(self, request, *args, **kwargs):
        data = request.POST
        driveIds = data['driveIds']
        folders_names = ["MA", 'MI']

        #crear carpetas ma y mi por cada DriveId
        drive = ApiDrive(cred_file=FILE_CREDENTIALS_DRIVE)
        for driveId in driveIds.items():
            for current_name in folders_names:
                maches = drive.find_file_id_by_name(current_name, parent_id=driveId)
                if not maches:
                    drive.create_folder(folder_name=current_name)
        # paso 2 por cada lista traer todos los registros de file_drive
        list_xlsx = ModelListXlsx.objects.all()
        files_drive = []
        for xlsx in list_xlsx:
            finded_files = ModelFileDrive.objects.filter(file_id=xlsx.id) # obtiene los archivo en el drive q estan vinculados con la lista correspondiente
            if finded_files:
                for file in finded_files:

                    files_drive.append(file)

        # paso 3 por cada file_drive comparar el nombre del padre con ma o mi
        # si el nombre no es ma ni mi verifica si la carpeta existe si no existe
        #  guardar el nombre del padre en una variable.
        # traer el folder_drive y comparar el nombre del padre con ma o mi
        # si es si crear las carpeta padres correspondiente (desde ma o mi ej: idDrive/ma/tornillos)
        # y sube el archivo 
        #bortra el archivo original


        return HttpResponse("pass")



class TestingPaht(View):
    def get(self, request, *args, **kwargs):
        test_file = ModelFileDrive.objects.filter(driveId='1x0wYT0LDR-E5fbogjLzJGj9jC7awoVwn').first()

        drive = ApiDrive(FILE_CREDENTIALS_DRIVE)

        path = drive.get_path(test_file)

        HttpResponse(path)