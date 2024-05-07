
# carpeta con las estructura ordenada de als listas ordenadas (FIJARSE SI SE USA. SI NO BORRAR)
RUTE_XLSX_AGRUPS = { #RUTE_XLSX_AGRUPS = "notebook-toshiba/red/listas" # despliegue
    'mi':"./LISTAS_ORDENADAS/MI/",
    'ma':"./LISTAS_ORDENADAS/MA/"
    }

# ruta donde estan los modelos originasl de las listas de precios 
RUTE_XLSX_ORIGIN = { #RUTE_XLSX_ORIGIN = ["./Listas de preios/lista minorista/", "./Listas de preios/lista mayorita/"] # en espliegue
    "mi": "./LISTAS/mi/",
    "ma": "./LISTAS/ma/"
    } 

# ruta del sistema de ventas
RUTE_SIAAC = "./vDos_SIAAC/SIAAC3/" # EN PRODUCCION
#RUTE_SIAAC = "Y://SIAAC3/" # EN DESPLIEGUE

# ruta del archivo normalizado de los articulos
RUTE_SIAAC_FILES = "./siaac/"

XLSX_RUTE = "../Listas de precios/"
#XLSX_RUTE = "Y:/Listas de precios/"

ROOTS_DRIVE_IDS={
    'order': '1TEHr2NrX6YLbyxzNG3BDaN-WpRRAcKdi', # en produccion: 'order': '1-AH2030Syyy7ncV1xkuEsr1eDJyz8R4N',
    'common': '1mupKCvLb4Gccpp2R9zx9vnylUVdIVgvW' # en produccion: 'common': ''
}

FILE_CREDENTIALS_DRIVE = "../service_account.json"

IP = "192.168.2.218"
#IP = "192.168.1.61"