from django.shortcuts import render
from django.views.generic import ListView

from .models import ListaXlsx
# Create your views here.

def update_xlsx(request):

    context = {
        'listXlsx': [],
    }

    return render(request, "core/index.html", context)


class ListXlsx(ListView):
    model = ListaXlsx
    template_name = 'core/index.html'
    context_object_name = 'listXlsx'