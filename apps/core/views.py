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
from .forms import UpdateXlsxForm
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


#posterior a la seleccion de las lista te pedira si quieres actualizarlas automaticamente usando los precios de la db,
# actualizarlo manualmente o poniendo un porsentaje
class ViewUpdateXlsxStep1(View):
        
    def get(self, request, *args, **kwargs):
        lists_xlsx = request.GET.getlist("lists_xlsx")
        #print(IDs_xlsx)
        if lists_xlsx:
            xlsx_and_artics = []
            
            #buscar en la db los articulos y los precios, actualiza la lista y la sube al drive
            for xlsx in lists_xlsx:
                xlsx = xlsx.split(", ")
                artics_forms = []
                list_artics = ModelArtic.objects.filter(listXlsxID=xlsx[0]).order_by('code')
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
                
            
            return render(request, 'core/update_xlsx_step.html', {'listXlsx': xlsx_and_artics})
        else:
            return HttpResponse("Error no se selecciono nunguna lista")

class ViewUpdateXlsxStep2(View):

    def post(self, request, *args, **kwargs):
        data = request.POST
        brute_data = {

            'codes': data.getlist('code'),
            'prices_auto': data.getlist('price_auto'),
            'price_percent': data.getlist('price_percent'),
            'price_manual_may': data.getlist('price_manual_may'),
            'price_manual_min': data.getlist('price_manual_min'),
            'xlsx_ids': data.getlist('xlsx_id'),

        }

        len_artics = len(brute_data['codes'])
        to_update = {}
        # ordeno todo en un diccionaraio para q sea mas fasil de tratar a posteriori
        for i in range(len_artics):
            to_update[brute_data['xlsx_ids'][i]][brute_data['codes'][i]] = {
                'price_auto': brute_data['prices_auto'][i],
                'price_percent': brute_data['price_percent'][i],
                'price_manual_may': brute_data['price_manual_may'][i],
                'price_manual_min': brute_data['price_manual_min'][i],
            }

        print(to_update)
        if len_artics == len(brute_data['prices_auto']) == len(brute_data['price_percent']) ==  len(brute_data['xlsx_ids']) == len(brute_data['price_manual_may']) == len(brute_data['price_manual_min']):
            for xlsx_id, xlsx_data in to_update.items():

                pass

            
                
        

        return HttpResponse("metodo post")

        
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
            for code, values in list_codes.items():
                code = code.strip().upper()
                current_artic = ModelArtic.objects.get(code=code)
                current_artic.col = values['col']
                current_artic.row = values['row']
                current_artic.listXlsxID = xlsx
                current_artic.save()
        else:
            print("el archivo no exites")

    return HttpResponse("echo")

