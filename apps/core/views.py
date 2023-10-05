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
                xlsx_forms = []
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
                    xlsx_forms.append((artic,form))



                current_xlsx = {
                    'list_ID': xlsx[0],
                    'list_name': xlsx[1],
                    'artics': xlsx_forms
                    }
                xlsx_and_artics.append(current_xlsx)
                
            
            return render(request, 'core/update_xlsx_step.html', {'listXlsx': xlsx_and_artics})
        else:
            return HttpResponse("Error no se selecciono nunguna lista")

class ViewUpdateXlsxStep2(View):

    def post(self, request, *args, **kwargs):
        data = request.POST
        codes = data['code']
        prices_auto = request.POST['price_auto']
        price_percent = request.POST['price_percent']
        price_manual = {'ma': request.POST['price_manual_may'], 'mi': request.POST['price_manual_min']}
        xlsx_ids = request.POST['xlsx_id']
        len_artics = len(codes)

        
        print(f"\n\n{len_artics} == {len(prices_auto)} == {len(price_percent)} ==  {len(price_manual['ma'])} == {len(price_manual['mi'])} == {len(xlsx_ids)}\n\n")

        print(f'{data["code"]}')
        print(prices_auto)
        print(price_percent)
        for i in range(len_artics):
            #print(f"codigo: {codes[i]}\tAutomatico: {prices_auto[i]}\tPorcentaje: {price_percent[i]}\tMayorista:{price_manual['ma'][i]}\tMinorista: {price_manual['mi'][i]}")
            if not prices_auto:
                if price_percent[i] > 0:
                    # updateXlsx(percent)
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
            for code in list_codes:
                code = code.strip().upper()
                current_artic = ModelArtic.objects.get(code=code)
                current_artic.listXlsxID = xlsx
                current_artic.save()
        else:
            print("el archivo no exites")

    return HttpResponse("echo")

