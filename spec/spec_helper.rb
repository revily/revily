unless ENV["CI"]
  require "spork"
end

ENV["RAILS_ENV"] ||= "test"

def load_all(*patterns)
  patterns.each { |pattern| Dir[pattern].sort.each {|path| load File.expand_path(path) } }
end

def require_all(*patterns)
  options = patterns.pop
  patterns.each { |pattern| Dir[pattern].sort.each { |path| require path.gsub(/^#{options[:relative_to]}\//, "") } }
end

def configure
  require File.expand_path("../../config/environment", __FILE__)
  # http://my.rails-royce.org/2012/01/14/reloading-models-in-rails-3-1-when-usign-spork-and-cache_classes-true/
  require "rails/application"
  require "rspec/rails"

  # Rails.application.railties.all { |r| r.eager_load! }
  # Spork.trap_method(Rails::Application, :eager_load!) if defined?(Spork)

  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)
  ActiveRecord::Base.logger = Logger.new("/dev/null")
  
  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = false
    config.infer_base_class_for_anonymous_controllers = false
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.order = "random"
    config.run_all_when_everything_filtered = true
    config.filter_run focus: true
    config.filter_run_excluding external: true, ignore: true
    config.backtrace_exclusion_patterns << /vendor\//
    config.backtrace_exclusion_patterns << /lib\/rspec\/rails/
  end

  # require_all "spec/support/**/*.rb", relative_to: "spec"
  # load_all "spec/support/**/*.rb" #, relative_to: "spec"
end


if defined?(Spork)
  Spork.prefork { configure }
  Spork.each_run { load_all "spec/support/**/*.rb", "lib/**/*.rb", "config/routes.rb" }
else
  configure
  load_all "spec/support/**/*.rb", "lib/**/*.rb", "config/routes.rb"
end
