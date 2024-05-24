from django.urls import path
from .views import index, test_prices_from_db_for_xlsx, test_files_exist_in_drive, pruevas, view_check_drive_id

urlpatterns = [
    path('', index, name='test-index'),
    path('prices-db/', test_prices_from_db_for_xlsx, name='test-prices-from-db-for-xlsx'),
    path('drive/', test_files_exist_in_drive, name='test_files_exist_in_drive'),
    path('pruevas/', pruevas, name='pruevas'),
    path('drive/checkids', view_check_drive_id, name='test-drive-files'),
    
    ]