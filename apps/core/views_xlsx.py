from django.shortcuts import render
from django.views.generic import ListView, CreateView
from django.urls import reverse_lazy
from django.http import HttpResponse


from .models import ModelListXlsx
from xlsxTools import list_xlsx_to_folder
from configs import RUTE_XLSX_AGRUPS



def get_xlsx_and_parent(request):

    drive_xlsx_lists = ModelListXlsx.objects.all()
    local_xlsx_list = list_xlsx_to_folder(RUTE_XLSX_AGRUPS['ma'])
    for local_xlsx in local_xlsx_list:
        for id, values in drive_xlsx_lists.items():
            if local_xlsx[1] == values['parentId'].name:
    return HttpResponse(f"")