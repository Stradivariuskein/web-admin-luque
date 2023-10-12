from django.contrib import admin
from .models import ModelListXlsx, ModelArtic, ModelListDrive, ModelToUpdateList
# Register your models here.


admin.site.register(ModelListXlsx)
admin.site.register(ModelArtic)
admin.site.register(ModelListDrive)
admin.site.register(ModelToUpdateList)