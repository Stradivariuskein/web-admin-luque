from django.shortcuts import render
from django.views.generic import ListView, CreateView
from django.urls import reverse_lazy
from django.http import HttpResponse

import os
from re import findall

from .models import ListXlsx
# Create your views here.

def update_xlsx(request):

    context = {
        'listXlsx': [],
    }

    return render(request, "core/index.html", context)


class CreateXlsx(CreateView):
    model = ListXlsx
    template_name = 'core/createXlsx.html'
    success_url = reverse_lazy('create-list-xlsx')
    fields = ['name', 'driveId', 'modDate', 'img', 'pathlocal']


class ListXlsx(ListView):
    model = ListXlsx
    template_name = 'core/index.html'
    context_object_name = 'listXlsx'

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
            xlsx_file = ListXlsx(name_file=archivo, modDate=mod_date_file, pathLocal=local_rute_file)
            if xlsx_file:
                print(xlsx_file)
                xlsx_file.save()
            print(xlsx_file)
            filtered_archs.append(archivo)
    print(len(filtered_archs))
    return HttpResponse(archivos)