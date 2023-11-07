function toggleDropdown(index) {
  const dropdownMenu = $(`#dropdown-menu-${index}`);
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

  // Obtén la tabla y las filas
  var table = document.querySelector('.table');
  var rows = table.getElementsByTagName('tr');

  // Recorre las filas y oculta las que no coincidan con el término de búsqueda
  for (var i = 1; i < rows.length; i++) {  // Comienza en 1 para omitir la fila de encabezado
      var cells = rows[i].getElementsByTagName('td');
      var shouldShowRow = false;

      // Verifica cada celda de la fila para el término de búsqueda
      for (var j = 0; j < cells.length; j++) {  
          var cellText = cells[j].textContent || cells[j].innerText;
          if (cellText.toUpperCase().indexOf(filter) > -1) {
              shouldShowRow = true;
              break;
          }
      }

      // Muestra u oculta la fila
      if (shouldShowRow) {
          rows[i].style.display = '';
      } else {
          rows[i].style.display = 'none';
      }
  }
}

function searchTable2() {
  // Obtén el término de búsqueda
  var input = document.getElementById('searchInput');
  var filter = input.value.toUpperCase();
  var keywords = filter.split(' ');  // Divide el término de búsqueda en palabras

  // Obtén la tabla y las filas
  var table = document.querySelector('.table');
  var rows = table.getElementsByTagName('tr');

  // Recorre las filas y oculta las que no coincidan con las palabras de búsqueda
  for (var i = 1; i < rows.length; i++) {  // Comienza en 1 para omitir la fila de encabezado
      var cells = rows[i].getElementsByTagName('td');
      var shouldShowRow = true;  // Asume que la fila debe mostrarse inicialmente

      // Verifica cada palabra de búsqueda
      for (var k = 0; k < keywords.length; k++) {
          var keyword = keywords[k];
          var found = false;  // Asume que la palabra no se ha encontrado en la fila

          // Verifica cada celda de la fila para la palabra de búsqueda
          for (var j = 0; j < cells.length; j++) {  // Comienza en 1 para omitir la primera celda con el checkbox
              var cellText = cells[j].textContent || cells[j].innerText;
              if (cellText.toUpperCase().indexOf(keyword) > -1) {
                  found = true;
                  break;
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
          rows[i].style.display = '';
      } else {
          rows[i].style.display = 'none';
      }
  }
}


