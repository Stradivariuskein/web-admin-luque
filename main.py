from datetime import datetime, timedelta
import pystray
from PIL import Image
import subprocess
import atexit
import threading
import psutil
from plyer import notification
import time


# cantidad de dias q se almasenaran los logs
days_to_delete_logs = 60
# Variable global para almacenar el proceso
process = None

def cleanup():
    global process
    # Realizar tareas de limpieza, como cerrar el proceso
    if process and process.poll() is None:
        process.terminate()

# Registra la función de limpieza con atexit
atexit.register(cleanup) # se ejecunta en el cierrre del programa

# funcion para salir del programa
def on_quit(icon):
    global process  # Accede a la variable global process
    if process:
        try:
            parent = psutil.Process(process.pid)
            for child in parent.children(recursive=True):
                child.terminate()  # Termina los procesos hijos
            parent.terminate()  # Termina el proceso padre

            # Espera a que los procesos terminen
            _, alive = psutil.wait_procs([parent] + parent.children(recursive=True), timeout=5)
            for child in alive:
                child.kill()  # Si no termina, intenta matarlos
                child.wait()

        except psutil.NoSuchProcess:
            pass

    icon.stop()

# Escrive los logs del servidor en el archivo
def write_logs():
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    with open("logs.txt", "a") as log_file:
        log_file.write(f"{current_time} || Run server\n")

        # leemos la salida del servidor y scrivimos la salida en el archivo
        while True:
            output = process.stdout.readline()
            if not output:
                break
            logs = output.strip()

            # Escribir el log en el archivo
            log_file.write(f"{current_time} || {logs}\n")

        log_file.write(f"{current_time} || Stop server\n")        


# Ejecuta el comado para del servidor 
def run_command():
    global process

    if process:
        # Enviar señal de interrupción al proceso si existe        
        process.terminate()  
        process.wait()

    # Directorio al que quieres moverte antes de ejecutar el comando
    target_directory = "./server/"
    ##
    command = f"python manage.py runserver 0.0.0.0:80"

    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True, text=True, cwd=target_directory)
    
    write_logs()


#########
def show_notification(title, message):
    notification.notify(
        title=title,
        message=message,
        timeout=5  # segundos antes de que la notificación desaparezca
    )

def run_server():
    global process
    title_notification = "Web Luque"
    
    # Ejecutar run_command en un hilo separado
    command_thread = threading.Thread(target=run_command)
    command_thread.start()

    time.sleep(5)
    if process:
        show_notification(title_notification, "El servidor esta en ejecucion")
    else:
        show_notification(title_notification, "ERROR: No se pudo iniciar el servidor")


# elimina los logs apartir de una cantidad de dias pasasdos
def delete_olds_logs(days):
    # Obtener la fecha actual y calcular la fecha límite
    top_date = datetime.now() - timedelta(days=days)

    
    with open('logs.txt', 'r') as file:
        lines = file.readlines()

    # Recorrer las líneas desde el final hacia el inicio
    for i in range(len(lines) - 1, -1, -1):
        line = lines[i]

        if delete_line(line, top_date):
            # Encontrar la primera línea que no debe eliminarse y retornar su número
            trunca_index = i 
            break

    if i != 0:
        # Guardar las líneas restantes en el archivo logs.txt
        with open('logs.txt', 'w') as file:
            new_lines = lines[trunca_index:]
            file.writelines(new_lines)

# si la fecha de la linea es menor o igual a la fecha 
# top_date retornara true en los demas casos false
# Esta función determina si la línea no debe eliminarse
def delete_line(line, top_date) -> bool:

    # En este ejemplo, se supone que cada línea tiene el formato "fecha: mensaje"
    parts = line.split('||')
    if len(parts) >= 2:

        date_str = parts[0].strip()
        try:
            date_log = datetime.strptime(date_str, '%Y-%m-%d %H:%M:%S')
            return date_log <= top_date
        except ValueError:
            # La línea no tiene el formato esperado, no la eliminamos
            return True
        
    else:
        # La línea no tiene el formato esperado, no la eliminamos
        return True


def main():
    global days_to_delete_logs
    # borramsos los log mayores a la cantidad de dias
    try:
        delete_olds_logs(days_to_delete_logs)
    except Exception as e:
        print(e)

    # ejecuta el servidor django
    try:
        run_server()
    except Exception as e:
        print(f"Error en run_command: {e}")
    
    # Ejecutar el menu en la bandeja del sistema
    pystray_main()



# crea e inicializa el menu en la bandeja del sistema
def pystray_main():


    image = Image.open("./LOGO_LUQUE.png")

    icon = pystray.Icon('Windows Menu', image, 'Windows Menu', menu=pystray.Menu(
    pystray.MenuItem('Reiniciar', run_server),
    pystray.MenuItem('Cerrar', on_quit),
    ))

    icon.run()

if __name__ == "__main__":

    main()
