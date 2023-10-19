from django import forms
from .models import ModelArtic, ModelFolderDrive

'''class UpdateXlsxForm(forms.Form):
    def __init__(self, *args, **kwargs):
        listXlsxID = kwargs.pop('listXlsxID')
        artics = ModelArtic.objects.filter(listXlsxID = listXlsxID).order_by('code')
        
        
        super(UpdateXlsxForm, self).__init__(*args, **kwargs)

        for artic in artics:
            # Agrega campos dinámicos según la lista
            self.fields[f'{artic.code}_description'] = forms.CharField(required=False)
            self.fields[f'{artic.code}_price_auto'] = forms.BooleanField(required=False)
            self.fields[f'{artic.code}_percent'] = forms.IntegerField(required=False)
            self.fields[f'{artic.code}_price_manual_may'] = forms.FloatField(required=False)
            self.fields[f'{artic.code}_price_manual_min'] = forms.FloatField(required=False)
'''

# formulario para el umento de los articulos de la lista
class UpdateXlsxForm(forms.Form):
    code = forms.CharField(max_length=12)
    #price_auto = forms.BooleanField(required=False)
    price_percent = forms.FloatField(required=False)
    price_manual_may = forms.FloatField(required=False)
    price_manual_min = forms.FloatField(required=False)
    xlsx_id = forms.IntegerField()



class CreateFolderForm(forms.ModelForm):
    class Meta:
        model = ModelFolderDrive
        fields = ['parentId', 'driveId', 'name']
        
    def __init__(self, *args, **kwargs):
        super(CreateFolderForm, self).__init__(*args, **kwargs)
        self.fields['driveId'].required = False