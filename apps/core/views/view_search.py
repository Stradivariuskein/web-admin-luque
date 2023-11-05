from django.shortcuts import render
from django.views.generic import ListView

from apps.core.models import ModelArtic
from siaacTools import reed_artics
from xlsxTools import update_artics

class ViewSearchArtic(ListView):
    model= ModelArtic
    context_object_name = 'artics'
    template_name = 'core/search_artic.html' 

    def get_queryset(self):
        artics = reed_artics()
        update_artics(artics)

        # Llama al método super() para obtener la consulta original
        queryset = super().get_queryset()

        return queryset