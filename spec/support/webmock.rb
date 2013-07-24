require 'webmock/rspec'

RSpec.configure do |config|
  config.include WebMock::API
end
