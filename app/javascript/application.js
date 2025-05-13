// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"

import flatpickr from "flatpickr"

document.addEventListener('DOMContentLoaded', function() {
  flatpickr('.datepicker', {
    enableTime: true,
    plugins: [ 
      new ConfirmDatePlugin({})
    ]
  })
})