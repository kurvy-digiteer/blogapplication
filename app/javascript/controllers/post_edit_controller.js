import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "form"]

  showForm() {
    this.displayTarget.classList.add("d-none")
    this.formTarget.classList.remove("d-none")
  }

  hideForm() {
    this.displayTarget.classList.remove("d-none")
    this.formTarget.classList.add("d-none")
  }
} 