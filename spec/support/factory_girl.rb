require 'factory_girl_rails'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before do
    FactoryGirl.reload
  end
end
