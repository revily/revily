require "metriks"

module Revily
  autoload :ApiConstraints,          "revily/api_constraints"
  autoload :Config,                  "revily/config"
  autoload :Event,                   "revily/event"
  autoload :Log,                     "revily/log"
  autoload :Model,                   "revily/model"
  autoload :ServiceObject,           "revily/service_object"
  autoload :Sidekiq,                 "revily/sidekiq"

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

end
