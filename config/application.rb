require_relative "boot"
require "sprockets/railtie"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SigimIntegrationApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    I18n.available_locales = [:en, :"pt-BR"]
    I18n.default_locale = :"pt-BR"

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.encoding = "utf-8"
    config.time_zone = "America/Fortaleza"
    config.active_record.default_timezone = :local
    # config.eager_load_paths << Rails.root.join("extras")
    
    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = false
    
    # config.action_view.javascript_expansions[:defaults] = %w(jquery.min jquery_ujs)
    # Internacionalização Devise
    config.i18n.default_locale = :'pt-BR'

    OAuth2.configure do |config|
      config.silence_extra_tokens_warning = true # default: false
    end
    config.autoload_paths << "#{root}/assets/javascripts"
  end
end
