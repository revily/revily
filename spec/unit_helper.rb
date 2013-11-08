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
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "app"))
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  require "revily"

  Revily::Log.logger = nil
  
  require "dotenv"
  Dotenv.load ".env.#{ENV['RAILS_ENV']}", ".env"

  require "rspec"
  require "support/fire"
  require "timecop"

  RSpec.configure do |config|
    config.mock_with :rspec
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.order = "random"
    config.run_all_when_everything_filtered = true
    config.filter_run focus: true
    config.filter_run_excluding external: true
    config.backtrace_exclusion_patterns << /vendor\//
    config.backtrace_exclusion_patterns << /lib\/rspec\//
  end
end

def run
  load_all "spec/support/fire",
           "spec/support/matchers/**/*.rb",
           "spec/support/mixins/**/*.rb"
end

if defined?(Spork)
  Spork.prefork { configure }
  Spork.each_run { run }
else
  configure
  run
end
