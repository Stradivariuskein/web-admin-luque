from django.shortcuts import render
from django.views.generic import ListView, CreateView
from django.urls import reverse_lazy
from django.http import HttpResponse
from django.views import View

import os
from re import findall
import datetime

# mis bibliotecas
from siaacTools import reed_artics
from xlsxTools import get_artcis_from_xlsx

from .models import ModelListXlsx, ModelArtic
# Create your views here.


class CreateXlsx(CreateView):
    model = ModelListXlsx
    template_name = 'core/createXlsx.html'
    success_url = reverse_lazy('create-list-xlsx')
    fields = ['name', 'driveId', 'modDate', 'img', 'pathlocal']


class ListXlsx(ListView):
    model = ModelListXlsx
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

#posterior a la seleccion de las lista te pedira si quieres actualizarlas automaticamente usando los precios de la db,
# actualizarlo manualmente o poniendo un porsentaje
class ViewUpdateXlsx(View):
        
    def get(self, request, *args, **kwargs):
        IDs_xlsx = request.GET.getlist("IDs_xlsx")
        #print(IDs_xlsx)
        if IDs_xlsx:
            #buscar en la db los articulos y los precios, actualiza la lista y la sube al drive
            for Id in IDs_xlsx:
                current_xlsx = ModelListXlsx.objects.get(id=Id)
                
            
            return render(request, 'core/update_xlsx_step.html', {'listXlsx':IDs_xlsx})
        else:
            return HttpResponse("Error no se selecciono nunguna lista")

        


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
            for code in list_codes:
                code = code.strip().upper()
                current_artic = ModelArtic.objects.get(code=code)
                current_artic.listXlsxID = xlsx
                current_artic.save()
        else:
            print("el archivo no exites")

    return HttpResponse("echo")



