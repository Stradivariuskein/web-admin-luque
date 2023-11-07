// Función para realizar las acciones en segundo plano
function uploadDrive() {
    console.log("subiendo")
    // Obtener el atributo href de la etiqueta <a>
    var link = document.getElementById("btn-download").getAttribute("href");
    var csrfToken = document.querySelector('input[name="csrfmiddlewaretoken"]').value;

    // Extraer el valor de 'ids' de la URL
    var ids = link.split('?')[1].split('=')[1];


    
    $.ajax({
        type: "POST",
        url: "/uploadDrive/",
        data: {'xlsx_id': ids},
        headers: {
            "X-CSRFToken": csrfToken  // Agrega el token CSRF a la cabecera
        },
        success: function(data) {
            // cambiar el estado a subido y un tilde
            for (let name of data.names) {
                let status = document.getElementById(name)
                status.innerText = "Subido"
                console.log(`subido ${name}`)
            }
        }
    });
    

}
