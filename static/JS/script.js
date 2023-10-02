function toggleMenu(menuId) {
    const menu = document.getElementById('menu' + menuId);
    menu.style.display = menu.style.display === 'none' || menu.style.display === '' ? 'block' : 'none';
  }