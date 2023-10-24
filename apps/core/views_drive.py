import os
from django.shortcuts import render
from django.views.generic import ListView, CreateView
from django.urls import reverse_lazy
from django.http import HttpResponse
from django.views import View
from django.db import transaction

from .models import ModelFileDrive, ModelFolderDrive, ModelListXlsx
from .forms import CreateFolderForm

from apiDriveV2 import ApiDrive
from configs import RUTE_XLSX_AGRUPS


class TmpAddFolder(CreateView):
    model = ModelFolderDrive
    template_name = 'core/createXlsx.html'
    form_class = CreateFolderForm
    success_url = reverse_lazy('tmp')


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
    drive = ApiDrive("../service_account.json", "1mupKCvLb4Gccpp2R9zx9vnylUVdIVgvW")



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
    

def view_get_drive(request):
    drive = ApiDrive("../service_account.json", "1mupKCvLb4Gccpp2R9zx9vnylUVdIVgvW")
    files = drive.list_drive()
    for id, value in files.items():
        print(f"{value['name']}\tID: {id}")
    return HttpResponse(files)