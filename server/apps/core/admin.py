from django.contrib import admin
from .models import ModelListXlsx, ModelArtic, ModelFileDrive, ModelFolderDrive, ModelToUpdateList, ModelToUploadDrive
# Register your models here.


admin.site.register(ModelListXlsx)
admin.site.register(ModelArtic)
admin.site.register(ModelFolderDrive)
admin.site.register(ModelFileDrive)
admin.site.register(ModelToUpdateList)
admin.site.register(ModelToUploadDrive)