from googleapiclient.discovery import build
from google.oauth2 import service_account
from googleapiclient.http import MediaFileUpload

from googleapiclient.errors import HttpError

import time

import os
from apps.core.models import ModelFolderDrive

SCOPES = ['https://www.googleapis.com/auth/drive']
SERVICE_ACCOUNT_FILE = 'service_account.json'
FOLDER_ID = "1mupKCvLb4Gccpp2R9zx9vnylUVdIVgvW"



def retry_send(self, func):
    def custom(self, *args, **kwargs):
        max_retries = 3
        wait_time = 4

        for i in range(max_retries):
            print(f"Intento {i + 1}")
            try:
                result = func(self, *args, **kwargs)
                return result
            except Exception as e:
                print(e)
                time.sleep(wait_time)

        raise Exception("No se pudo ejecutar la función después de varios intentos.")

    return custom


class Drive_manager():
    def __init__(self, cred_file, folder_id):
         self.creds = service_account.Credentials.from_service_account_file(cred_file, scopes=SCOPES)
         self.service = build('drive', 'v3', credentials=self.creds)
         self.folder_id = folder_id


    def get_file(self, id):

        result = self.service.files().get(
            fileId=id,
            fields="id, name, mimeType, parents, modifiedTime"
            ).execute()
        return result

    def list_drive(self, parent_id=None, query=None):
        
        if not parent_id:
            folders_drive = ModelFolderDrive.objects.all()
            print(folders_drive)
            results = []
            for parent_id in folders_drive:
                
                if not query:
                    query = f"'{parent_id}' in parents"
                results += self.service.files().list(
                q=query,
                pageSize=500,
                fields="nextPageToken, files(id, name, mimeType, parents, modifiedTime)"
                ).execute().get('files', [])
                print(parent_id)
                print(results)
                

        else:
            results = self.service.files().list(
                q=f"'{parent_id}' in parents",
                pageSize=500,
                fields="nextPageToken, files(id, name, mimeType, parents, modifiedTime)"
                ).execute().get('files', [])
        all_files = {}
        for element in results:
            if not element['id'] in all_files.items():
                all_files[element['id']] = element
        return all_files


    def list_files(self, folder_id=None, query=None):
        # hace una consulta a google para obtener 
        # los archivos q esten dentro de folrder_id
        # si no se le pasa el folder_id busca en todod el drive
        # y retornarna todos los archivos excels (.xlsx)
        if not query:
            query = f"name contains '.xlsx'"
        if not folder_id:
            results = self.service.files().list(
            q=query,
            pageSize=500,
            fields="nextPageToken, files(id, name, mimeType, parents, modifiedTime)"
            ).execute()
        else:
            try:
                results = self.service.files().list(
                q=f"'{folder_id}' in parents",
                pageSize=200,
                fields="nextPageToken, files(id, name, mimeType, parents, modifiedTime)"
                ).execute()                
            except HttpError:
                print(f"Error la carpeta con id: {folder_id} no exite")
                results = None

        # Get the results
        if results:
            items = results.get('files', [])
        else:
            items = []
        
        return items

    
    ###############################################################
    # reformula logica para q sea recursiva
    ###############################################################
    def find_file_id_by_name(self, file_name, parent_id=None): # retorna el id del archivo segun el nombre
        # si no le pas el parent busca en la raiz de forma No recursiva
        if not parent_id:
            parent_id = self.folder_id
        files = self.list_files(folder_id=parent_id)
        for file in files:            
            if file['name'] == file_name and file['parents'][0] == parent_id:
                return file['id']
        return None
    

    def upload(self, file_path, folder_id):
        
        try:
            file_name = os.path.basename(file_path)

            file_metadata = {
                'name' : file_name,
                'parents' : [folder_id]
            }
            media = MediaFileUpload(file_path, resumable=True)

            file = self.service.files().create(
                body=file_metadata,
                media_body=media,
                fields="id"
            ).execute()
            return file
        except Exception as e:
            return e


    
    def delete(self,driveId):
        try:
            response = self.service.files().delete(fileId=driveId).execute()
            print("archivo eliminado")

        except Exception as e:
            print(f"Error con el srvidor [{type(e).__name__}].\n {e}")
            response = e

        return response


    def upgrade(self, file_path, file_id):
        # si no se epecifica folder_id lo busca en todo el drive
        try:
            file_name = os.path.basename(file_path)


            file_metadata = {
                'name': file_name,
                #'parents': parent
            }

            #self.delete(file_name)
            
            media = MediaFileUpload(file_path, resumable=True)

            file = self.service.files().update(
                fileId=file_id,  # Establecer el fileId del archivo a actualizar
                body=file_metadata,
                media_body=media,
                fields='id'
            ).execute()
            return file
        except:
            return None


    def create_folder(self, folder_name, parent_folder_id=None):
        try:
            folder_metadata = {
                'name': folder_name,
                'mimeType': 'application/vnd.google-apps.folder'
            }

            if parent_folder_id:
                folder_metadata['parents'] = [parent_folder_id]

            folder = self.service.files().create(
                body=folder_metadata,
                fields='id'
            ).execute()

            return folder.get('id')
        except:
            return None

    def clone_folder(self, source_folder_path, target_parent_folder_id):
        # Subir/copiar archivos de la carpeta actual al target_parent_folder
        for file_name in os.listdir(source_folder_path):
            if file_name.endswith('.xlsx'):
                file_path = os.path.join(source_folder_path, file_name)

                # Buscar si el archivo ya existe en Google Drive
                existing_file_id = self.find_file_id_by_name(file_name, parent_id=target_parent_folder_id)
                
                if existing_file_id:
                    # Si existe, utilizar la función upgrade
                    self.upgrade(file_path, existing_file_id)
                else:
                    # Si no existe, utilizar la función upload
                    self.upload(file_path, target_parent_folder_id)

        # Recorrer las subcarpetas
        for dir_name in os.listdir(source_folder_path):
            dir_path = os.path.join(source_folder_path, dir_name)
            if os.path.isdir(dir_path):

                # Crear una nueva carpeta en el target_parent_folder
                existing_folder = self.find_file_id_by_name(dir_name, self.folder_id)
                if existing_folder:
                    new_folder_id = existing_folder
                else:
                    new_folder_id = self.create_folder(dir_name, target_parent_folder_id)
                
                # Llamada recursiva con la nueva carpeta creada como destino
                self.clone_folder(dir_path, new_folder_id)

        return target_parent_folder_id
        



if __name__ == "__main__":
    drive = Drive_manager("../service_account.json", "1TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi")
    file = drive.upload("./test.txt", "1TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi")
    print(file)


    