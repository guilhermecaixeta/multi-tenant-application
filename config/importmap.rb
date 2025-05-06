# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap
pin '@rails/request.js', to: '@rails--request.js.js' # @0.0.9
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'application'
pin 'backoffice'
pin 'site'

pin 'jquery', to: 'https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js'
pin '@popperjs/core',
    to: 'https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/esm/popper.min.js', preload: true
pin 'bootstrap',
    to: 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js', preload: true

pin 'chart.js', to: 'https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js'
pin '@kurkle/color', to: 'https://cdn.jsdelivr.net/npm/@kurkle/color@0.3.2/dist/color.esm.min.js'

pin 'simplebar', to: 'https://cdn.jsdelivr.net/npm/simplebar@6.2.5/dist/simplebar.min.js' # @6.2.5

# https://fullcalendar.io/docs/initialize-browser-esm
pin '@fullcalendar/core', to: 'https://cdn.skypack.dev/@fullcalendar/core@6.1.11' # 6.1.11
pin '@fullcalendar/daygrid', to: 'https://cdn.skypack.dev/@fullcalendar/daygrid@6.1.11' # 6.1.11
pin '@fullcalendar/timegrid', to: 'https://cdn.skypack.dev/@fullcalendar/timegrid@6.1.11' # 6.1.11
pin '@fullcalendar/list', to: 'https://cdn.skypack.dev/@fullcalendar/list@6.1.11' # 6.1.11

# https://coreui.io/bootstrap/docs/getting-started/download/
pin '@coreui/coreui', to: 'https://cdn.jsdelivr.net/npm/@coreui/coreui@5.0.2/dist/js/coreui.bundle.min.js',
                      preload: true
pin '@coreui/chartjs', to: 'https://cdn.jsdelivr.net/npm/@coreui/chartjs@4.0.0/dist/js/coreui-chartjs.min.js'
pin '@coreui/utils', to: 'https://cdn.jsdelivr.net/npm/@coreui/utils@2.0.2/dist/umd/index.js'
pin '@coreui/icons', to: 'https://cdn.jsdelivr.net/npm/@coreui/icons@3.0.1/dist/esm/index.js'
pin '@coreui/admin', to: 'coreui/admin/dist/admin.esm.js'

# Action Text
pin 'trix'
pin '@rails/actiontext', to: 'actiontext.esm.js'

# Site vendor
pin '@cakezone/main', to: 'cakezone/js/main.js'
pin '@cakezone/easing', to: 'cakezone/lib/easing/easing.min.js'
pin '@cakezone/counterup', to: 'cakezone/lib/counterup/counterup.min.js'
pin '@cakezone/waypoints', to: 'cakezone/lib/waypoints/waypoints.min.js'
pin '@cakezone/owlcarousel', to: 'cakezone/lib/owlcarousel/owl.carousel.min.js'
