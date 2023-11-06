from driver_manager import Drive_manager
from googleapiclient.errors import HttpError

from apps.core.models import ModelFileDrive, ModelFolderDrive, ModelListXlsx
from configs import RUTE_XLSX_ORIGIN
import multiprocessing

import time

class ApiDrive(Drive_manager):

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

    def upload(self, fileDrive: ModelFileDrive):
        if fileDrive.driveId:
            super().delete(fileDrive.driveId)


        if fileDrive.parentId.parentId.name == "ma" or fileDrive.parentId.name == "ma":
            response = super().upload( RUTE_XLSX_ORIGIN['ma'] + fileDrive.listXlsxID.name, fileDrive.parentId.driveId)
        elif fileDrive.parentId.parentId.name == "mi" or fileDrive.parentId.name == "mi":
            response = super().upload( RUTE_XLSX_ORIGIN['mi'] + fileDrive.listXlsxID.name, fileDrive.parentId.driveId)
        # da error porque se esta haciend o en hilos encontrar otra forma de subir los archvos y actualizar la base de datos
        if not isinstance(response,FileNotFoundError):
            fileDrive.driveId = response['id']
            #fileDrive.save()
            return fileDrive                
        else:
            return response
        
    def delete(self, fileDrive: ModelFileDrive):
        response = super().delete(fileDrive.driveId)
        if isinstance(response,HttpError):
            result = super().find_file_id_by_name(file_name=fileDrive.name, parent_id=fileDrive.parentId.driveId)
            if result:
                response = super().delete(fileDrive.driveId)
        return response


def upload_drive_and_update_db(files_drive: ModelFileDrive, api_drive: ApiDrive):
    processes = []
    for file in files_drive:
        process = multiprocessing.Process(target=drive.upload, args=(file,))
        processes.append(process)
        process.start()


if __name__ == '__main__':

    drive = ApiDrive("../service_account.json", "1TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi")
    xlsx = ModelListXlsx.objects.filter(id="104").first()
    folderDrive = ModelFolderDrive(driveId='TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi')
    fileDrive = ModelFileDrive(driveId="1Wx8UxcGkuYtBcky8FKI5MZibRd1fpGlh",parentId=folderDrive, listXlsxID=xlsx, name=xlsx.name)
    file = drive.retry_execute(drive.upload, fileDrive)
    print(file)
    result = drive.delete('1Wx8UxcGkuYtBcky8FKI5MZibRd1fpGlh')

