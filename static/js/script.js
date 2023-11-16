const { sleep } = require('timers/promises');

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


var table_html = document.querySelector('.table').innerHTML;

function searchTable() {
  // Obtén el término de búsqueda
  let input = document.getElementById('searchInput');
  let filter = input.value.toUpperCase();
  let keywords = filter.split(' ');  // Divide el término de búsqueda en palabras
    console.log(keywords)
  // Obtén la tabla y las filas
  let table = document.querySelector('.table');
  table.innerHTML = table_html // variable global
  let rows = table.getElementsByTagName('tr');

  // Recorre las filas y oculta las que no coincidan con las palabras de búsqueda
  for (let row of rows) {  // Comienza en 1 para omitir la fila de encabezado
      let cells = row.getElementsByTagName('td');
      let shouldShowRow = true;  // Asume que la fila debe mostrarse inicialmente
      
      // Verifica cada palabra de búsqueda
      for (let keyword of keywords) {

          let found = false;  // Asume que la palabra no se ha encontrado en la fila
          
          // Verifica cada celda de la fila para la palabra de búsqueda
          for (let cell of cells) {  
              let cellText = cell.innerHTML;
              if (keyword !== "" || keyword !== " ") {
              let index = cellText.toUpperCase().indexOf(keyword.toUpperCase());
              if (index > -1) {
                    console.log(keyword)
                    
      
                    found = true
                    // Resalta la coincidencia con color rojo
                    let highlightedText = cellText.substring(0, index) +
                    '<span style="color: red;">' +
                    cellText.substring(index, index + keyword.length) +
                    '</span>' +
                    cellText.substring(index + keyword.length);
                    console.log("cellTetx: "+cellText)
                    console.log("nueva: "+highlightedText)

                    cell.innerHTML = highlightedText;
                    

                    
              } 
            }
          }

          // Si la palabra de búsqueda no se encuentra en ninguna celda, oculta la fila
          if (!found) {
              shouldShowRow = false;
              
              break;  // No es necesario verificar más palabras si una no se encuentra
          }
      }

      // Muestra u oculta la fila
      if (shouldShowRow) {
          row.style.display = '';
      } else {
          row.style.display = 'none';
      }
  }
}

function searchTable2() {
  //await sleep(2000);
  console.log("empezo")
  // Obtén el término de búsqueda
  let input = document.getElementById('searchInput');
  let filter = input.value.toUpperCase();
  let keywords = filter.split(' ');  // Divide el término de búsqueda en palabras

  // Obtén la tabla y las filas
  let table = document.querySelector('.table');
  table.innerHTML = table_html; // variable global
  let rows = table.getElementsByTagName('tr');

  // Crea un fragmento de documento para las manipulaciones
  let fragment = document.createDocumentFragment();

  
  // Recorre las filas y oculta las que no coincidan con las palabras de búsqueda
  for (let row of rows) {  // Comienza en 1 para omitir la fila de encabezado

    // Crea un fragmento de documento para las celdas de la fila
    let rowFragment = document.createDocumentFragment();

    let cells = row.getElementsByTagName('td');

    let shouldShowRow = true;  // Asume que la fila debe mostrarse inicialmente
    if (cells.length !== 0) {
      
      

      // Verifica cada palabra de búsqueda
      for (let keyword of keywords) {
        let found = false;  // Asume que la palabra no se ha encontrado en la fila

        // Verifica cada celda de la fila para la palabra de búsqueda
        for (let cell of cells) {
          if (cell.innerText === "Codigo") {
            console.log(cells)
          }
          let cellText = cell.innerHTML;

          if (keyword !== "" || keyword !== " ") {
            let index = cellText.toUpperCase().indexOf(keyword.toUpperCase());
            let highlightedText = ""
            if (index > -1) {
              found = true;
              
              // Resalta la coincidencia con color rojo
              highlightedText = cellText.substring(0, index) +
                '<span style="color: red;">' +
                cellText.substring(index, index + keyword.length) +
                '</span>' +
                cellText.substring(index + keyword.length);

              
            } else {
              highlightedText = cell.innerHTML
            }
            // Agrega el contenido resaltado al fragmento de la celda
            let aux_cell = document.createElement('td');
            aux_cell.innerHTML = highlightedText;
            rowFragment.appendChild(aux_cell);
          }
        }

        // Si la palabra de búsqueda no se encuentra en ninguna celda, oculta la fila
        if (!found) {
          shouldShowRow = false;
          break;  // No es necesario verificar más palabras si una no se encuentra
        }
      }
  }

    // Limpia el contenido de la fila antes de agregar el fragmento
    row.innerHTML = '';

    // Agrega las celdas al fragmento de fila
    row.appendChild(rowFragment);

    // Muestra u oculta la fila
    row.style.display = shouldShowRow ? '' : 'none';

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
}
