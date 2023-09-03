import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu", "toggle"];
  
  connect() {
    // Add an event listener to toggle the menu when the button is clicked
    this.element.addEventListener("click", this.toggleMenu.bind(this));
    
    // Close the menu if the user clicks outside of it
    document.addEventListener("click", this.closeMenu.bind(this));
  }
  
  toggleMenu(event) {
    event.preventDefault();
    this.toggleTarget.classList.toggle("show");
  }
  
  closeMenu(event) {
    if (!this.element.contains(event.target) && !this.menuTarget.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
    }
  }
}