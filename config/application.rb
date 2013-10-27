require File.expand_path('../boot', __FILE__)

# require 'rails/all'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Revily
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework      :rspec, view_specs: false, helper_specs: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.template_engine     :haml
      g.javascript_engine   false
      g.helper              false
      g.stylesheets         false
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W[
      #{config.root}/lib
    ]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run 'rake -D time' for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.action_mailer.delivery_method = (ENV['MAILER_DELIVERY_METHOD'].to_sym || :smtp)

    ENV['REDIS_URL'] ||= "redis://localhost:6379/0" 
    config.cache_store = :redis_store, (ENV['REVILY_REDIS_CACHE_URL'] || "#{ENV['REDIS_URL']}/0/cache")
  end
end

autoload :Revily, 'revily'
