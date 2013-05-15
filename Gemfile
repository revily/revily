source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.13'

gem 'active_attr'
gem 'active_model_serializers'
gem 'acts_as_list'
gem 'acts-as-taggable-on', '>= 2.3.3'
gem 'acts_as_tenant'
gem 'apipie-rails'
gem 'best_in_place'
gem 'client_side_validations'
gem 'client_side_validations-simple_form', github: 'davekrupinski/client_side_validations-simple_form'
gem 'clockwork', '>= 0.5.0', require: false
gem 'dalli', '>= 2.6.2'
gem 'devise', '>= 2.2.3'
gem 'draper'
gem 'figaro', '>= 0.6.3'
gem 'haml', '>= 4.0.0'
gem 'haml-rails', '>= 0.4'
gem 'hound'
gem 'ice_cube', '>= 0.10.0'
gem 'kaminari'
gem 'nested_form'
gem 'pg', '>= 0.14.1'
gem 'rack-timeout'
gem 'recipient_interceptor'
gem 'sidekiq', '>= 2.8.0'
gem 'simple_form', '>= 2.1.0'
gem 'sinatra', '>= 1.3.0', require: false
gem 'slim', '>= 1.3.6'
gem 'state_machine', '>= 1.1.2'
gem 'strong_parameters'
gem 'tabletastic'
gem 'twilio-ruby', '>= 3.9.0'
gem 'unicorn', '>= 4.6.2'
gem 'validates_existence'

# Assets and UI
gem 'sass-rails', '>= 3.2.6'
gem 'jquery-rails', '>= 2.2.1'

group :assets do
  gem 'bootstrap-datepicker-rails'
  gem 'bootstrap-sass'
  gem 'coffee-rails', '>= 3.2.2'
  gem 'ember-rails'
  gem 'font-awesome-sass-rails'
  gem 'jquery-ui-rails', '>= 4.0.1'
  gem 'jquery-validation-rails', '>= 1.10.0'
  gem 'select2-rails', '>= 3.3.1'
  gem 'sugar-rails', '>= 1.3.7'
  gem 'twitter-bootstrap-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'underscore-rails', '>= 1.4.3'
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'foreman', '>= 0.61.0'
  gem 'guard-rspec', '>= 2.4.1'
  gem 'guard-spork', '>= 1.5.0'
  gem 'guard-bundler'
  gem 'guard-annotate'
  gem 'guard-migrate'
  gem 'guard-shell'
  gem 'libnotify',  '>= 0.8.0', require: false
  gem 'pry-rails', '>= 0.2.2'
  gem 'rails-erd'
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'ruby_gntp', require: false
end

# Gems useful in both test and development environments
group :development, :test do
  gem 'awesome_print'
  gem 'factory_girl_rails', '>= 4.2.0'
  gem 'forgery', '>= 0.5.0'
  gem 'quiet_assets'
  gem 'rspec-rails'
  gem 'sham_rack'
end

group :test do
  gem 'capybara', '>= 2.0.2'
  gem 'coveralls', require: false
  gem 'database_cleaner', '>= 0.7.2'
  gem 'email_spec', '>= 1.4.0'
  gem 'json_spec', '>= 1.1.0'
  gem 'launchy'
  gem 'rspec_api_test'
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers', '>= 1.4.1'
  gem 'sms-spec', '>= 0.1.6'
  gem 'state_machine_rspec'
  gem 'timecop', '>= 0.6.1'
  gem 'twilio-test-toolkit', '>= 3.0.0'
end

group :staging, :production do
  gem 'airbrake'
  gem 'newrelic_rpm'
end
