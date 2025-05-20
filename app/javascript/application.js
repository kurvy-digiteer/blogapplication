// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@fortawesome/fontawesome-free"

import "trix"
import "@rails/actiontext"

import flatpickr from "flatpickr"

document.addEventListener('turbo:load', function() {
  const datepickers = document.querySelectorAll('.datepicker');
  if (datepickers.length > 0) {
    flatpickr('.datepicker', {
      dateFormat: "Y-m-d",
      allowInput: true,
      altInput: true,
      altFormat: "F j, Y",
      static: true,
      onChange: function(selectedDates, dateStr) {
        // Automatically submit the form when a date is selected, no more filter button
        const form = this.element.closest('form');
        if (form) form.submit();
      }
    });
  }
})