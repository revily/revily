module APIExampleGroup
  extend ActiveSupport::Concern
  include FactoryGirl::Syntax::Methods
  include Rack::Test::Methods
  include JsonSpec::Helpers
  include Rails.application.routes.url_helpers

  included do
    require 'rack/test'
    require 'json_spec'

    metadata[:type] = :api
    metadata[:api] = true

    before do
      header 'Content-Type', 'application/json'
      header 'Accept', 'application/json'
      # @routes = ::Rails.application.routes
    end

    subject { last_response }

    after do
    end
  end

  def app
    ::Rails.application
  end

  def body
    last_response.body
  end

  def headers
    last_response.headers
  end

end

RSpec.configure do |config|
  config.include APIExampleGroup,
    example_group: { file_path: %r[spec/api] }
end
