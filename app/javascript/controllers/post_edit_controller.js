import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "form"]

  connect() {
    console.log("post_edit controller connected!");
    if (this.hasDisplayTarget && this.hasFormTarget) {
      this.displayTarget.classList.remove("d-none")
      this.formTarget.classList.add("d-none")
    }
  }

  showForm() {
    console.log("SHOW FORM!");
    if (this.hasDisplayTarget && this.hasFormTarget) {
      this.displayTarget.classList.add("d-none")
      this.formTarget.classList.remove("d-none")
    }
  }

  hideForm() {
    console.log("HIDE FORM!");
    if (this.hasDisplayTarget && this.hasFormTarget) {
      this.displayTarget.classList.remove("d-none")
      this.formTarget.classList.add("d-none")
    }
  }
} 