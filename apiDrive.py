from googleapiclient.discovery import build
from google.oauth2 import service_account
from googleapiclient.http import MediaFileUpload
from googleapiclient.errors import HttpError

from anytree import Node, RenderTree, TreeError

import time

import os

from driver_manager import Drive_manager

SCOPES = ['https://www.googleapis.com/auth/drive']
SERVICE_ACCOUNT_FILE = 'service_account.json'
FOLDER_ID = "1mupKCvLb4Gccpp2R9zx9vnylUVdIVgvW"

class ApiDriver(Drive_manager): # utiliza los mismo metodos pero agrega 
                                  # mas intentos para ejecutar los metodos 
                                  # por si falla la conexion con el sertvidor

    def retry_execute(self, func, *args, **kwargs):
        max_retries = 3
        wait_time = 4

        for i in range(max_retries):
            #print(f"Intento {i + 1}")
            try:
                result = func(*args, **kwargs)
                return result
            except Exception as e:
                print(e)
                time.sleep(wait_time)

        raise Exception("No se pudo ejecutar la función después de varios intentos.")

    def ma_or_mi(self, parent_id):

        while True:
            try:
                parent = self.get_file(parent_id)
                if parent['name'] == "MA" or parent['name'] == "MA":
                    return parent['name']
                else:
                    parent_id = parent['parents'][0]

            except HttpError:
                return None
            except KeyError:
                return None

    def list_files(self, folderDrive=None, query=None):
        if folderDrive:
            files = self.retry_execute(super().list_files, folder_id=folderDrive.id, query=query)
        else:
            files = self.retry_execute(super().list_files, folder_id=None, query=query)
        listDrive = []
        max = len(files)
        for i in range(0,max,4): # listo de a varios para aumentar el rendimiento en cada iteracion
            file1 = files[i]
            file2 = files[i+1]
            file3 = files[i+2]
            file4 = files[i+3]

            ma_mi1 = self.ma_or_mi(file1['parents'][0])
            ma_mi2 = self.ma_or_mi(file2['parents'][0])
            ma_mi3 = self.ma_or_mi(file3['parents'][0])
            ma_mi4 = self.ma_or_mi(file4['parents'][0])
            #if 1
            if ma_mi1:
                if file1['mimeType'] == 'application/vnd.google-apps.folder':
                    
                    listDrive.append(FolderDrive(file1, ma_mi1, "C:/ruta/drive" ))
                elif file1['mimeType'] == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
                    
                    listDrive.append(FileDrive(file1, ma_mi1, "C:/ruta.xlsx" ))
            # if 2
            if ma_mi2:
                if file2['mimeType'] == 'application/vnd.google-apps.folder':
                    
                    listDrive.append(FolderDrive(file2, ma_mi2, "C:/ruta/drive" ))
                elif file2['mimeType'] == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
                    
                    listDrive.append(FileDrive(file2, ma_mi2, "C:/ruta.xlsx" ))
            # if 3
            if ma_mi3:
                if file3['mimeType'] == 'application/vnd.google-apps.folder':
                    
                    listDrive.append(FolderDrive(file3, ma_mi3, "C:/ruta/drive" ))
                elif file3['mimeType'] == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
                    
                    listDrive.append(FileDrive(file3, ma_mi3, "C:/ruta.xlsx" ))
            #if 4
            if ma_mi4:
                if file4['mimeType'] == 'application/vnd.google-apps.folder':
                    
                    listDrive.append(FolderDrive(file4, ma_mi4, "C:/ruta/drive" ))
                elif file4['mimeType'] == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
                    
                    listDrive.append(FileDrive(file4, ma_mi4, "C:/ruta.xlsx" ))
        return listDrive
    

    def find_file_id_by_name(self, file_name, parent_id=None, ma_or_mi="ma"): # retorna el id del archivo segun el nombre
        # si no le pas el parent busca en la raiz de forma recursiva
        if not parent_id:
            if ma_or_mi.lower()=="ma":
                parent_id = "1y2YN7CzBK0epT9gXoWBuDUl140HcNgS6"
            elif ma_or_mi.lower()=="mi":
                parent_id = "1Ef-8smVEoSFBWCznDFqqcx04NQync3yK"
            
        files = self.list_files(parent_id)
        folders = []
        for file in files:
            if file["name"] == file_name:
                return file["id"]
            if file["mimeType"] == 'application/vnd.google-apps.folder':
                folders.append(file["id"])


        for folder in folders:
            result = self.find_file_id_by_name(file_name=file_name, parent_id=folder)
            if result:
                return result

        return None

    def upload(self, fileDrive):
        return self.retry_execute(super().upload, fileDrive.localRute, fileDrive.id)

    def delete(self, file_name):
        return self.retry_execute(super().delete, file_name)

    # actualiza un archivo existente en el drive si no se le pasa el file_id 
    # busca de forma recursiva desde la raiz
    def upgrade(self, fileDrive):
        if not fileDrive.id:
            file_id = self.find_file_id_by_name(fileDrive.name,ma_or_mi=fileDrive.ma_mi)
            if not file_id:
                raise FileNotFoundError("El archivo no existe en el drive")
        return self.retry_execute(super().upgrade, fileDrive.localRute, fileDrive.id)

    def create_folder(self, folder_name, parent_folder_id=None):
        return self.retry_execute(super().upgrade,  folder_name, parent_folder_id=parent_folder_id)

    def clone_folder(self, source_folder_path, target_parent_folder_id):
        up_something = False



class FileDrive:
    def __init__(self, dic_file, ma_mi, localRute) -> None:
        self.id = dic_file['id']
        self.name = dic_file['name']
        self.parent = dic_file['parents'][0]
        self.mimeType = dic_file['mimeType']
        self.modTime = dic_file['modifiedTime']
        self.ma_mi = ma_mi #mayorista (ma) o minorita (mi)
        self.localRute = localRute
    
    def __str__(self) -> str:
        return f"Id:\t{self.id}\nName:\t{self.name}\nMa_mi:\t{self.ma_mi}\nModifi:\t{self.modTime}\n"


class FolderDrive(FileDrive):

     def __init__(self, dic_file, ma_mi, localRute, driverManager) -> None:
        super. __init__(self, dic_file, ma_mi, localRute)

        self.node = Node(self.id)
        childrens = driverManager.listFiles(folderDrive=self)
        aux_list = []
        for child in childrens:
            aux_list.append(child[id])
        
        self.childrens = aux_list

    

        
if __name__ == '__main__':
    api = ApiDriver("service_account.json", "1TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi")

    files = api.list_files()

    for file in files:
        print(file)
        print()