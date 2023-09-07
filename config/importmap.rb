# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'stimulus-rails-nested-form', to: 'https://ga.jspm.io/npm:stimulus-rails-nested-form@4.1.0/dist/stimulus-rails-nested-form.mjs'
pin 'local-time', to: 'https://ga.jspm.io/npm:local-time@2.1.0/app/assets/javascripts/local-time.js'
pin 'trix'
pin '@rails/actiontext', to: 'actiontext.js'
pin 'stimulus-dropdown', to: 'https://ga.jspm.io/npm:stimulus-dropdown@2.1.0/dist/stimulus-dropdown.mjs'
pin 'hotkeys-js', to: 'https://ga.jspm.io/npm:hotkeys-js@3.12.0/dist/hotkeys.esm.js'
pin 'stimulus-use', to: 'https://ga.jspm.io/npm:stimulus-use@0.51.3/dist/index.js'
