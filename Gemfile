source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails',                               '4.0.0'

# current AMS is broken for rails 4; using github master
# gem 'active_model_serializers',            '0.8.1'
gem 'active_model_serializers',            github: 'rails-api/active_model_serializers'
gem 'acts_as_list',                        '0.2.0'
gem 'acts-as-taggable-on',                 '2.4.1'
gem 'acts_as_tenant',                      '0.3.1'
gem 'clockwork',                           '0.5.2', require: false
gem 'dalli',                               '2.6.4'
gem 'devise',                              github: 'plataformatec/devise'
gem 'draper',                              '1.2.1'
gem 'figaro',                              '0.7.0'
gem 'ice_cube',                            '0.11.0'
gem 'kaminari',                            '0.14.1'
gem 'pg',                                  '0.15.1'
gem 'rack-timeout',                        '0.0.4'
gem 'recipient_interceptor',               '0.1.1'
gem 'sidekiq',                             '2.12.4'
gem 'sinatra',                             '1.4.3', require: false
gem 'slim',                                '2.0.0', require: false
gem 'state_machine',                       '1.2.0'
gem 'twilio-ruby',                         '3.9.0'
gem 'unicorn',                             '4.6.3'
gem 'validates_existence',                 '0.8.0'

group :development do
  gem 'annotate',                          '2.5.0'
  gem 'bullet',                            '4.6.0'
  gem 'foreman',                           '0.63.0'
  gem 'spork-rails',                       github: 'sporkrb/spork-rails'
  gem 'guard-rspec',                       '3.0.2'
  gem 'guard-spork',                       '1.5.1'
  gem 'guard-shell',                       '0.5.1'
  gem 'libnotify',                         '0.8.1', require: false
  gem 'pry-rails',                         '0.3.1'
  gem 'rb-fsevent',                        '0.9.3', require: false
  gem 'rb-inotify',                        '0.9.0', require: false
  gem 'ruby_gntp',                         '0.3.4', require: false
end

# Gems useful in both test and development environments
group :development, :test do
  gem 'awesome_print',                     '1.1.0'
  gem 'factory_girl_rails',                '4.2.1'
  gem 'forgery',                           '0.5.0'
  gem 'rspec-rails',                       '2.13.2'
  gem 'sham_rack',                         '1.3.6'
end

group :test do
  gem 'capybara',                          '2.1.0'
  gem 'database_cleaner',                  '1.0.1'
  gem 'email_spec',                        '1.4.0'
  gem 'json_spec',                         '1.1.1'
  gem 'launchy',                           '2.3.0'
  gem 'rspec_api_test',                    '0.0.1'
  gem 'rspec-sidekiq',                     '0.3.0'
  gem 'shoulda-matchers',                  '2.2.0', require: false
  gem 'sms-spec',                          '0.1.7'
  gem 'state_machine_rspec',               '0.1.2'
  gem 'timecop',                           '0.6.1'
  gem 'twilio-test-toolkit',               '3.2.0'
end

group :staging, :production do
  gem 'airbrake',                          '3.1.12'
  gem 'newrelic_rpm',                      '3.6.5.130'
end

group :doc do
  gem 'yard'
  gem 'redcarpet'
  gem 'yard-restful'
end
