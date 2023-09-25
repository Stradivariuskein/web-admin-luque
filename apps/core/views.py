from django.shortcuts import render
from django.views.generic import ListView, CreateView
from django.urls import reverse_lazy


from .models import ListXlsx
# Create your views here.

def update_xlsx(request):

    context = {
        'listXlsx': [],
    }

    return render(request, "core/index.html", context)


class CreateXlsx(CreateView):
    model = ListXlsx
    template_name = 'core/createXlsx.html'
    success_url = reverse_lazy('create-list-xlsx')
    fields = ['name', 'driveId', 'modDate', 'img', 'pathlocal']


class ListXlsx(ListView):
    model = ListXlsx
    template_name = 'core/index.html'
    context_object_name = 'listXlsx'