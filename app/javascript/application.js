// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Toggle Navbar Dropdown
document.addEventListener('click', function navbarDropToggler(e) {
  var menuButton = document.querySelector("#user-menu-button")
  var dropMenu = document.querySelector("#user-menu")

  // If the menu is hidden, and they're not clicking on the button, let the click happen like normal.
  if (dropMenu?.classList?.contains('hidden') && e.target.closest("#user-menu-button") !== menuButton) return

  // If the menu is open, and they're not clicking within the menu, prevent the click from doing anything.
  if (e.target.closest("#user-menu") !== dropMenu) e.preventDefault()

  // Toggle the drop down
  dropMenu?.classList?.toggle('hidden')
})

// Toggle Mobile Nav
document.addEventListener('click', function mobileNavToggler(e) {
  if (e.target.closest("#mobile-menu-button") === document.querySelector("#mobile-menu-button"))
    document.querySelector("#mobile-menu").classList.toggle('hidden')
})

// Close flash notification
document.addEventListener('click', function flashNotificationDismisser(e) {
  if (e.target.closest(".flash-notification-close") === document.querySelector(".flash-notification-close"))
    e.target.closest(".flash-notification").classList.add('hidden')
})
