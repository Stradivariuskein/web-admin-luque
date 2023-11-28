from django.shortcuts import render
from django.views.generic import ListView, View

from apps.core.models import ModelArtic
from apps.core.tools.siaacTools import reed_artics
from apps.core.tools.xlsxTools import update_artics

class ViewSearchArtic(View):
    def get(self, request, *args, **kwargs):
        artics = ModelArtic.objects.filter(active=True)
        test = ModelArtic.objects.all()
        print(len(test)-len(artics))
        
        return render(request, 'core/search_artic.html',{'artics': artics})