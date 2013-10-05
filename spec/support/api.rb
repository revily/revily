require 'rack/test'
require 'json_spec'

module APIHelpers
  extend ActiveSupport::Concern
  include ::Rack::Test::Methods
  include ::JsonSpec::Helpers
  include Rails.application.routes.url_helpers
  
  included do
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

  def response
    last_response
  end

  def request
    RequestProxy.new(last_request.env)
  end

  class RequestProxy
    # require 'forwardable'
    # extend Forwardable

    attr_accessor :request, :headers
    # def_delegators :@request, :content_type, :body, 

    def initialize(request)
      @request = ActionDispatch::Request.new(request)
      @headers = ActionDispatch::Http::Headers.new(request)
    end

    def method_missing(meth, *args, &block)
      if @request.respond_to?(meth)
        @request.send(meth, *args, &block)
      else
        super
      end
    end

    def respond_to?(meth)
      @request.respond_to?(meth)
    end
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

  def collection_serializer(collection)
    # normalize_json(PaginationSerializer.new(collection).to_json)
    normalize_json(collection.active_model_serializer.new(collection).to_json)
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
