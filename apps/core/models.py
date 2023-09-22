from django.db import models

import re
from datetime import datetime
from xlsxTools import es_numero
from openpyxl import load_workbook
# Create your models here.



class ListaXlsx(models.Model):
    nombre = models.CharField(max_length=100)
    driveId = models.CharField(max_length=150)
    modDate = models.DateField()
    img = models.ImageField(upload_to='media/img/artics/')
    artics = models.CharField(max_length=5000)
    pathlocal = models.CharField(max_length=500, default="")

    def _get_artics(self):
        #recorre la hoja 1 del libro de excel en busca de los codigos, descripcion y precios
        borkbook = load_workbook(self.pathXlsx)
        try:
            sh = borkbook['Hoja1']
        except:
            print ("Error no exixte la Hoja1 en el archivo excel!!!!")
    
        cell=""
        row=0
        columna = 1


        maxFila = sh.max_row
        artics = {}
        for row in range(1,maxFila):
            cell=str(sh.cell(row=row,column=columna).value).upper()
        
            celda_cod = str(cell).upper()
            
            
            if celda_cod == "COD" or celda_cod == "COD.":

                row += 1
                cell=str(sh.cell(row=row,column=columna).value).upper()
                result = re.findall(f"[A-Z]-", cell)

                while result:
                    description = str(sh.cell(row=row,column=columna+1).value).upper
                    artics[cell] = {'description': description}
                    precioActual = str(sh.cell(row=row,column=columna+3).value)
                    if es_numero(precioActual):
                        artics[cell]['price'] = float(precioActual)
                    else:
                        artics[cell]['price'] = '-'

        return artics
                        
                    




class Artic(models.Model):
    code = models.CharField(max_length=10)
    description = models.CharField(max_length=150)
    priceMa = models.FloatField()
    priceMi = models.FloatField()





