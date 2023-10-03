from django.db import models

import re
from datetime import datetime
from xlsxTools import es_numero
from openpyxl import load_workbook
# Create your models here.

class ModelListXlsx(models.Model):
    name = models.CharField(max_length=100)
    driveId = models.CharField(max_length=150, null=True, blank=True)
    modDate = models.DateField()
    img = models.ImageField(upload_to='media/img/artics/', null=True, blank=True)
    pathLocal = models.CharField(max_length=500, default="")

    def __str__(self) -> str:
        return f"{self.id}, {self.name}, {self.modDate}, {self.pathLocal}"

class ModelArtic(models.Model):
    code = models.CharField(max_length=10)
    description = models.CharField(max_length=150)
    priceMa = models.FloatField()
    priceMi = models.FloatField()
    listXlsxID = models.ForeignKey(ModelListXlsx,on_delete=models.SET_NULL, null=True)

    def __str__(self) -> str:
        return f"{self.code}: {self.description}"

    # indexo el campo code
    class Meta:
        indexes = [
            models.Index(fields=['code', 'listXlsxID'])
        ]

class ModelListDrive(models.Model):
    filrId = models.CharField(max_length=50)
    parenId = models.CharField(max_length=50)
    listXlsxID = models.ForeignKey(ModelListXlsx,on_delete=models.SET_NULL, null=True)


