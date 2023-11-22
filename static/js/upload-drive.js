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


//falta validar la peticion 

function uploadDrive2() {
    console.log("subiendo")
    // Obtener el atributo href de la etiqueta <a>
    var link = document.getElementById("btn-download").getAttribute("href");
    var csrfToken = document.querySelector('input[name="csrfmiddlewaretoken"]').value;

    // Extraer el valor de 'ids' de la URL
    var ids = link.split('?')[1].split('=')[1];

    var all_ok = true
    
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
                
                // Modificar el estado y el color de fondo
                if (fileInfo['succes']) {

                    dropBox[0].innerText = "Subido";
                    dropBox[0].classList.remove('card-warning')
                    dropBox[0].classList.add('card-green')
                    
                    for (let key in fileInfo) {
                        if (key !== 'succes') {
    
                            let link = document.createElement('a');
                            link.href = fileInfo[key];
                            link.target = "_blank";
                            link.textContent = key;
                            
    
                            let drop_li = document.createElement('li')
                            
                            drop_li.className = 'btn text-center';
                       
                            drop_li.appendChild(link);
                            dropBox[1].appendChild(drop_li);
                        }
                        
                    }

                    
                } else {
                    all_ok = false
                    dropBox[0].innerText = "Error";
                    dropBox[0].style.backgroundColor = "lightcoral";
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
