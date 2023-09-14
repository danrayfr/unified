import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="coaching-form"
export default class extends Controller {
  static targets = [
    "templateSelect", "noteField",
    "currentAccount", "selectBlock",
    "customCheckboxes", "checkboxes"
  ]

  connect() {
    if (!isEditing) {
      this.updateFormFields();
    } 
  }

  updateFormFields() {
    const selectedTemplate = this.templateSelectTarget.value;
    const currentAccount = this.currentAccountTarget.value;
    const baseUrl = window.location.origin;
    
    const isEditing = window.isEditing; // Check if @coaching.persisted?

    // Clear the existing checkboxes
    this.customCheckboxesTarget.innerHTML = "";

    if (selectedTemplate)
    {
      // Make AJAX request to fetch the selected coaching template data
      fetch(`${baseUrl}/accounts/${currentAccount}/settings/coaching_templates/${selectedTemplate}.json`)
      .then((response) => response.json())
      .then((data) => {

        console.log(data)

        // Populate the form with coaching template note if new record
        if (!isEditing) {
          this.noteFieldTarget.value = data.note.content.body;
        }

        // Generate checkboxes for each metric in the qa_template
        data.customs.forEach((custom) => {
          const checkBoxHtml = `

          <div class="nested-form-wrapper">
            <div>
              
              <div class="mt-10 grid grid-cols-1 gap-x-6 gap-y-8 sm:grid-cols-6 px-6 pb-6 border-2 border-gray-300 border-dashed rounded-md">

                <div class="sm:col-span-3 mt-3">
                  <label class="text-gray-600 mb-3">Custom Name</label>
                  <input type="text" name="custom_name[]" value="${custom.custom_name}" class="js-start-time%> w-full rounded-md border border-[#e0e0e0] bg-white py-3 px-6 text-base font-medium text-[#6B7280] outline-none focus:border-[#6A64F1] focus:shadow-md" />
                </div>

                <div class="col-span-full">
                  <label class="text-gray-600 mb-3">Content</label>
                  <textarea class="w-full rounded-lg border-gray-200 p-3 text-sm" placeholder="${custom.content}" rows="8" id="message" name="custom_content[]"></textarea>
                </div>   
              </div>
            </div>
          </div>
          `;
          this.customCheckboxesTarget.insertAdjacentHTML("beforeend", checkBoxHtml);
        });
      })
    } else {
      // Clear the note and checkboxes if no template is selected.
      this.noteFieldTarget.value = '';
      this.customCheckboxesTarget.innerHTML = '';
    }
  }
}
