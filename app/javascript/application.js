// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@fortawesome/fontawesome-free"

import "trix"
import "@rails/actiontext"

import flatpickr from "flatpickr"

// Import QuillJS
import Quill from 'quill'
import 'quill/dist/quill.snow.css'

// Initialize QuillJS
document.addEventListener('turbo:load', function() {
  const editors = document.querySelectorAll('.quill-editor');
  editors.forEach(function(editor) {
    const quill = new Quill(editor, {
      theme: 'snow',
      modules: {
        toolbar: [
          ['bold', 'italic', 'underline', 'strike'],
          ['blockquote', 'code-block'],
          [{ 'header': 1 }, { 'header': 2 }],
          [{ 'list': 'ordered'}, { 'list': 'bullet' }],
          [{ 'script': 'sub'}, { 'script': 'super' }],
          [{ 'indent': '-1'}, { 'indent': '+1' }],
          [{ 'direction': 'rtl' }],
          [{ 'size': ['small', false, 'large', 'huge'] }],
          [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
          [{ 'color': [] }, { 'background': [] }],
          [{ 'font': [] }],
          [{ 'align': [] }],
          ['clean'],
          ['link', 'image']
        ]
      }
    });

    // Get the form and input
    const form = editor.closest('form');
    const input = editor.previousElementSibling;

    // Set initial content if it exists
    if (input.value) {
      quill.root.innerHTML = input.value;
    }

    // Update hidden input before form submission
    form.addEventListener('submit', function() {
      input.value = quill.root.innerHTML;
    });

    // Update hidden input on content change
    quill.on('text-change', function() {
      input.value = quill.root.innerHTML;
    });
  });

  const datepickers = document.querySelectorAll('.datepicker');
  if (datepickers.length > 0) {
    flatpickr('.datepicker', {
      dateFormat: "Y-m-d",
      allowInput: true,
      altInput: true,
      altFormat: "F j, Y",
      static: true,
      onChange: function(selectedDates, dateStr) {
        const form = this.element.closest('form');
        if (form) form.submit();
      }
    });
  }
})