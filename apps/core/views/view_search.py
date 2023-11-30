from django.shortcuts import render
from django.views.generic import ListView, View

from apps.core.models import ModelArtic
from apps.core.tools.siaacTools import reed_artics
from apps.core.tools.xlsxTools import update_artics

class ViewSearchArtic(View):
    def get(self, request, *args, **kwargs):
        siaac_artics = reed_artics()
        update_artics(siaac_artics)
        artics = ModelArtic.objects.filter(active=True)
        test = artics.filter(code='BULO-104').first()
        print(test.description)
        
        return render(request, 'core/search_artic.html',{'artics': artics})