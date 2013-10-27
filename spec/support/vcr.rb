require 'vcr'

VCR.configure do |config|
  config.configure_rspec_metadata!
  
  config.filter_sensitive_data("$SECRET_TOKEN") { ENV['SECRET_TOKEN'] }
  config.filter_sensitive_data("$TWILIO_ACCOUNT_SID") { ENV['TWILIO_ACCOUNT_SID'] }
  config.filter_sensitive_data("$TWILIO_APPLICATION_SID") { ENV['TWILIO_APPLICATION_SID'] }
  config.filter_sensitive_data("$TWILIO_AUTH_TOKEN") { ENV['TWILIO_AUTH_TOKEN'] }
  config.filter_sensitive_data("$TWILIO_NUMBER") { ENV['TWILIO_NUMBER'] }
  config.filter_sensitive_data("$MAILER_URL") { ENV['MAILER_URL'] }
  config.filter_sensitive_data("$MAILER_DELIVERY_METHOD") { ENV['MAILER_DELIVERY_METHOD'] }
  config.filter_sensitive_data("$MAILER_SENDER") { ENV['MAILGUN_API_KEY'] }
  config.filter_sensitive_data("$MAILGUN_DOMAIN") { ENV['MAILGUN_DOMAIN'] }
  config.filter_sensitive_data("$NEWRELIC_LICENSE_KEY") { ENV['NEWRELIC_LICENSE_KEY'] }

  config.cassette_library_dir = 'spec/fixtures/casettes'
  config.hook_into :webmock
end
