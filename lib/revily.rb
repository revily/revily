require "metriks"
require "active_support/hash_with_indifferent_access"

module Revily
  autoload :ApiConstraints,          "revily/api_constraints"
  autoload :Config,                  "revily/config"
  autoload :Event,                   "revily/event"
  autoload :Log,                     "revily/log"
  autoload :Model,                   "revily/model"
  autoload :ServiceObject,           "revily/service_object"
  autoload :Sidekiq,                 "revily/sidekiq"
  autoload :Twilio,                  "revily/twilio"
  
  module Concerns
    autoload :Actable,               "revily/concerns/actable"
    autoload :Eventable,             "revily/concerns/eventable"
    autoload :Hookable,              "revily/concerns/hookable"
    autoload :Identifiable,          "revily/concerns/identifiable"
    autoload :Trackable,             "revily/concerns/trackable"
    autoload :StateChange,           "revily/concerns/state_change"
  end

  class << self
    def handlers
      Event.handlers
    end

    def jobs
      Event.jobs
    end

    def hooks
      Event.hooks
    end

    def events
      Event.events
    end


  end

  def self.logger
    Revily::Log.logger
  end

  def self.logger=(log)
    Revily::Log.logger = log
  end

end

# if defined?(Rails)
#   Revily.logger = Rails.logger.dup
# end
