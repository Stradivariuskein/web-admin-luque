function toggleDropdown(index) {
  const dropdownMenu = $(`#dropdown-menu-${index}`);
  dropdownMenu.toggle();
  
  // Hide other dropdown menus
  $(".dropdown-menu").not(dropdownMenu).hide();
}