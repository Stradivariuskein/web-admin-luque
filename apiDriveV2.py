from googleapiclient.errors import HttpError
from driver_manager import Drive_manager

#from apps.core.models import ModelFileDrive, ModelFolderDrive, ModelListXlsx

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

    #def upload(self, fileDrive: ModelFileDrive):
    #    if fileDrive.driveId:
    #        result = super().delete(fileDrive.driveId)
    #        print(result)
    #    response = super().upload( fileDrive.listXlsxID.pathLocal, fileDrive.parentId.driveId)
    #    fileDrive.driveId = response['id']
    #    return fileDrive


if __name__ == '__main__':

    drive = ApiDrive("../service_account.json", "1TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi")
    #xlsx = ModelListXlsx.objects.filter(id="104").first()
    #folderDrive = ModelFolderDrive(driveId='1TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi')
    #fleDrive = ModelFileDrive(driveId="1Wx8UxcGkuYtBcky8FKI5MZibRd1fpGlh",parentId=folderDrive, listXlsxID=xlsx, name=xlsx.name)
    #file = drive.retry_execute(drive.upload, fileDrive)
    #print(file)
    result = drive.delete("1XasBmrd3R3KJDTmqJt7NWLfNzI5Hgyak")