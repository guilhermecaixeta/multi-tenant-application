# frozen_string_literal: true
# typed: true

require_relative 'boot'
require_relative '../lib/middleware/site_interceptor'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BusinessManager
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    config.exceptions_app = routes

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks middleware])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Brasilia'

    # i18n
    config.i18n.default_locale = 'pt-BR'
    config.i18n.load_path += Rails.root.glob('config/locales/**/*.{rb,yml}')

    # Paths
    config.autoload_paths << Rails.root.join('app/constraints')
    config.autoload_paths << Rails.root.join('app/models/validators')
    config.autoload_paths << Rails.root.join('app/models/callbacks')
    config.autoload_paths << Rails.root.join('lib/errors')

    # Jobs
    config.active_job.queue_adapter = :sidekiq

    # Middlewares
    config.middleware.insert_after Warden::Manager,
                                   Middleware::SiteInterceptor

    # Authorization
    config.x.authorization.allowed_routes_pattern = '(^(backoffice|devise\/users)|.*(backoffice).*)'
    config.x.authorization.default_roles = [
      { name: 'Administrator',
        admin: true,
        except_permissions: [] },
      { name: 'Operator',
        admin: false,
        except_permissions: [
          /^(?:backoffice::(applicationmanagement|organizationmanagement)).*/i,
          /(backoffice::usersettings::users::(?!(?:update|edit)(?:profile|security))\w+\b)/i
        ] }
    ]

    # Attachments

    config.x.attachment.allowed_formats_for_images = %w[image/png image/jpeg image/jpeg]
    config.x.attachment.max_image_size = 5.megabytes

    # FeatureFlag
    config.x.feature_flag.service = { enabled: true,
                                      sales: { enabled: false } }
    config.x.feature_flag.product = { enabled: true }
    config.x.feature_flag.about = { enabled: true }
    config.x.feature_flag.contact = { enabled: true,
                                      send_message: { enabled: false } }
    config.x.feature_flag.team = { enabled: false }
    config.x.feature_flag.offer = { enabled: false }
    config.x.feature_flag.fact = { enabled: false }
    config.x.feature_flag.testimonial = { enabled: false }
    config.x.feature_flag.video_modal = { enabled: false }
    config.x.feature_flag.feed = { enabled: false }
  end
end
