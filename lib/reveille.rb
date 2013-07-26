module Reveille
  autoload :ApiConstraints, 'reveille/api_constraints'
  autoload :Config,         'reveille/config'
  autoload :Event,          'reveille/event'
  autoload :Log,            'reveille/log'
  autoload :Model,          'reveille/model'
  autoload :Sidekiq,        'reveille/sidekiq'

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
