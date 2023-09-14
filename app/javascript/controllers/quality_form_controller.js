import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="quality-form"
export default class extends Controller {
  static targets = [
    "templateSelect", "noteField",
    "metricCheckboxes", "currentAccount",
    "checkboxes", "ratingInput"
  ];
  
  connect() {
    this.updateFormFields();
    this.calculateScore();
  }
  
  updateFormFields() {
    const selectedTemplateId = this.templateSelectTarget.value;
    const currentAccount = this.currentAccountTarget.value;
    const ratingInput = this.ratingInputTarget;
    const baseUrl = window.location.origin;

    // Populate the form with qa_template note only if edit mode is false.
    const editing = window.isEditing;
    
    if (selectedTemplateId) {
       // Make an AJAX request to fetch the selected qa template data.
       fetch(`${baseUrl}/accounts/${currentAccount}/settings/qa_templates/${selectedTemplateId}.json`)
        .then((response) => response.json())
        .then((data) => {
        
          // Clear the existing checkboxes
          this.metricCheckboxesTarget.innerHTML = "";
          ratingInput.value = 100;

          // Populate the form with qa_template note only if not in edit mode
          if (!editing) {
            this.noteFieldTarget.value = data.note.content.body;
          }

          // Generate checkboxes for each metric in the qa_template
          data.metrics.forEach((metric) => {
            const checkBoxHtml = `
              <div class="mb-6 inline-flex">
                <label class="block">
                  <input type="checkbox" name="quality[metric_ids][]" value="${metric.deduction}" data-action="change->quality-form#updateScore" quality-form-target="checkboxes" data-description="${metric.description}">
                  ${metric.metric_name}
                </label>
              </div>
            `;
            this.metricCheckboxesTarget.insertAdjacentHTML("beforeend", checkBoxHtml);
          });
        });
    } else {
      // Clear the note and checkboxes if no template is selected.
      this.noteFieldTarget.value = '';
      this.metricCheckboxesTarget.innerHTML = '';
    }
  }

  calculateScore() {
    const metricCheckboxesElement = this.metricCheckboxesTarget; // Get the parent element
    const checkboxes = metricCheckboxesElement.querySelectorAll('input[type="checkbox"]'); // Get all child checkboxes
    const ratingInput = this.ratingInputTarget;
    const selectedDescriptions = []; // Initialize an array to store selected descriptions

    // let selectedDescriptions = []; // Create an array to store selected descriptions
    
    if (checkboxes) {
      let rating = 100; // Initialize with the base score

      checkboxes.forEach((checkbox) => {
        if (checkbox.checked) {
          // Subtract the checkbox value from the score if it's checked
          const checkboxValue = parseInt(checkbox.value)
          rating -= checkboxValue;

          // Append the description to the newNoteValue
          const metricDescription = checkbox.dataset.description;
          if (metricDescription) {
            selectedDescriptions.push(metricDescription);
          }

        }
      });

      if (ratingInput) {
        ratingInput.value = rating;
      }

      const newNoteValue = selectedDescriptions.join('\n');

      // Concatenate the selected descriptions with the existing value of noteFieldTarget
      const existingNoteValue = this.noteFieldTarget.value;
  
      // this.noteFieldTarget.value = existingNoteValue + (existingNoteValue ? '\n\n' : '') + `<div class="mb-6"><p>${newNoteValue}</p></div`;

      this.noteFieldTarget.value =  
      `<div class="mb-6"><p>${newNoteValue}</p></div><br/>` + (newNoteValue ? '\n\n' : '') + existingNoteValue;
    }
  }

  updateScore(event) {
    this.calculateScore();
  }
}