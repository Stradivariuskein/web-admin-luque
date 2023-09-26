from django.shortcuts import render
from django.views.generic import ListView, CreateView
from django.urls import reverse_lazy

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
    carpeta = 'Y:\\Lista de Precio\\'
    if os.path.exists(carpeta):
    # Obtener una lista de todos los archivos en la carpeta
    archivos = os.listdir(carpeta)

    # Imprimir el nombre de cada archivo
    for archivo in archivos:
        result = findall(".xlsx$", archivo)
        if result:
            print(archivo)