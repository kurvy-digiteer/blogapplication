import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["display", "form"]

    connect() {
        console.log("comments_ controller connected!");
        if (this.hasDisplayTarget && this.hasFormTarget) {
            this.displayTarget.classList.remove("d-none")
            this.formTarget.classList.add("d-none")
        }
        this.element.addEventListener("turbo:frame-render", this.afterTurboUpdate.bind(this))
    }

    showForm() {
        if (this.hasDisplayTarget && this.hasFormTarget) {
            this.displayTarget.classList.add("d-none")
            this.formTarget.classList.remove("d-none")
        }
    }

    hideForm() {
        if (this.hasDisplayTarget && this.hasFormTarget) {
            this.displayTarget.classList.remove("d-none")
            this.formTarget.classList.add("d-none")
        }
    }

    afterTurboUpdate(event) {
        if (this.hasDisplayTarget && this.hasFormTarget) {
            this.displayTarget.classList.remove("d-none")
            this.formTarget.classList.add("d-none")
        }
    }
}