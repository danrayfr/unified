import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification"
export default class extends Controller {
  static targets = ["notif"];
  
  connect() {
    console.log(this.element);
  }
}
