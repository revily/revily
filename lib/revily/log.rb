require "logger"

module Revily
  module Log
    
    def self.included(base)
      base.extend(self)
    end

    def self.init(channel = STDOUT)
      old = @logger
      @logger = Logger.new(channel)
      @logger.level = Logger::INFO
      old.close if old
      @logger
    end

    def self.logger
      @logger || init
    end

    def self.logger=(log)
      @logger = (log ? log : Logger.new("/dev/null"))
    end

    def logger
      Revily::Log.logger
    end
 
    def to_log
      if respond_to?(:attributes)
        self.attributes.inject([]) { |a, (k,v)| a << "#{k}=#{stringify(v)}" }.join(" ")
      else
        self.inspect
      end
    end

    private

    def stringify(object)
      if defined?(ActiveRecord) && object.kind_of?(ActiveRecord::Base)
        object.class.name.demodulize.underscore
      else
        object.inspect
      end
    end

  end
end
