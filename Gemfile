source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails',                               '3.2.13'
gem 'active_attr',                         '0.8.0'
gem 'active_model_serializers',            '0.8.1'
gem 'acts_as_list',                        '0.2.0'
gem 'acts-as-taggable-on',                 '2.4.1'
gem 'acts_as_tenant',                      '0.2.9'
gem 'apipie-rails',                        '0.0.21'
gem 'best_in_place',                       '2.1.0'
gem 'client_side_validations',             '3.2.5'
gem 'client_side_validations-simple_form', github: 'davekrupinski/client_side_validations-simple_form'
gem 'clockwork',                           '0.5.0', require: false
gem 'dalli',                               '2.6.3'
gem 'devise',                              '2.2.4'
gem 'draper',                              '1.2.1'
gem 'figaro',                              '0.6.4'
gem 'haml',                                '4.0.2'
gem 'haml-rails',                          '0.4'
gem 'hound',                               '0.3.0'
gem 'ice_cube',                            '0.10.0'
gem 'kaminari',                            '0.14.1'
gem 'nested_form',                         '0.3.2'
gem 'pg',                                  '0.15.1'
gem 'rack-timeout',                        '0.0.4'
gem 'recipient_interceptor',               '0.1.1'
gem 'sidekiq',                             '2.11.2'
gem 'simple_form',                         '2.1.0'
gem 'sinatra',                             '1.3.6', require: false
gem 'slim',                                '1.3.8'
gem 'state_machine',                       '1.2.0'
gem 'strong_parameters',                   '0.2.1'
gem 'tabletastic',                         '0.2.3'
gem 'twilio-ruby',                         '3.9.0'
gem 'unicorn',                             '4.6.2'
gem 'validates_existence',                 '0.8.0'

# Assets and UI
gem 'sass-rails',                          '3.2.6'
gem 'jquery-rails',                        '2.2.1'

group :assets do
  gem 'bootstrap-datepicker-rails',        '1.0.0.7'
  gem 'bootstrap-sass',                    '2.3.1.0'
  gem 'coffee-rails',                      '3.2.2'
  gem 'ember-rails',                       '0.12.0'
  gem 'ember-auth-rails',                  '4.0.1'
  gem 'font-awesome-sass-rails',           '3.0.2.2'
  gem 'jquery-ui-rails',                   '4.0.1'
  gem 'jquery-validation-rails',           '1.11.0'
  gem 'select2-rails',                     '3.3.1'
  gem 'sugar-rails',                       '1.3.7'
  gem 'twitter-bootstrap-rails',           '2.2.6'
  gem 'uglifier',                          '2.1.0'
  gem 'underscore-rails',                  '1.4.4'
end

group :development do
  gem 'annotate',                          '2.5.0'
  gem 'better_errors',                     '0.8.0'
  gem 'binding_of_caller',                 '0.7.1'
  gem 'bullet',                            '4.6.0'
  gem 'foreman',                           '0.63.0'
  gem 'guard-rspec',                       '3.0.0'
  gem 'guard-spork',                       '1.5.0'
  gem 'guard-bundler',                     '1.0.0'
  gem 'guard-annotate',                    '1.1.0'
  gem 'guard-migrate',                     '0.1.7'
  gem 'guard-shell',                       '0.5.1'
  gem 'libnotify',                         '0.8.0', require: false
  gem 'pry-rails',                         '0.3.0'
  gem 'rails-erd',                         '1.1.0'
  gem 'rb-fsevent',                        '0.9.3', require: false
  gem 'rb-inotify',                        '0.9.0', require: false
  gem 'ruby_gntp',                         '0.3.4', require: false
end

# Gems useful in both test and development environments
group :development, :test do
  gem 'awesome_print',                     '1.1.0'
  gem 'factory_girl_rails',                '4.2.1'
  gem 'forgery',                           '0.5.0'
  gem 'quiet_assets',                      '1.0.2'
  gem 'rspec-rails',                       '2.13.1'
  gem 'sham_rack',                         '1.3.6'
end

group :test do
  gem 'capybara',                          '2.1.0'
  gem 'coveralls',                         '0.6.7', require: false
  gem 'database_cleaner',                  '1.0.1'
  gem 'email_spec',                        '1.4.0'
  gem 'json_spec',                         '1.1.0'
  gem 'launchy',                           '2.3.0'
  gem 'rspec_api_test',                    '0.0.1'
  gem 'rspec-sidekiq',                     '0.3.0'
  gem 'shoulda-matchers',                  '2.1.0'
  gem 'sms-spec',                          '0.1.6'
  gem 'state_machine_rspec',               '0.1.2'
  gem 'timecop',                           '0.6.1'
  gem 'twilio-test-toolkit',               '3.1.0'
end

group :staging, :production do
  gem 'airbrake',                          '3.1.12'
  gem 'newrelic_rpm',                      '3.6.2.96'
end
