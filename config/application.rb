require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CryptoTeller
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    require 'crypto_teller'

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run 'rake -D time' for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Remove browser-related headers
    config.action_dispatch.default_headers = {
      'X-Content-Type-Options' => 'nosniff'
    }

    # Remove browser-related middleware
    [ 'ActionDispatch::Cookies',
      'ActionDispatch::Flash',
      'ActionDispatch::Session::CookieStore',
      'Rack::MethodOverride',
    ].each do |name|
      config.middleware.delete name
    end

    # Never use templates for displaying errors
    config.after_initialize do
      config.consider_all_requests_local = false
    end

    # Rescue unhandled exceptions with the application controller
    config.exceptions_app = lambda do |env|
      ExceptionsController.action(:unhandled_exception).call(env)
    end
  end
end
