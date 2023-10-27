// Menu manipulation
// Add toggle listeners to listen for clicks.
document.addEventListener('turbo:load', function() {
  document.querySelector('.account').addEventListener('click', function(event) {
    event.preventDefault();
    document.querySelector('.dropdown-menu').classList.toggle('active');
  });
});
