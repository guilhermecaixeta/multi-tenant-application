# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join('vendor/assets/coreui/5.0.0')
Rails.application.config.assets.paths << Rails.root.join('vendor/assets/coreui/admin')
Rails.application.config.assets.paths << Rails.root.join('vendor/assets/coreui/icons-2')
Rails.application.config.assets.paths << Rails.root.join('vendor/assets/coreui/chartjs/4.0.0/dist/css')
Rails.application.config.assets.paths << Rails.root.join('vendor/assets/simplebar/core/1.4.2/dist')
Rails.application.config.assets.paths << Rails.root.join('vendor/assets/stylesheets/cakezone/scss')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w[ bootstrap.bundle.min.js
                                                  popper.min.js
                                                  jquery.min.js
                                                  index.js
                                                  admin.esm.js ]
