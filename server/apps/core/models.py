from django.db import models




# Create your models here.





class ModelFolderDrive(models.Model):
    parentId = models.ForeignKey(to='self', blank=True, on_delete=models.SET_NULL, null=True) # id de la carpeta condetnedora del drive
    driveId = models.CharField(max_length=50)
    name = models.CharField(max_length=300, default="")

    def __str__(self) -> str:
        return f"{self.driveId}"

# representa un archivo de lista de precio xlsx
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
    row = models.IntegerField(default=0)
    col = models.IntegerField(default=0)
    active = models.BooleanField(default=True)
    priceXlsx = models.BooleanField(default=True) # si es verdadero se agrega el precio a la lista excel sino se ponen astericos(*)

    def __str__(self) -> str:
        return f"{self.code},{self.description},{self.row},{self.col},may: {self.priceMa}, min: {self.priceMi}"

    # indexo el campo code
    # aumenta el rendimiento en la db
    class Meta:
        indexes = [
            models.Index(fields=['code', 'listXlsxID'])
        ]


class ModelFileDrive(models.Model):
    parentId = models.ForeignKey(to=ModelFolderDrive, on_delete=models.SET_NULL, null=True) # id de la carpeta condetnedora del drive
    listXlsxID = models.ForeignKey(ModelListXlsx,on_delete=models.SET_NULL, null=True)
    name = models.CharField(max_length=300, default="")
    driveId = models.CharField(max_length=50)

    def __str__(self) -> str:
        name = self.name
        driveId = self.driveId
        return f"name: {name}"
    

class ModelToUploadDrive(models.Model):
    fileDrive = models.ForeignKey(to=ModelFileDrive, on_delete=models.SET_NULL, null=True)
    





# lista con los archivos q se nesesitan actualizar
class ModelToUpdateList(models.Model):
    xlsxId = models.ForeignKey(ModelListXlsx,on_delete=models.SET_NULL, null=True)

