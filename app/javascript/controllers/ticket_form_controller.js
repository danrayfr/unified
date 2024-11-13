import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"];
  
  addTicketDetail(event) {
    event.preventDefault();
    const time = new Date().getTime();
    const content = this.templateTarget.innerHTML.replace(/TEMPLATE/g, time);
    const index = this.getNextIndex();

    const updatedContent = content.replace(/ticket_details_attributes\[TEMPLATE\]/g, `ticket_details_attributes[${index}]`);
    this.containerTarget.insertAdjacentHTML("beforeend", updatedContent);
  }

  getNextIndex() {
    return this.containerTarget.querySelectorAll('.ticket-detail').length;
  }

  saveTicketDetails(event) {
    event.preventDefault();
    const ticketDetailElements = this.containerTarget.querySelectorAll('.ticket-detail');

    ticketDetailElements.forEach((element) => {
      const form = element.querySelector('form');
      const formData = new FormData(form);

      // You need to customize the URL based on your application's routes
      const url = formData.get('id') ? `/ticket_details/${formData.get('id')}` : '/ticket_details';
      
      // Perform an AJAX request to save the ticket detail
      fetch(url, {
        method: formData.get('_destroy') === '1' ? 'DELETE' : 'POST',
        body: formData
      });
    });
  }
}