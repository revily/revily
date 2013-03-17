require 'shoulda/matchers/integrations/rspec'

RSpec.configure do |config|
  config.include Shoulda::Matchers::ActionController, type: :routing
end
