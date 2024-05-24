import os

# Ruta al directorio del proyecto
project_dir = r"C:\web-admin-luque"

# Comando para activar el entorno virtual y ejecutar el script principal
command = fr"cd /d {project_dir} && .\env\Scripts\activate && python .\main.py"

# Ejecutar el comando en la misma shell
os.system(command)
