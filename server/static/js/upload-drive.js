


//falta validar la peticion 

function uploadDrive(target=null) {
    if (target == null) {
        target = '/uploadDrive/'
        request_method = 'POST'
    } else {
        request_method = 'GET'
    }
    console.log("subiendo")
    // Obtener el atributo href de la etiqueta <a>
    var link = document.getElementById("btn-download").getAttribute("href");
    var csrfToken = document.querySelector('input[name="csrfmiddlewaretoken"]').value;

    // Extraer el valor de 'ids' de la URL
    var ids = link.split('?')[1].split('=')[1];

    var all_ok = true
    var msj = document.getElementById('msj');
    var msj_child = msj.children[0];
    msj_child.innerText = 'Subiendo al drive...\nEspere a que todas las listas digan subido'
    const writeMsj = (status, textMsj='') => {

        // Verifica si hay un botón entre los hijos del contenedor
        var haveButton = Array.from(msj.children).some(function (element) {
            return element.tagName === 'BUTTON';
        });

        if (status) {
            msj_child.textContent = "Todo subido";
            msj.style.backgroundColor = "lightgreen";
            if (haveButton) {
                msj.removeChild(msj.children[1])
            }
        
        } else {                
            msj_child.textContent = "Algo salio mal.";
            msj.style.backgroundColor = "lightcoral";
            msj.classList.remove('card-warning')

            if (!haveButton) {
                retryButton = document.createElement('BUTTON');
                retryButton.innerText = 'Reintentar';
                retryButton.className = 'btn card-warning mb-2';

                retryButton.onclick = function() {            
                    uploadDrive('/reuploadDrive/');
                };

                msj.appendChild(retryButton);
            }

            
        } 
        if (textMsj !== '') {
            console.log(textMsj)
            msj_child.textContent += ' ' + textMsj 
        }
        console.log(`msj = ${textMsj}`)
        
    }
    $.ajax({
        type: request_method,
        url: target,
        data: {'xlsx_id': ids},
        headers: {
            "X-CSRFToken": csrfToken  // Agrega el token CSRF a la cabecera
        },
        success: function(data) {
            console.log(data)
            for (let name in data) {
                
                let status = document.getElementById(name);

                let fileInfo = data[name];
                let dropBox = status.children;
                dropBox[0].classList.remove('card-warning')
                
                if (Object.keys(fileInfo).length !== 0){
                   
                    for (let key in fileInfo) {
            
                        if (key !== 'error') {
                            
                            if (key !== 'no_drive') {
                                
                                if (dropBox[0].innerText !== 'Error') {
                                    dropBox[0].innerText = "Subido";
                                }
                                
                                dropBox[0].classList.add('card-green')

                                let link = document.createElement('a');
                                link.href = fileInfo[key];
                                link.target = "_blank";
                                link.textContent = key;
                                

                                let drop_li = document.createElement('li')
                                
                                drop_li.className = 'btn text-center';
                            
                                drop_li.appendChild(link);
                                dropBox[1].appendChild(drop_li);

                            } else {
                                
                                dropBox[0].innerText = "Drive no";
                                dropBox[0].title = "Esta lista no esta subida al drive.\nSe actualizo correctamente"
                                dropBox[0].classList.add('card-warning')
                            }

                            
                        } else {
                            
                            all_ok = false
                            dropBox[0].innerText = "Error";
                            writeMsj(all_ok, fileInfo[key]);
                            dropBox[0].style.backgroundColor = "lightcoral";
                        }
                        
                    }
            } else {
                all_ok = false
                dropBox[0].innerText = "Error";
                dropBox[0].style.backgroundColor = "lightcoral";
            }

            }
            writeMsj(all_ok)
                
        },
        error: function(xhr, status, error) {
            console.log(error)
            writeMsj(false, error)
        }

})


}




