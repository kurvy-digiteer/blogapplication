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

    afterTurboUpdate(event) {
        // After a Turbo Stream update, always hide the form and show the comment body
        if (this.hasFormTarget && this.hasDisplayTarget) {
            this.formTarget.classList.add("d-none")
            this.displayTarget.classList.remove("d-none")
        }
    }

    connect() {
        // Listen for Turbo Stream updates to this comment frame
        this.element.addEventListener("turbo:frame-render", this.afterTurboUpdate.bind(this))
    }
}
