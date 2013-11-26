module Support
  module Routing

    def params(*args)
      params = {}
      args.each do |arg|
        params[arg] = "1"
      end
      params
    end

    def json_params(*args)
      params = params(*args)
      params[:format] = :json
      params
    end
  end
end

RSpec.configure do |config|
  config.include Support::Routing, type: :routing
end
