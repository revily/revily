require 'rubygems'
require 'spork'

ENV["RAILS_ENV"] ||= 'test'

Spork.prefork do
  # http://my.rails-royce.org/2012/01/14/reloading-models-in-rails-3-1-when-usign-spork-and-cache_classes-true/
  require 'rails/application'

  # Prevent main application to eager_load in the prefork block (do not load files in autoload_paths)
  Spork.trap_method(Rails::Application, :eager_load!)

  # Load all railties files
  require File.expand_path("../../config/environment", __FILE__)

  Rails.application.railties.all { |r| r.eager_load! }


  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.use_transactional_fixtures = false
    config.infer_base_class_for_anonymous_controllers = false
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.order = "random"
  end
end

Spork.each_run do
  load "#{Rails.root}/config/routes.rb"
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
end
