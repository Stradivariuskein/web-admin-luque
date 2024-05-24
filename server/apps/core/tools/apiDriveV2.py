from apps.core.tools.driver_manager import Drive_manager
from googleapiclient.errors import HttpError
from httplib2.error import ServerNotFoundError
from google.auth.exceptions import TransportError

from apps.core.models import ModelFileDrive, ModelFolderDrive, ModelListXlsx
from configs import RUTE_XLSX_ORIGIN, ROOTS_DRIVE_IDS


import os
import time

class ApiDrive(Drive_manager):

    def retry_execute(self, func, *args, **kwargs):
        max_retries = 3
        wait_time = 4

        for i in range(max_retries):

            try:
                result = func(*args, **kwargs)
                return result
            except ServerNotFoundError:
                i=0
                time.sleep(wait_time)
            except TransportError:
                i=0
                time.sleep(wait_time)
            except Exception as e:
                time.sleep(wait_time)
            

        raise Exception("No se pudo ejecutar la función después de varios intentos.")

    def upload(self, fileDrive: ModelFileDrive, resetDrive = False):
        
        # elimina el archivo viejo
        if fileDrive.driveId:
            self.retry_execute(super().delete, fileDrive.driveId)

        # verifica q el archivo se alla elmininado
        exist_in_drive = self.find_file_id_by_name(fileDrive.name, fileDrive.parentId.driveId)
        if exist_in_drive != []:
            for driveId, _ in exist_in_drive:
              self.retry_execute(super().delete, driveId)
        try:
            if not resetDrive:
                # si la carpeta padre es 'ma' es precio mayorista si es 'mi' es precio minorista
                if fileDrive.parentId.parentId.name.lower() == "ma" or fileDrive.parentId.name.lower() == "ma":
                    response = self.retry_execute(super().upload, os.path.abspath(RUTE_XLSX_ORIGIN['ma'] + fileDrive.listXlsxID.name), fileDrive.parentId.driveId)
                elif fileDrive.parentId.parentId.name.lower() == "mi" or fileDrive.parentId.name.lower() == "mi":
                    response = self.retry_execute(super().upload, os.path.abspath(RUTE_XLSX_ORIGIN['mi'] + fileDrive.listXlsxID.name), fileDrive.parentId.driveId)
            
            else: # resube el archivo mantentiendo la estructura de carpetas con respecto a el driveID seteados en configs.py
            
                # si la carpeta padre es 'ma' es precio mayorista si es 'mi' es precio minorista
                # otenemos el id de la carpeta donde se tiene q subir
                if fileDrive.parentId.parentId.name.lower() == "ma" or fileDrive.parentId.name.lower() == "ma":

                    search_results = self.find_file_id_by_name("MA",ROOTS_DRIVE_IDS['order'])

                    if search_results:
                        search_results = self.find_file_id_by_name(fileDrive.parentId.name,search_results[0][0])

                        if search_results:
                            parent_drive_ids = search_results[0][0]

                    response = self.retry_execute(super().upload, os.path.abspath(RUTE_XLSX_ORIGIN['ma'] + fileDrive.listXlsxID.name), parent_drive_ids)

                # otenemos el id de la carpeta donde se tiene q subir
                elif fileDrive.parentId.parentId.name.lower() == "mi" or fileDrive.parentId.name.lower() == "mi":
                    
                    search_results = self.find_file_id_by_name("MI",ROOTS_DRIVE_IDS['order'])

                    if search_results:
                        search_results = self.find_file_id_by_name(fileDrive.parentId.name,search_results[0][0])
                        
                        if search_results:
                            parent_drive_ids = search_results[0][0]

                    response = self.retry_execute(super().upload, os.path.abspath(RUTE_XLSX_ORIGIN['ma'] + fileDrive.listXlsxID.name), parent_drive_ids)
                    

        except Exception as e:
            with open("debug_api_drvie.txt", 'w') as out_file:
                    out_file.write(f"Error en apiDriveV2.upload ({type(e).__name__}): {e}")
                
        
        if (not isinstance(response,HttpError) and not isinstance(response,ServerNotFoundError)):
            
            fileDrive.driveId = response['id']
            return fileDrive       
        else:
            return {'response': response, 'file': fileDrive}
        

    def delete(self, fileDrive: ModelFileDrive):
        response = self.retry_execute(super().delete, fileDrive.driveId)
        if isinstance(response,HttpError):
            result =  self.retry_execute(super().find_file_id_by_name, file_name=fileDrive.name, parent_id=fileDrive.parentId.driveId)
            if result:
                response =  self.retry_execute(super().delete, fileDrive.driveId)
        return response

    def get_file(self, drive_id: str):
        return self.retry_execute(super().get_file, drive_id)



if __name__ == '__main__':

    drive = ApiDrive("../service_account.json", "1TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi")
    xlsx = ModelListXlsx.objects.filter(id="104").first()
    folderDrive = ModelFolderDrive(driveId='TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi')
    fileDrive = ModelFileDrive(driveId="1Wx8UxcGkuYtBcky8FKI5MZibRd1fpGlh",parentId=folderDrive, listXlsxID=xlsx, name=xlsx.name)
    file = drive.retry_execute(drive.upload, fileDrive)
    print(file)
    result = drive.delete('1Wx8UxcGkuYtBcky8FKI5MZibRd1fpGlh')

