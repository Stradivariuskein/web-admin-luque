from googleapiclient.discovery import build
from google.oauth2 import service_account
from googleapiclient.http import MediaFileUpload
from googleapiclient.errors import HttpError

import os
from apps.core.models import ModelFolderDrive
from django.db.models import Q

SCOPES = ['https://www.googleapis.com/auth/drive']
SERVICE_ACCOUNT_FILE = 'service_account.json'
FOLDER_ID = "1mupKCvLb4Gccpp2R9zx9vnylUVdIVgvW"

class Drive_manager():
    def __init__(self, cred_file):
         self.creds = service_account.Credentials.from_service_account_file(cred_file, scopes=SCOPES)
         self.service = build('drive', 'v3', credentials=self.creds)
         self.folder_id = "1mupKCvLb4Gccpp2R9zx9vnylUVdIVgvW"


    def get_file(self, id):
        try:
            result = self.service.files().get(
                fileId=id,
                fields="id, name, mimeType, parents, modifiedTime"
                ).execute()
        except HttpError:
            return None
        return result

    def list_drive(self, parent_id=None, query=None):
        if not query:
            query = ""

        if parent_id is None:
            folders_drive = ModelFolderDrive.objects.filter(Q(name='ma') | Q(name='mi'))
            results = []
            for parent_id in folders_drive:
                
                
                query = f"'{parent_id}' in parents"
                results += self.service.files().list(
                q=query,
                pageSize=500,
                fields="nextPageToken, files(id, name, mimeType, parents, modifiedTime)"
                ).execute().get('files', [])

                

        else:
            results = self.service.files().list(
                q=f"'{parent_id}' in parents",
                pageSize=500,
                fields="nextPageToken, files(id, name, mimeType, parents, modifiedTime)"
                ).execute().get('files', [])
        all_files = {}
        for element in results:
            if not element['id'] in all_files:
                all_files[element['id']] = element
        return all_files


    def find_file_id_by_name(self, file_name, parent_id=None): # retorna el id del archivo segun el nombre
        # si no le pas el parent busca en la raiz de forma No recursiva
        if not parent_id:
            parent_id = self.folder_id
        files = self.list_drive(parent_id=parent_id)
        
        maches = []
        for id, file in files.items():       
            if file['name'] == file_name and file['parents'][0] == parent_id:
                maches.append((file['id'], file['name']))
        return maches
    

    def upload(self, file_path, folder_id):
        # falta verificar si ya existe un archivo con el mismo nombre
        try:
            file_name = os.path.basename(file_path)
            exist_file = self.get_file(folder_id)

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
            print(f"error drive.upload: {e} {file_path}")
            return e


    
    def delete(self,driveId):
        try:
            response = self.service.files().delete(fileId=driveId).execute()

        except Exception as e:
            print(f"Error con el srvidor [{type(e).__name__}].\n {e}")
            response = e

        return response



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

        



if __name__ == "__main__":
    drive = Drive_manager("../service_account.json", "1TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi")
    file = drive.upload("./test.txt", "1TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi")
    print(file)


    