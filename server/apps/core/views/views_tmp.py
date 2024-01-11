from django.http import HttpResponse, JsonResponse

from apps.core.models import ModelListXlsx, ModelArtic, ModelFolderDrive, ModelFileDrive

from apps.core.tools.siaacTools import reed_artics
from apps.core.tools.xlsxTools import get_artcis_from_xlsx, list_xlsx_to_folder
from apps.core.tools.apiDriveV2 import ApiDrive
from googleapiclient.errors import HttpError

from configs import RUTE_XLSX_AGRUPS, ROOTS_DRIVE_IDS, RUTE_XLSX_ORIGIN, FILE_CREDENTIALS_DRIVE

from re import findall
from datetime import datetime
import os
import PyPDF2
import threading

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

            xlsx_file = ModelListXlsx(name=archivo, modDate=mod_date_file, pathLocal=local_rute_file)
            if xlsx_file:

                xlsx_file.save()

            filtered_archs.append(archivo)

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
    folder_name = 'LISTAS/'
    list_xlsx = ModelListXlsx.objects.all()
    lists_rute = os.path.join(os.path.abspath(folder_name), 'ma')
    
    for xlsx in list_xlsx:
        current_xlsx = os.path.join(lists_rute,xlsx.name)
        
        list_codes = get_artcis_from_xlsx(current_xlsx)
        if list_codes:

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



def tmp_view_duplicate_xlsx(request):
    
    files = ModelListXlsx.objects.all()
    drive = ApiDrive(FILE_CREDENTIALS_DRIVE, "1mupKCvLb4Gccpp2R9zx9vnylUVdIVgvW")
    new_files = []
    
    for file in files:
        id = ROOTS_DRIVE_IDS['common']
        folders = ModelFolderDrive.objects.filter(parentId=id)

        for folder in folders:
            folder = ModelFolderDrive.objects.filter(driveId=folder.driveId).first()
            if folder is not None:
                file_db = ModelFileDrive.objects.filter(name=file.name, parentId=folder, listXlsxID=file).first()
                if file_db is None:
                    new_file = ModelFileDrive(name=file.name, parentId=folder, listXlsxID=file)
                    driveId = drive.find_file_id_by_name(new_file.name, folder.driveId)
                    new_file.driveId = driveId
                    new_file.save()
                    new_files.append(new_file)

    return HttpResponse(new_files)

# recorrre todos los archivos de la db y verifica q solo alla 1 solo si hay mas los borra
def tmp_view_delet_duplicate_drive(request):
    drive = ApiDrive(FILE_CREDENTIALS_DRIVE)
    files = ModelFileDrive.objects.all()
    msj = []
    for file in files:
        files_drive = drive.find_file_id_by_name(file.name,parent_id=file.parentId.driveId)
        len_files = len(files_drive) 
        
        if len_files > 1:
            print("************************")
            print(len_files)
            print(files_drive)
            
            for i in range(len_files-1,0,-1): # bucle inverso dejando el primero
                tmp_file = ModelFileDrive(driveId=files_drive[i][0])
                drive.delete(tmp_file)
                print(f"i:\t{i}")
                msj.append(f"archivo eliminado:\t{files_drive[i]}")
                print(f"archivo eliminado:\t{files_drive[i]}")
                del files_drive[i]
            len_files = len(files_drive) 
            print(len_files)
            if len_files == 1:
                msj.append(files_drive)
                file.driveId = files_drive[0][0]
                file.save()
                print(files_drive)
                print(f"name:\t{file.name}\tid:\t{file.driveId}")
                msj.append(f"name:\t{file.name}\tid:\t{file.driveId}")
            print("************************")

        

        
        
    return HttpResponse(msj)
# cheque q el id del drive este bien si no puede acceder al archivo entonse lo busca por nombre en la carpeta padre y le reasigna el nuevo id
def view_check_drive_id(request):
    drive = ApiDrive(FILE_CREDENTIALS_DRIVE)
    files = ModelFileDrive.objects.all()
    not_funds = []
    for file in files:
        response = drive.get_file(file.driveId)
        # validar si el archivo esta en el drive si no esta hay q subirlo
        if not response:
            # falta validar si existe en la carpeta contenedora
            files_drive = drive.find_file_id_by_name(file_name=file.name, parent_id=file.parentId.driveId)
            if files_drive != []:
                len_files = len(files_drive) 
                print(f"files_drive tiene archivos para {file.name}")
        
                if len_files > 1:

                    print(f"files_drive mayor a 1")                    
                    for i in range(len_files-1,0,-1): # bucle inverso dejando el primero
                        tmp_file = ModelFileDrive(driveId=files_drive[i][0])
                        res_del = drive.delete(tmp_file)

                        del files_drive[i]
                        print(f"res_del: {res_del}")
                len_files = len(files_drive) 
                print(len_files)
                if len_files == 1:

                    file.driveId = files_drive[0][0]
                    file.save()
                    print(f"solo un archivo: {file.name}")

                   
            else:
                print(file.driveId)
                file = drive.upload(file)
                print(file.driveId)
                print(file)
                file.save()
            not_funds.append(file)

        

    return HttpResponse(not_funds)


def view_test(request):
    list_xlsx = ModelListXlsx.objects.all()
    msj = []
    for xlsx in list_xlsx:
        files_drive = ModelFileDrive.objects.filter(listXlsxID=xlsx)
        if 0 > len(files_drive) < 4:
            #files_drive.delete()
            print(files_drive)
            msj.append(f"{files_drive}")

    return HttpResponse(msj)

# a los articulos q no estene en el pdf (quiere decir q no se actualizan desde el 2019) pone el atributo active en false
def deactivate_artics(request):
    results_threads = []
    def find_code(artic, pdf_txt):
       
        response = {'deactivate': []}
        
        for page in pdf_txt:
            
    
            
            code_in_page = page.find(f'\n {artic.code.strip().upper()}')

            if code_in_page > -1:
                code_in_page += 2
                i = 0
                lines = page[code_in_page:].split('\n')
                if artic.code.strip() == 'T-240':
                    print(lines[0])
                len_lines = len(lines)-1
                while i <= len_lines:
                    line = lines[i]
                    if line[:fin_cod].strip().upper() == artic.code:

                        break
                    i += 1
                    
                else:
                    continue # si no lo encuentra continua con el for

                break # sale de bucle for si lo encuentra
        else:
            
            artic.active = False

            response['deactivate'].append(artic)
        results_threads.append(response)

    pdf_path = os.path.abspath('./PRICES-PDF/prices_L_5.pdf')
    fin_cod = 12

    response = {'deactivate': []}
    # Abre el archivo PDF en modo de lectura binaria
    with open(pdf_path, "rb") as file:
        # Crea un objeto PDFReader
        pdf_reader = PyPDF2.PdfReader(file)

        # Itera sobre todas las páginas del PDF
        artics = ModelArtic.objects.all()
        pdf_txt = []
        for page in pdf_reader.pages:
    
            pdf_txt.append(page.extract_text())
        

        threads = []

        for artic in artics:

            
            thread = threading.Thread(target=find_code, args=(artic, pdf_txt))
            threads.append(thread)
            thread.start()

        for thread in threads:
            thread.join()

        for res in results_threads:
            if res['deactivate'] != []:
                res['deactivate'][0].save()
                response['deactivate'] += res['deactivate'] 
    print(len(response['deactivate']))
    return HttpResponse("termino")


def view_tmp_priceXlsx(request):
    # lista todos los archivo q termina en .xlsx en una ruta
    paths = list_xlsx_to_folder(RUTE_XLSX_ORIGIN['ma'])
    response = {}
    for path in paths:
        artics = get_artcis_from_xlsx(path)
        for code, artic in artics.items():
            code = code.strip().upper()
            if not artic['price']:
                db_artic = ModelArtic.objects.filter(code=code).first()
                db_artic.priceXlsx = False
                db_artic.save()
                response[code] = False


    return JsonResponse(response)
