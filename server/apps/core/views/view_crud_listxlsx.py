from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView
from django.urls import reverse_lazy
from apps.core.models import ModelListXlsx
from django.http import JsonResponse
from django.forms.models import model_to_dict

class ModelListXlsxDetailView(DetailView):
    model = ModelListXlsx

    def render_to_response(self, context, **response_kwargs):
        data = model_to_dict(context['object'])  # Convertir el objeto a un diccionario
        return JsonResponse(data)

class ModelListXlsxView(CreateView):
    model = ModelListXlsx
    fields = '__all__'
    success_url = reverse_lazy('ModelListXlsx-list')

    def get(self, request, *args, **kwargs):
        # Lógica para manejar la petición GET
        data = list(self.model.objects.all().values())
        return JsonResponse(data, safe=False)


    def render_to_response(self, context, **response_kwargs):
        return JsonResponse({'message': 'Object created successfully'})

class ModelListXlsxUpdateView(UpdateView):
    model = ModelListXlsx
    fields = '__all__'
    success_url = reverse_lazy('ModelListXlsx-list')

    def render_to_response(self, context, **response_kwargs):
        return JsonResponse({'message': 'Object updated successfully'})

class ModelListXlsxDeleteView(DeleteView):
    model = ModelListXlsx
    success_url = reverse_lazy('ModelListXlsx-list')

    def render_to_response(self, context, **response_kwargs):
        return JsonResponse({'message': 'Object deleted successfully'})