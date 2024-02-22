from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView
from django.urls import reverse_lazy
from apps.core.models import ModelListXlsx

class ModelListXlsxListView(ListView):
    model = ModelListXlsx
    template_name = 'core/ModelListXlsx_list.html'
    context_object_name = 'objetos_ModelListXlsx'

class ModelListXlsxDetailView(DetailView):
    model = ModelListXlsx
    template_name = 'core/ModelListXlsx_detail.html'
    context_object_name = 'ModelListXlsx'

class ModelListXlsxCreateView(CreateView):
    model = ModelListXlsx
    template_name = 'core/ModelListXlsx_form.html'
    fields = '__all__'
    success_url = reverse_lazy('ModelListXlsx-list')

class ModelListXlsxUpdateView(UpdateView):
    model = ModelListXlsx
    template_name = 'core/ModelListXlsx_form.html'
    fields = '__all__'
    success_url = reverse_lazy('ModelListXlsx-list')

class ModelListXlsxDeleteView(DeleteView):
    model = ModelListXlsx
    template_name = 'core/ModelListXlsx_confirm_delete.html'
    success_url = reverse_lazy('ModelListXlsx-list')