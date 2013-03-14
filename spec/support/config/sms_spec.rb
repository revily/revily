require 'sms_spec'

RSpec.configure do |config|
  config.include(SmsSpec::Helpers)
  config.include(SmsSpec::Matchers)
end
