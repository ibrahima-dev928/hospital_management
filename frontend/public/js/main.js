// Fonctions globales (les mêmes que dans le footer mais centralisées)
function toggleSidebar() {
  document.querySelector('.sidebar').classList.toggle('active');
}
function toggleTheme() {
  fetch('/api/theme/toggle', { method: 'POST' }).then(() => location.reload());
}
function toggleUserDropdown() {
  const dd = document.getElementById('userDropdown');
  if (dd) dd.style.display = dd.style.display === 'none' ? 'block' : 'none';
}
document.addEventListener('click', (e) => {
  const dd = document.getElementById('userDropdown');
  const um = document.querySelector('.user-menu');
  if (dd && um && !um.contains(e.target) && !dd.contains(e.target)) dd.style.display = 'none';
});