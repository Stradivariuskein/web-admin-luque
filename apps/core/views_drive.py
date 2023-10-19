from django.shortcuts import render
from django.views.generic import ListView, CreateView
from django.urls import reverse_lazy
from django.http import HttpResponse
from django.views import View
from django.db import transaction

from .models import ModelFileDrive, ModelFolderDrive
from .forms import CreateFolderForm


class TmpAddFolder(CreateView):
    model = ModelFolderDrive
    template_name = 'core/createXlsx.html'
    form_class = CreateFolderForm
    success_url = reverse_lazy('tmp')
    