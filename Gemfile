source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.13'

gem 'pg', '>= 0.14.1'
gem 'activerecord-postgres-hstore'
gem 'hstore-attributes'
gem 'dalli', '>= 2.6.2'
gem 'rack-timeout'
gem 'airbrake'
gem 'state_machine', '>= 1.1.2'
gem 'acts-as-taggable-on', '>= 2.3.3'
gem 'twilio-ruby', '>= 3.9.0'
gem 'ice_cube', '>= 0.10.0'
gem 'devise', '>= 2.2.3'
gem 'haml-rails', '>= 0.4'
gem 'haml', '>= 4.0.0'
gem 'figaro', '>= 0.6.3'
gem 'simple_form', '>= 2.1.0'
gem 'hound'
gem 'strong_parameters'
gem 'recipient_interceptor'
gem 'draper'
gem 'active_model_serializers'
gem 'squeel'
gem 'acts_as_list'
gem 'validates_existence'
gem 'kaminari'
gem 'acts_as_tenant'
gem 'active_attr'
gem 'tabletastic'
gem 'nested_form'
gem 'best_in_place'
gem 'client_side_validations'
gem 'client_side_validations-simple_form', github: 'davekrupinski/client_side_validations-simple_form'

gem 'apipie-rails'

# Service
gem 'unicorn', '>= 4.6.2'

# Sidekiq
gem 'sidekiq', '>= 2.8.0'
gem 'slim', '>= 1.3.6'
gem 'sinatra', '>= 1.3.0', require: false
gem 'clockwork', '>= 0.5.0', require: false

# Assets and UI
gem 'sass-rails', '>= 3.2.6'
gem 'jquery-rails', '>= 2.2.1'
gem 'jquery-ui-rails', '>= 4.0.1'
gem 'select2-rails', '>= 3.3.1'
gem 'underscore-rails', '>= 1.4.3'
gem 'backbone-rails'
gem 'jquery-validation-rails', '>= 1.10.0'
gem 'sugar-rails', '>= 1.3.7'

group :assets do
  gem 'coffee-rails', '>= 3.2.2'
  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass'
  gem 'twitter-bootstrap-rails'
  gem 'bootswatch-rails'
  gem 'bootstrap-datepicker-rails'
  gem 'font-awesome-sass-rails'
  # gem 'bootstrap-x-editable-rails'
end

group :development do
  gem 'binding_of_caller'
  gem 'foreman', '>= 0.61.0'
  gem 'better_errors'

  gem 'rails-erd'
  gem 'pry-rails', '>= 0.2.2'
  gem 'annotate'
  # Guard
  gem 'guard-rspec', '>= 2.4.1'
  gem 'guard-spork', '>= 1.5.0'
  gem 'guard-bundler'
  gem 'guard-annotate'
  gem 'guard-migrate'
  gem 'guard-shell'
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'ruby_gntp', require: false
  gem 'libnotify',  '>= 0.8.0', require: false
  gem 'bullet'
end

# Gems useful in both test and development environments
group :development, :test do
  gem 'factory_girl_rails', '>= 4.2.0'
  gem 'rspec-rails'
  gem 'forgery', '>= 0.5.0'
  gem 'sham_rack'
  gem 'quiet_assets'
  gem 'awesome_print'
  # gem 'mocha', require: false
end

group :test do
  gem 'shoulda-matchers', '>= 1.4.1' #, github: 'danryan/shoulda-matchers'
  gem 'json_spec', '>= 1.1.0'
  gem 'database_cleaner', '>= 0.7.2'
  gem 'capybara', '>= 2.0.2'
  gem 'timecop', '>= 0.6.1'
  gem 'twilio-test-toolkit', '>= 3.0.0'
  gem 'sms-spec', '>= 0.1.6'
  gem 'email_spec', '>= 1.4.0'
  gem 'rspec_api_test'
  gem 'state_machine_rspec'
  gem 'launchy'
  gem 'coveralls', require: false
  gem 'rspec-sidekiq'
end

group :staging, :production do
  gem 'newrelic_rpm'
  gem 'airbrake'
end
