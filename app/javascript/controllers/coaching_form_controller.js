import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="coaching-form"
export default class extends Controller {
  static targets = [
    "templateSelect", "noteField", "currentAccount"
  ]
  connect() {
    this.updateFormFields();
  }

  updateFormFields() {
    const selectedTemplate = this.templateSelectTarget.value;
    const currentAccount = this.currentAccountTarget.value;
    const baseUrl = window.location.origin;
    
    const isEditing = window.isEditing; // Check if @coaching.persisted?

    const fetchURL = `${baseUrl}/accounts/${currentAccount}/coaching_templates/${selectedTemplate}.json`

    if (selectedTemplate)
    {
      // Make AJAX request to fetch the selected coaching template data
      fetch(`${baseUrl}/accounts/${currentAccount}/coaching_templates/${selectedTemplate}.json`)
      .then((response) => response.json())
      .then((data) => {

        // Populate the form with coaching template note if new record
        if (!isEditing) {
          this.noteFieldTarget.value = data.note.content.body;
        }
      })
    }

    const targets = `
      "Template Id": ${selectedTemplate},

      "Current Account": ${currentAccount},

      "Base URL": ${baseUrl},

      "Editing": ${isEditing},

      "Fetch URL": ${fetchURL}
    `;

    // console.log(targets);
  }
}
