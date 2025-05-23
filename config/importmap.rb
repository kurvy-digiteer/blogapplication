# Pin npm packages by running ./bin/importmap

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@fortawesome/fontawesome-free", to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-free@6.4.0/js/all.js"
pin "trix"
pin "@rails/actiontext", to: "actiontext.js"
pin "flatpickr", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/esm/index.js"
pin "flatpickr/dist/flatpickr.css", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/flatpickr.css"
pin "flatpickr/dist/esm/plugins/confirmDate", to: "flatpickr/plugins/confirmDate.js"
pin "application", to: "application.js"
pin "quill", to: "https://esm.sh/quill@1.3.7/dist/quill.js"
