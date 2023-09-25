from django.db import models

import re
from datetime import datetime
from xlsxTools import es_numero
from openpyxl import load_workbook
# Create your models here.



class ListXlsx(models.Model):
    name = models.CharField(max_length=100)
    driveId = models.CharField(max_length=150)
    modDate = models.DateField()
    img = models.ImageField(upload_to='media/img/artics/', null=True, blank=True)
    pathlocal = models.CharField(max_length=500, default="")


class Artic(models.Model):
    code = models.CharField(max_length=10)
    description = models.CharField(max_length=150)
    priceMa = models.FloatField()
    priceMi = models.FloatField()
    listXlsxID = models.ForeignKey(ListXlsx,on_delete=models.SET_NULL, null=True)


class ListDrive(models.Model):
    filrId = models.CharField(max_length=50)
    parenId = models.CharField(max_length=50)
    listXlsxID = models.ForeignKey(ListXlsx,on_delete=models.SET_NULL, null=True)


