"""
URL configuration for admin_luque project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.urls import path
from apps.core.views.views import CreateXlsx, ViewUpdateXlsxStep1, ViewUpdateXlsxStep2, ViewSelectList, download_xlsx, ViewUploadDrive, ReuploadFileDrive
from apps.core.views.views_tmp import tmp_view_delet_duplicate_drive, view_check_drive_id
from apps.core.views.view_search import ViewSearchArtic
from apps.core.views.view_testing import test_prices_siaac, test_files_drive


urlpatterns = [
    path('test/', view_check_drive_id, name='test'),
    path('test/prices', test_prices_siaac, name='test-prices'),
    path('test/files', test_files_drive, name='test-files'),
    path('', ViewSelectList.as_view(), name='listas-xlsx'),
    path('create/', CreateXlsx.as_view(), name='create-list-xlsx'),
    path('xlsxstep1/', ViewUpdateXlsxStep1.as_view(), name='udate-xlsx-step1'),
    path('xlsxstep2/', ViewUpdateXlsxStep2.as_view(), name='udate-xlsx-step2'),
    path('download/', download_xlsx, name='download'),
    path('uploadDrive/', ViewUploadDrive.as_view(), name='upload-drive'),
    path('reuploadDrive/', ReuploadFileDrive.as_view(), name='reupload-drive'),
    path('artics/', ViewSearchArtic.as_view(), name='artics'),

]
