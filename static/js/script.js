var table_html = document.querySelector('.table').innerHTML;
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




function searchTable() {
  // Obtén el término de búsqueda
  var input = document.getElementById('searchInput');
  var filter = input.value.toUpperCase();
  var keywords = filter.split(' ');  // Divide el término de búsqueda en palabras
    console.log(keywords)
  // Obtén la tabla y las filas
  var table = document.querySelector('.table');
  table.innerHTML = table_html
  var rows = table.getElementsByTagName('tr');

  // Recorre las filas y oculta las que no coincidan con las palabras de búsqueda
  for (let row of rows) {  // Comienza en 1 para omitir la fila de encabezado
      var cells = row.getElementsByTagName('td');
      var shouldShowRow = true;  // Asume que la fila debe mostrarse inicialmente
      
      // Verifica cada palabra de búsqueda
      for (let keyword of keywords) {

          let found = false;  // Asume que la palabra no se ha encontrado en la fila
          
          // Verifica cada celda de la fila para la palabra de búsqueda
          for (let cell of cells) {  
              let cellText = cell.innerHTML;
              if (keyword !== "") {
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

