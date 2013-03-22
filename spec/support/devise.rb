RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  # config.include Devise::TestHelpers, type: :request

  config.include Warden::Test::Helpers, type: :controller
  # config.include Warden::Test::Helpers, type: :request

  config.before(:each) { Warden.test_mode! }
  config.after(:each) { Warden.test_reset! }
end
