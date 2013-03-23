module APIHelpers
  extend ActiveSupport::Concern
  include Rack::Test::Methods
  include JsonSpec::Helpers

  included do
    require 'rack/test'
    require 'json_spec'

    metadata[:api] = true

    before do
      header 'Content-Type', 'application/json'
      header 'Accept', 'application/json'
    end

    subject { last_response }
  end

  def body
    last_response.body
  end

  def json
    parse_json(body)
  end

  def headers
    last_response.headers
  end

  def serializer(obj)
    normalize_json(obj.active_model_serializer.new(obj).to_json)
  end

end

RSpec.configure do |config|
  def config.escaped_path(*parts)
    Regexp.compile(parts.join('[\\\/]') + '[\\\/]')
  end

  config.include APIHelpers,
    type: :request,
    example_group: { file_path: config.escaped_path(%w[spec (requests|integration|api)]) }
end
