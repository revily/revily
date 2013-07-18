module Reveille
  module Event
    class Handler
      include Reveille::Model
      include HandlerMixin

      autoload :Campfire,            'reveille/event/handler/campfire'
      autoload :IncidentAcknowledge, 'reveille/event/handler/incident_acknowledge'
      autoload :IncidentResolve,     'reveille/event/handler/incident_resolve'
      autoload :IncidentTrigger,     'reveille/event/handler/incident_trigger'
      autoload :Log,                 'reveille/event/handler/log'
      autoload :Test,                'reveille/event/handler/test'
      autoload :Web,                 'reveille/event/handler/web'

      attribute :event,   type: String
      attribute :source,  type: Object
      attribute :config,  type: Object, default: {}
      # attribute :payload, type: Object, default: {}
      attribute :params,  type: Object, default: {}

      validates :event, :source, presence: true

      validates :payload, presence: true
      class << self
        # def queue(queue=nil)
        #   @queue = queue
        #   attribute :queue, type: String, default: queue
        #   return @queue
        # end

        def notify(options)
          handler = new(options)
          handler.notify if handler.valid? && handler.handle?
          handler
        end

        def events=(*events)
          @events = events.flatten.uniq
        end

        def events(*events)
          return @events unless events.present?
          matched_events ||= Event::EventList.new(events).events
          @events ||= []
          @events.concat(matched_events).uniq! unless events.blank?

          return @events
        end

        def supports?(pattern)
          matcher = Event::Matcher.new(pattern, events)
          matcher.matches?(pattern)
        end
        alias_method :matches?, :supports?
      end

      def active_model_serializer
        HandlerSerializer
      end

      # queue 'default'

      def notify
        logger.debug "handling #{name}: #{to_log}"
        logger.debug "processing payload: #{payload.to_hash.inspect}"

        handle
      end

      # TODO(dryan): make handlers use this in #handle
      # def run(job, queue=nil)
      #   queue = queue || self.queue
      #   puts queue
      #   # job.run(queue, payload: payload, params: params)
      # end

      def payload
        @payload ||= Payload.new(event: event, source: source).to_hash
      end

      def handle
        raise StandardError, "override #handle in subclass #{self.class.name}"
      end

      def handle?
        raise StandardError, "override #handle in subclass #{self.class.name}"
      end

      def name
        self.class.name.demodulize.underscore
      end

      def account
        @account ||= source.try(:account)
      end

    end
  end
end
