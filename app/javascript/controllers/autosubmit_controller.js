// app/javascript/controllers/autosubmit_controller.js

import { Controller } from "@hotwired/stimulus"
import { debounce } from "helpers/frequency_helpers"

export default class extends Controller {
  static values = {
    delay: {
      type: Number,
      default: 0
    }
  }

  connect() {
    if (this.delayValue) {
      this.submit = debounce(this.submit.bind(this), this.delayValue)
    }
  }

  submit() {
    this.element.requestSubmit()
  }
}
