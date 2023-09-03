import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ["select"];
  connect() {
    console.log("Hello, Stimulus!", this.element);
    console.log(this.selectTarget.value);
  }
  filterAccounts() {
    const filter_by = this.selectTarget.value;
    // const url = `/accounts?filter_by=${filter_by}`;

    // Get the current URL
    const currentURL = new URL(window.location.href);

    // Update the 'filter_by' query parameter
    currentURL.searchParams.set("filter_by", filter_by);

    // Replace the current state in the browser's history
    window.history.replaceState({}, "", currentURL);

    // Send a Turbo Stream message to update the content
    const url = currentURL.toString();

    // Refresh the page
    // Turbo.visit(url);

    this.doTurboRequest(url);
  }

  doTurboRequest(url) {
    fetch(url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html",
      },
    })
      .then((response) => response.text())
      .then((html) => {
        Turbo.renderStreamMessage(html);
      });
  }
  update() {
    console.log("update");
    this.filterAccounts();
  }
}