import os
from django.views.generic import CreateView
from django.urls import reverse_lazy
from django.http import HttpResponse

from apps.core.models import ModelFileDrive, ModelFolderDrive, ModelListXlsx
from apps.core.forms import CreateFolderForm

from apps.core.tools.apiDriveV2 import ApiDrive
from configs import RUTE_XLSX_AGRUPS, FILE_CREDENTIALS_DRIVE

def upload_file_drive(request):
    def listar_archivos_recursivamente(ruta):
        files = []
        for raiz, directorios, archivos in os.walk(ruta):
            for archivo in archivos:
                # Imprime la ruta completa del archivo
                ruta_completa = os.path.join(raiz, archivo)
                files.append(ruta_completa)
        return files
    #if request.method == "POST":
    drive = ApiDrive(FILE_CREDENTIALS_DRIVE, "1mupKCvLb4Gccpp2R9zx9vnylUVdIVgvW")



    folderMa = ModelFolderDrive(driveId='1O25qycAFLlP6IMTJD3IahC_fXIBwHuJ4' )
    folderMa.save()
    files = listar_archivos_recursivamente(RUTE_XLSX_AGRUPS['ma'])
    name = os.path.basename(files[0])
    xlsx = ModelListXlsx.objects.filter(name=name).first()
    fileDrive = ModelFileDrive(driveId="",parentId=folderMa, listXlsxID=xlsx, name=xlsx.name)
    fileDrive.save()
    file = drive.retry_execute(drive.upload, fileDrive)

    
    #folderMi = ModelFolderDrive(driveId='19Mt4Z7uDXLeaNXh7Mkyax3_I-CvfdDsy' )

   
    return HttpResponse(file)
    #else:
    #    return HttpResponse(f"Error 500: Method no allowed")
    

def view_sinc_folder_drive(request):
    drive = ApiDrive(FILE_CREDENTIALS_DRIVE, "1mupKCvLb4Gccpp2R9zx9vnylUVdIVgvW")
    files = drive.list_drive()
    print(f"archs: {files}")
    folder_list = []
    for id, value in files.items():
        name = value['name'].strip().lower()
        if name[-5:] != '.xlsx':
            folder_exist_db = ModelFolderDrive.objects.filter(driveId=id).first()
            
            if folder_exist_db == None:

                parent_folder = ModelFolderDrive.objects.filter(driveId=value['parents'][0]).first()

                if parent_folder:
                    new_folder = ModelFolderDrive(parentId=parent_folder, driveId=value['id'], name=value['name'])
                    print(f"save:\t {value['name']}\tID:\t{id}")
                    new_folder.save()
                else:
                    print(f"La carpeta con id {value['parents'][0]} no existe")
            else:
                # si no existe el archivo lo tengo q borrar
                folder_list.append(folder_exist_db)
            
            childrens_files = drive.list_drive(parent_id=id)
            for child_id, child_values in childrens_files.items():
                name = child_values['name'].strip().lower()
                if name[-5:] == '.xlsx':
                    file = ModelFileDrive.objects.filter(driveId=child_id).first()
                    if file is None:
                        xlsx = ModelListXlsx.objects.filter(name=child_values['name']).first()
                        if xlsx is not None:
                            folder = ModelFolderDrive.objects.filter(driveId=child_values['parents'][0]).first()
                            if folder is not None:
                                file = ModelFileDrive(driveId=child_id, listXlsxID=xlsx, name=child_values['name'], parentId=folder)
                                file.save()



        else:
            file = ModelFileDrive.objects.filter(driveId=id).first()
            if file is None:
                xlsx = ModelListXlsx.objects.filter(name=value['name']).first()
                if xlsx is not None:
                    folder = ModelFolderDrive.objects.filter(driveId=value['parents'][0]).first()
                    if folder is not None:
                        file = ModelFileDrive(driveId=id, listXlsxID=xlsx, name=value['name'], parentId=folder)
                        file.save()
            

    # si hay una carpeta q no este en el drive la eliminamos
    folders_drive = ModelFolderDrive.objects.all()        
    for folder in folders_drive:
        if not folder in folder_list:
            folder.adelete()

                

    return HttpResponse(files)
