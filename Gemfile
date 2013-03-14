source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'pg', '>= 0.14.1'
gem 'dalli', '>= 2.6.2'
gem 'state_machine', '>= 1.1.2'
gem 'acts-as-taggable-on', '>= 2.3.3'
gem 'twilio-ruby', '>= 3.9.0'
gem 'ice_cube', '>= 0.10.0'
gem 'devise', '>= 2.2.3'
gem 'postmark-rails', '>= 0.4.1'
gem 'haml-rails', '>= 0.4'
gem 'haml', '>= 4.0.0'
gem 'figaro', '>= 0.6.3'
gem 'simple_form', '>= 2.1.0'

# Web server
gem 'unicorn', '>= 4.6.2'
gem 'foreman', '>= 0.61.0'

# Sidekiq
gem 'sidekiq', '>= 2.8.0'
gem 'slim', '>= 1.3.6'
gem 'sinatra', '>= 1.3.0', :require => false
gem 'clockwork', '>= 0.5.0', :require => false

# Assets
group :assets do
  gem 'coffee-rails', '>= 3.2.2'
  gem 'uglifier', '>= 1.0.3'
end

gem 'sass-rails', '>= 3.2.6'
gem 'bootstrap-sass', '>= 2.3.0.1'
gem 'compass-rails', '>= 1.0.3'
# gem 'zurb-foundation'
gem 'jquery-rails', '>= 2.2.1'
gem 'jquery-ui-rails', '>= 4.0.1'
gem 'select2-rails', '>= 3.3.1'
gem 'underscore-rails', '>= 1.4.3'
gem 'jquery-validation-rails', '>= 1.10.0'
gem 'sugar-rails', '>= 1.3.7'

# Gems useful in both test and development environments
group :development, :test do
  gem 'factory_girl_rails', '>= 4.2.0'
  gem 'forgery', '>= 0.5.0'
end

group :test do
  gem 'rspec-rails', '>= 2.13.0'
  gem 'shoulda-matchers', '>= 1.4.1'
  gem 'json_spec', '>= 1.1.0'
  gem 'database_cleaner', '>= 0.7.2'
  gem 'capybara', '>= 2.0.2'
  gem 'timecop', '>= 0.6.1'
  gem 'twilio-test-toolkit', '>= 3.0.0'
  gem 'sms-spec', '>= 0.1.6'
  gem 'email_spec', '>= 1.4.0'
end

group :development do
  gem 'pry-rails', '>= 0.2.2'

  gem 'guard-rspec', '>= 2.4.1'
  gem 'guard-spork', '>= 1.5.0'

  gem 'rb-fsevent', :require => false
  gem 'rb-inotify', :require => false

  gem 'ruby_gntp', :require => false
  gem 'libnotify',  '>= 0.8.0', :require => false
end