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


function uploadDrive2() {
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
            for (let name in data) {
                let status = document.getElementById(name);
                let fileInfo = data[name];
                let dropBox = status.children;
                all_ok = true
                // Modificar el estado y el color de fondo
                if (fileInfo['succes']) {

                    dropBox[0].innerText = "Subido";
                    

                    dropBox[0].style.backgroundColor = "lightgreen";
                } else {
                    all_ok = false
                    dropBox[0].innerText = "Error";
                    dropBox[0].style.backgroundColor = "lightcoral";
                }
                dropBox[0].className = "btn-link"
                // agrego una flecha
                dropBox[0].innerHTML += "<div class='font-28 my-1'> &blacktriangledown;</div>";
                // Crear el elemento <a>
                for (let key in fileInfo) {
                    if (key !== 'succes') {

                        let link = document.createElement('a');
                        link.style.margin = '5%';
                        link.href = fileInfo[key];
                        link.target = "_blank" 
                        link.className = 'card card-green text-center'; 

                        let drop_div = document.createElement('div')
                        drop_div.textContent = key;
                        drop_div.style.margin = "5%";
                        drop_div.className = 'btn-link'
                   
                        link.appendChild(drop_div);
                        dropBox[1].appendChild(link);
                    }
                    
                }
            }
        
                
             if (all_ok) {
                msj = document.getElementById('msj');
                msj_child = msj.children[0];
                msj_child.textContent = "Todo subido";
                msj.style.backgroundColor = "lightgreen";

             } else {
                msj = document.getElementById('msj');
                msj_child = msj.children[0];
                msj_child.textContent = "Algo sali mal";
                msj.style.backgroundColor = "lightcoral";
             }  
                
        }
})
}
