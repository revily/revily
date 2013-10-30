module Revily
  module Event
    class Job
      include Revily::Model

      autoload :Campfire,                   "revily/event/job/campfire"
      autoload :Incident,                   "revily/event/job/incident"
      autoload :IncidentAcknowledge,        "revily/event/job/incident_acknowledge"
      autoload :IncidentAcknowledgeTimeout, "revily/event/job/incident_acknowledge_timeout"
      autoload :IncidentAutoResolveTimeout, "revily/event/job/incident_auto_resolve_timeout"
      autoload :IncidentEscalationTimeout,  "revily/event/job/incident_escalation_timeout"
      autoload :IncidentResolve,            "revily/event/job/incident_resolve"
      autoload :IncidentTrigger,            "revily/event/job/incident_trigger"
      autoload :Log,                        "revily/event/job/log"
      autoload :Test,                       "revily/event/job/test"
      autoload :Web,                        "revily/event/job/web"

      attribute :payload, type: Object
      attribute :params, type: Object, default: {}

      validates :payload, presence: true
      validates :params, presence: true

      class << self
        def run(queue, payload, params)
          args = { payload: payload, params: params }
          options = { queue: queue, retries: 8, backtrace: true }
          Revily::Sidekiq.run(self, :perform, options, args)
        end

        def schedule(queue, interval, payload, params)
          args = { payload: payload, params: params }
          options = { queue: queue, retries: 8, backtrace: true, at: timestamp_for(interval) }
          Revily::Sidekiq.schedule(self, :perform, options, args)
        end

        def perform(*args)
          new(*args).run
        end

        def timestamp_for(interval)
          interval = interval.to_f
          now = Time.now.to_f

          interval < 1_000_000_000 ? now + interval : interval
        end
        private :timestamp_for
      end

      def run
        if valid?
          timeout after: (params[:timeout] || 60) do
            process
          end
        else
          logger.error "#{self.class.name} had errors: #{self.errors.full_messages.join(', ')}"

          return false
        end
      end

      def process
        logger.warn "Override #process in a subclass"
      end

      def active_model_serializer
        JobSerializer
      end

      def event
        payload[:event]
      end

      def source
        @source ||= find_association(:source)
      end

      def actor
        @actor ||= find_association(:actor)
      end

      def find_association(association_name)
        association_name = association_name.to_s

        payload[association_name]["type"].constantize.find_by(uuid: payload[association_name]["id"])
      end

      private

      def account
        @account ||= payload["account"]
      end

      def timeout(options = { after: 60 }, &block)
        Timeout::timeout(options[:after], &block)
      end

    end
  end
end
