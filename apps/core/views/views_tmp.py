from django.http import HttpResponse

from apps.core.models import ModelListXlsx, ModelArtic, ModelFolderDrive, ModelFileDrive

from apps.core.tools.siaacTools import reed_artics
from apps.core.tools.xlsxTools import get_artcis_from_xlsx
from apps.core.tools.apiDriveV2 import ApiDrive
from googleapiclient.errors import HttpError

from configs import RUTE_XLSX_AGRUPS, ROOTS_DRIVE_IDS

from re import findall
from datetime import datetime
import os

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
    list_xlsx = ModelListXlsx.objects.all()
    lists_rute = '/home/mrkein/Documentos/python/web-admin-luque/web-admin-luque/LISTAS/'
    
    for xlsx in list_xlsx:
        current_xlsx = f"{lists_rute}{xlsx.name}"
        
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
    drive = ApiDrive("../service_account.json", "1mupKCvLb4Gccpp2R9zx9vnylUVdIVgvW")
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
    drive = ApiDrive("../service_account.json")
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
# cheque q el id del drive este bien si no puede scceder al archivo entonse lo busca por nombre eb la carpeta padre y le reasigna el nuevo id
def view_check_drive_id(request):
    drive = ApiDrive("../service_account.json")
    files = ModelFileDrive.objects.all()
    not_funds = []
    for file in files:
        response = drive.get_file(file.driveId)
        if isinstance(response, HttpError):
            not_funds.append(file)
            files_drive = drive.find_file_id_by_name(file.name,parent_id=file.parentId.driveId)
            len_files = len(files_drive) 
            if len_files > 1:
                print("************************")
                print(len_files)
                print(files_drive)
                
                for i in range(len_files-1,0,-1): # bucle inverso dejando el primero
                    tmp_file = ModelFileDrive(driveId=files_drive[i][0])
                    drive.delete(tmp_file)
                    print(f"archivo eliminado:\t{files_drive[i]}")
                    del files_drive[i]
                len_files = len(files_drive) 

                if len_files == 1:
                    file.driveId = files_drive[0][0]
                    file.save()
                    print(files_drive)
                    print(f"name:\t{file.name}\tid:\t{file.driveId}")

                print("************************")
            else:
                print("************************")
                file.driveId = files_drive[0][0]
                file.save()
                print(files_drive)
                print(f"name:\t{file.name}\tid:\t{file.driveId}")
                print("************************")

        

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