module Revily
  module Log
    extend ActiveSupport::Concern

    included do
    end

    # TODO(dryan): proper logger config
    def logger
      @logger ||= Rails.logger.dup
    end

    def to_log
      if respond_to?(:attributes)
        self.attributes.inject([]) { |a, (k,v)| a << "#{k}=#{stringify(v)}" }.join(' ')
      else
        self.inspect
      end
    
    end


    private

    def stringify(object)
      object.kind_of?(ActiveRecord::Base) ? object.class.name.demodulize.underscore : object.inspect
    end
    
  end
end
