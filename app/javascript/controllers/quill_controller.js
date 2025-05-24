import { Controller } from "@hotwired/stimulus"
import Quill from "quill"

export default class extends Controller {
  static targets = ["editor", "input"]

  connect() {
    // Valid Quill toolbar config
    console.log("Quill: Editor target found!");
    const toolbarOptions = [
      ['bold', 'italic', 'underline'],
      ['link'],
      [{ 'list': 'ordered'}, { 'list': 'bullet' }]
    ];

    if (!this.hasEditorTarget) {
      console.error("Quill: Editor target not found!");
      return;
    }

    this.quill = new Quill(this.editorTarget, {
      theme: "snow",
      modules: {
        toolbar: toolbarOptions
      }
    });

    // Set initial content if any
    if (this.hasInputTarget && this.inputTarget.value) {
      this.quill.root.innerHTML = this.inputTarget.value;
    }

    // Update hidden input on text-change
    this.quill.on("text-change", () => {
      if (this.hasInputTarget) {
        this.inputTarget.value = this.quill.root.innerHTML;
      }
    });
  }

  disconnect() {
    if (this.quill) {
      this.quill = null;
    }
  }
} 