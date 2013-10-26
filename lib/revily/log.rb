module Revily
  module Log
    extend ActiveSupport::Concern

    included do
    end

    # TODO(dryan): proper logger config
    def logger
      @logger ||= Rails.logger
    end
    
  end
end