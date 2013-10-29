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

  module Event
    autoload :Handler,               "revily/event/handler"
    class Handler
      autoload :Campfire,            "revily/event/handler/campfire"
      autoload :Incidents,           "revily/event/handler/incidents"
      autoload :IncidentAcknowledge, "revily/event/handler/incident_acknowledge"
      autoload :IncidentResolve,     "revily/event/handler/incident_resolve"
      autoload :IncidentTrigger,     "revily/event/handler/incident_trigger"
      autoload :Log,                 "revily/event/handler/log"
      autoload :Test,                "revily/event/handler/test"
      autoload :Web,                 "revily/event/handler/web"
    end

    autoload :Notifier,              "revily/event/notifier"
    class Notifier
      autoload :Email,               "revily/event/notifier/sms"
      autoload :Phone,               "revily/event/notifier/sms"
      autoload :Sms,                 "revily/event/notifier/sms"
    end

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