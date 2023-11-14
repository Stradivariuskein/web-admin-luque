from apps.core.tools.driver_manager import Drive_manager
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
             self.retry_execute(super().delete, fileDrive.driveId)

        try:
            if fileDrive.parentId.parentId.name == "ma" or fileDrive.parentId.name == "ma":
                response = self.retry_execute(super().upload, RUTE_XLSX_ORIGIN['ma'] + fileDrive.listXlsxID.name, fileDrive.parentId.driveId)
            elif fileDrive.parentId.parentId.name == "mi" or fileDrive.parentId.name == "mi":
                response = self.retry_execute(super().upload, RUTE_XLSX_ORIGIN['mi'] + fileDrive.listXlsxID.name, fileDrive.parentId.driveId)
        except Exception as e:
            print(f"error con el dirve: {e}")

        # da error porque se esta haciend o en hilos encontrar otra forma de subir los archvos y actualizar la base de datos
        if not isinstance(response,ModelFileDrive):
            fileDrive.driveId = response['id']
            #fileDrive.save()
            msj = f"output upload: {fileDrive}"
            return fileDrive       
        else:
            msj = f"output upload: {response}"
            return response
        

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

