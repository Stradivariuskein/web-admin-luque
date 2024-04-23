from django.urls import path
from .views import index, test_prices_from_db_for_xlsx

urlpatterns = [
    path('', index, name='test-index'),
    path('prices-db/', test_prices_from_db_for_xlsx, name='test-prices-from-db-for-xlsx'),
    ]