
// Obtén el checkbox "Seleccionar Todo"
const selectAllCheckbox = document.getElementById('select-all');

// Obtén todos los checkboxes individuales
const checkboxes = document.querySelectorAll('input[type="checkbox"]:not(#select-all)');

// Agrega un evento de cambio al checkbox "Seleccionar Todo"
selectAllCheckbox.addEventListener('change', function () {
    // Establece el estado de todos los checkboxes individuales igual al del "Seleccionar Todo"
    checkboxes.forEach(checkbox => {
        checkbox.checked = selectAllCheckbox.checked;
    });
});

function toggleDropdown(id) {
  const dropdownMenu = $(`#${id}`);
  dropdownMenu.toggle();
  
  // Hide other dropdown menus
  $(".dropdown-menu").not(dropdownMenu).hide();
}

function updatePercentage(tableNumber) {
  const percentage = document.getElementById(`percentage_input_${tableNumber}`).value;
  console.log(percentage);
  const rows = document.querySelectorAll(`#table_${tableNumber} tbody tr`);
  console.log(rows)
  rows.forEach(row => {
      const pricePercentInput = row.querySelector('input[name="price_percent"]');
      console.log(pricePercentInput);
      if (pricePercentInput) {
          pricePercentInput.value = percentage;
      }
  });
}

function handleCheckboxClick(checkbox) {
  const parentDiv = checkbox.parentElement;

  const checkboxes = parentDiv.querySelectorAll('input[type=checkbox]');

  checkboxes.forEach(otherCheckbox => {
      if (otherCheckbox !== checkbox) {
          otherCheckbox.checked = false;
      }
  });
}


let searchTimer;

function startSearchTimer(func) {
  // Cancela el temporizador existente si lo hay
  clearTimeout(searchTimer);

  // Inicia un nuevo temporizador después de 2 segundos
  searchTimer = setTimeout(func, 1000);
}

var table_html = document.querySelector('.table').innerHTML;

function searchXlsx() {

  // Obtén el término de búsqueda
  let input = document.getElementById('searchInput');
  let filter = input.value.toUpperCase();
  let keywords = filter.split(' ');  // Divide el término de búsqueda en palabras

  // Obtén la tabla y las filas
  let table = document.querySelector('.table');

  let rows = table.getElementsByTagName('tr');


  
  // Recorre las filas y oculta las que no coincidan con las palabras de búsqueda
  for (let row of rows) { 

    let row_html = row.innerHTML;

    // Verifica cada palabra de búsqueda
    for (let keyword of keywords) {
      let found = false;  // Asume que la palabra no se ha encontrado en la fila

      // Verifica cada celda de la fila para la palabra de búsqueda

        if (keyword !== "" || keyword !== " ") {
          let index = row_html.toUpperCase().indexOf(keyword.toUpperCase());

          if (index > -1) {
            found = true;

          } 

        }
      

      // Si la palabra de búsqueda no se encuentra en ninguna celda, oculta la fila
      if (!found) {
        is_header = row_html.toUpperCase().indexOf("ACTUALIZAR");
        if (is_header === -1) {
          row.style.display = 'none';
          break; 
        } // No es necesario verificar más palabras si una no se encuentra
      } else {
        row.style.display = ''; // Muestra la fila si se encontró la palabra
      }
    }

  
}
}

var table_artics = document.getElementById('table-body').innerHTML;
function searchArtic3() {
   // Obtén el término de búsqueda
   let input = document.getElementById('searchInput');
   let table = document.getElementById('table-body');
   console.log(table.innerHTML)
   if (input.value !== "") {
     let filter = input.value.toUpperCase();
     let keywords = filter.split(' ');  // Divide el término de búsqueda en palabras
 
     // Obtén la tabla y las filas
     table.innerHTML = table_artics; // variable global
     let rows = table.getElementsByTagName('tr');
 
     // Crea un fragmento de documento para las manipulaciones
     let fragment = document.createDocumentFragment();
 
     // Recorre las filas y verifica si cumplen con las palabras de búsqueda
     for (let row of rows) {
      // Agrega la fila al fragmento
      fragment.appendChild(row.cloneNode(true));
      let fragment_row = fragment.lastChild
      let shouldShow = true;
 
       // Almacena las modificaciones de la fila en un array
       let modifiedCells = [];
 
       // Verifica cada palabra de búsqueda
       for (let keyword of keywords) {
         if (keyword !== "" && keyword !== " ") {
           let found = false;  // Asume que la palabra no se ha encontrado en la fila

           // Verifica cada celda de la fila para la palabra de búsqueda
           for (let col of fragment_row.children) {
             let col_text = col.innerText;
             let col_html = col.innerHTML;
             let index = col_text.toUpperCase().indexOf(keyword.toUpperCase());
             let highlightedText = col_html;
 
             if (index > -1) {
               found = true;
               index += col_html.indexOf(col_text);
               // Resalta la coincidencia con color rojo
               highlightedText = col_html.substring(0, index) +
                 '<span style="color: red;">' +
                 col_html.substring(index, index + keyword.length) +
                 '</span>' +
                 col_html.substring(index + keyword.length);
             }
             // Almacena la celda modificada en el array
             modifiedCells.push({ col, highlightedText });
           }
 
           // Si la palabra de búsqueda no se encuentra en ninguna celda, oculta la fila
           if (!found) {
             shouldShow = false;
             break;  // No es necesario verificar más palabras si una no se encuentra
           }
         }
       }
 
       // Actualiza el contenido de las celdas al final del bucle
       for (let { col, highlightedText } of modifiedCells) {
         col.innerHTML = highlightedText;
       }
 
       // Muestra u oculta la fila según los resultados
       fragment_row.style.display = shouldShow ? '' : 'none';
       fragment.lastChild.innerHTML = fragment_row.innerHTML
       // debug
       console.log(fragment.lastChild)
       
     }
     //debug
     console.log(fragment.children.innerHTML)
     // Limpia el contenido de la tabla antes de agregar el fragmento
     table.innerHTML = ''
     table.appendChild(fragment);
 
   } else {
     // Restaura la tabla original si no hay término de búsqueda
     table.innerHTML = table_artics;
   }
 }

 function get_prices(code) {
  // Construir la URL con el parámetro 'code'
  var url = `http://localhost:8000/prices/?code=${code}`;

  // Crear una instancia de XMLHttpRequest
  var xhr = new XMLHttpRequest();

  // Configurar la solicitud GET con la URL
  xhr.open('GET', url, true);

  // Configurar el tipo de respuesta esperada (JSON)
  xhr.setRequestHeader('Content-Type', 'application/json');

  // Configurar la función de devolución de llamada para manejar la respuesta
  xhr.onreadystatechange = function () {
    if (xhr.readyState == 4) {
      // Verificar si la solicitud fue exitosa (código 200)
      if (xhr.status == 200) {
        // Convertir la respuesta JSON a un objeto JavaScript
        var response = JSON.parse(xhr.responseText);

        // Manejar la respuesta JSON aquí
        pricesHtml = document.getElementById(code).getElementsByTagName("input");
        pricesHtml[0].value = response.priceMa
        pricesHtml[1].value = response.priceMi
        console.log(pricesHtml);
      } else {
        // Manejar errores aquí
        console.error('Error en la solicitud:', xhr.status, xhr.statusText);
      }
    }
  };

  // Enviar la solicitud
  xhr.send();
}