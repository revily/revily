require 'twilio-test-toolkit'

RSpec.configure do |config|
  config.include TwilioTestToolkit::DSL
end
