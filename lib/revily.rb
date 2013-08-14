module Revily
  autoload :ApiConstraints, 'revily/api_constraints'
  autoload :Config,         'revily/config'
  autoload :Event,          'revily/event'
  autoload :Log,            'revily/log'
  autoload :Model,          'revily/model'
  autoload :Sidekiq,        'revily/sidekiq'

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
