from django.shortcuts import render
from django.views.generic import ListView, CreateView
from django.urls import reverse_lazy
from django.http import HttpResponse
from django.views import View
from django.db import transaction

from .models import ModelFileDrive, ModelFolderDrive, ModelListXlsx
from .forms import CreateFolderForm

from apiDriveV2 import ApiDrive


class TmpAddFolder(CreateView):
    model = ModelFolderDrive
    template_name = 'core/createXlsx.html'
    form_class = CreateFolderForm
    success_url = reverse_lazy('tmp')


def upload_file_drive(request):
    #if request.method == "POST":
    drive = ApiDrive("../service_account.json", "1TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi")
    xlsx = ModelListXlsx.objects.filter(id="104").first()
    folder = ModelFolderDrive(driveId='1TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi' )
    fileDrive = ModelFileDrive(driveId="",parentId=folder, listXlsxID=xlsx, name=xlsx.name)
    file = drive.retry_execute(drive.upload, fileDrive)
    return HttpResponse(file)
    #else:
    #    return HttpResponse(f"Error 500: Method no allowed")
    