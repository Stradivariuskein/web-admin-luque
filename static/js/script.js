

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


function searchArtic() {
 

  // Obtén el término de búsqueda
  let input = document.getElementById('searchInput');
  let table = document.querySelector('.table');
  console.log(input.innerText)
  if (input.value !== "") {
  let filter = input.value.toUpperCase();
  let keywords = filter.split(' ');  // Divide el término de búsqueda en palabras

  // Obtén la tabla y las filas
  
  table.innerHTML = table_html; // variable global
  let rows = table.getElementsByTagName('tr');

  // Crea un fragmento de documento para las manipulaciones
  let fragment = document.createDocumentFragment();

  
  // Recorre las filas y oculta las que no coincidan con las palabras de búsqueda
  for (let row of rows) { 

    let row_html = row.innerHTML;



      
      

    // Verifica cada palabra de búsqueda
    for (let keyword of keywords) {
      let found = false;  // Asume que la palabra no se ha encontrado en la fila

      // Verifica cada celda de la fila para la palabra de búsqueda
      
        

      
        if (keyword !== "" || keyword !== " ") {
          let index = row_html.toUpperCase().indexOf(keyword.toUpperCase());
          let highlightedText = "";

          if (index > -1) {
            found = true;

            // Resalta la coincidencia con color rojo
            highlightedText = row_html.substring(0, index) +
              '<span style="color: red;">' +
              row_html.substring(index, index + keyword.length) +
              '</span>' +
              row_html.substring(index + keyword.length);
            row_html = highlightedText
          } else {
            highlightedText = row_html;
          }

          // Actualiza el contenido de la celda
          row.innerHTML = highlightedText;
        }
      

      // Si la palabra de búsqueda no se encuentra en ninguna celda, oculta la fila
      if (!found) {
        row.style.display = 'none';
        break;  // No es necesario verificar más palabras si una no se encuentra
      } else {
        row.style.display = ''; // Muestra la fila si se encontró la palabra
      }
    }

  // Agrega la fila al fragmento principal
  fragment.appendChild(row);
  
}

  // Limpia el contenido de la tabla antes de agregar el fragmento principal
  table.innerHTML = `<tr class="text-center" id="">
  <th>Codigo</th>
  <th style="min-width: 25rem;">Descripcion</th>
  <th >Precio mayorista</th>
  <th>Precio minorista</th>  
</tr>`;
  // Agrega el fragmento principal al DOM
  table.appendChild(fragment);
} else {
  table.innerHTML = table_html
}
}
