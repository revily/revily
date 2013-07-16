module Reveille
  module Event
    class Job
      autoload :Campfire,            'reveille/event/job/campfire'
      autoload :IncidentAcknowledge, 'reveille/event/job/incident_acknowledge'
      autoload :IncidentEscalate,    'reveille/event/job/incident_escalate'
      autoload :IncidentResolve,     'reveille/event/job/incident_resolve'
      autoload :IncidentRetrigger,   'reveille/event/job/incident_retrigger'
      autoload :IncidentTrigger,     'reveille/event/job/incident_trigger'
      autoload :Log,                 'reveille/event/job/log'
      autoload :Test,                'reveille/event/job/test'
      autoload :Web,                 'reveille/event/job/web'

      class << self
        def run(queue, *args)
          options = { queue: queue, retries: 8, backtrace: true }
          Reveille::Sidekiq.run(self, :perform, options, *args)
        end

        def schedule(queue, interval, *args)
          options = { queue: queue, retries: 8, backtrace: true, at: timestamp_for(interval) }
          Reveille::Sidekiq.schedule(self, :perform, options, *args)
        end

        def perform(*args)
          new(*args).run
        end

        def timestamp_for(interval)
          interval = interval.to_f
          now = Time.now.to_f
          
          interval < 1_000_000_000 ? now + interval : interval
        end
      end

      attr_reader :payload, :params

      def initialize(payload, params={})
        @payload = payload
        @params = params
      end

      def run
        timeout after: params[:timeout] || 60 do
          process
        end
      end

      def process
        raise StandardError, "override #process in subclass #{self.class.name}"
      end

      private

        def account
          @account ||= payload['account']
        end

        def timeout(options = { after: 60 }, &block)
          Timeout::timeout(options[:after], &block)
        end

    end
  end
end
