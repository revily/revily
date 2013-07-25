require 'devise/test_helpers'
require 'warden/test/helpers'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :controller

  config.before(:each) { Warden.test_mode! }
  config.after(:each) { Warden.test_reset! }
end
