import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="username"
export default class extends Controller {
  static targets = ["field"];

  preventAtSign(event) {
    if (event.key === '@') {
      event.preventDefault();
    }
  }
}
