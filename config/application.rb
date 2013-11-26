require File.expand_path("../boot", __FILE__)

# require "rails/all"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"

# Require the gems listed in Gemfile, including any gems
# you"ve limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Revily
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework      :rspec, view_specs: false, helper_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
      # g.template_engine     :haml
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

    config.assets.paths << Rails.root.join("vendor", "assets", "components")

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "UTC"
    config.active_record.default_timezone = :utc
    # config.i18n.load_path += Dir[Rails.root.join("my", "locales", "*.{rb,yml}").to_s]
    # config.i18n.default_locale = :de
    # Configure the default encoding used in templates for Ruby >= 1.9.
    config.encoding = "utf-8"

    # route all exceptions via our router
    config.exceptions_app = self.routes

    config.action_mailer.delivery_method = (ENV["MAILER_DELIVERY_METHOD"].to_sym || :smtp)

    ENV["REDIS_URL"] ||= "redis://localhost:6379/0"
    config.cache_store = :redis_store, (ENV["REVILY_REDIS_CACHE_URL"] || "#{ENV["REDIS_URL"]}/0/cache")
  end
end

# autoload :Revily, "revily"
