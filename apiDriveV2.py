from driver_manager import Drive_manager

from apps.core.models import ModelFileDrive, ModelFolderDrive, ModelListXlsx
from configs import RUTE_XLSX_ORIGIN

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
            result = super().delete(fileDrive.driveId)
            print(result)

        if fileDrive.parentId.parentId.name == "ma" or fileDrive.parentId.name == "ma":
            response = super().upload( RUTE_XLSX_ORIGIN['ma'] + fileDrive.listXlsxID.name, fileDrive.parentId.driveId)
        elif fileDrive.parentId.parentId.name == "mi" or fileDrive.parentId.name == "mi":
            response = super().upload( RUTE_XLSX_ORIGIN['mi'] + fileDrive.listXlsxID.name, fileDrive.parentId.driveId)
        if not isinstance(response,FileNotFoundError):
            fileDrive.driveId = response['id']
            return fileDrive
        else:
            return response


if __name__ == '__main__':

    drive = ApiDrive("../service_account.json", "1TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi")
    xlsx = ModelListXlsx.objects.filter(id="104").first()
    folderDrive = ModelFolderDrive(driveId='TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi')
    fileDrive = ModelFileDrive(driveId="1Wx8UxcGkuYtBcky8FKI5MZibRd1fpGlh",parentId=folderDrive, listXlsxID=xlsx, name=xlsx.name)
    file = drive.retry_execute(drive.upload, fileDrive)
    print(file)
    result = drive.delete('1Wx8UxcGkuYtBcky8FKI5MZibRd1fpGlh')

