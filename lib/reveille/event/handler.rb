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

      # @!attribute [rw] event
      #   @return [String] formatted event string
      attribute :event,   type: String
      # @!attribute [rw] source
      #   @return [Incident, Policy, PolicyRule, Schedule, ScheduleLayer, Service, User ] The event source
      attribute :source,  type: Object
      #!@attribute [rw] actor
      #   @return [User, Service] The event actor
      attribute :actor,   type: Object
      #!@attribute [rw] config
      #   @return [Hash] The hook config
      attribute :config,  type: Object, default: {}
      #!@attribute [rw] params
      #   @return [Hash] Additional params that alter a handler
      attribute :params,  type: Object, default: {}

      # @!group Validations
      validates :event, :source, presence: true
      validates :payload, presence: true
      # @!endgroup
      class << self
        # def queue(queue=nil)
        #   @queue = queue
        #   attribute :queue, type: String, default: queue
        #   return @queue
        # end

        # Initializes and notify a handler
        # @param [Hash] options The attributes used to initialize the handler
        # @option options [String] :event The formatted event string of the event
        # @option options [Incident, Policy, PolicyRule, Schedule, ScheduleLayer, Service, User ] :source The source of the event
        # @option options [User, Service] :actor The actor of the event
        # @option options [Hash] :config Configuration hash from the hook
        # @option options [Hash] :params Additional parameters to alter how the handler handles the event
        def notify(options)
          handler = new(options)
          handler.notify if handler.valid? && handler.handle?
          # handler
        end

        # Set or return the list of supported event types

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
          timer = Metriks.timer('handler.supports?')
          t = timer.time
          matcher = Event::Matcher.new(pattern, events)
          supports = matcher.matches?(pattern)
          t.stop

          supports
        end
        alias_method :matches?, :supports?
        alias_method :support?, :supports?
      end

      def active_model_serializer
        HandlerSerializer
      end

      # queue 'default'

      # Wrapper method around {#handle} to allow subclasses to override that method
      def notify
        # logger.debug "handling #{name}: #{to_log}"
        # logger.debug "processing payload: #{payload.to_hash.inspect}"
        Metriks.timer('handler.handle').time do
          handle
        end
      end

      # Pushes a job onto the queue
      #
      # @param [Class]  job Subclass of the Job to run
      # @param [Symbol] queue Name of the queue
      def run(job, queue=:default)
        Metriks.timer('handler.job.run').time do
          job.run(queue, payload, params)
        end
      end

      # Pushes a job onto the queue scheduled at a later time
      #
      # @param [Class]  job Subclass of the Job to run
      # @param [Integer] interval Number of seconds from now to schedule a job
      # @param [Symbol] queue Name of the queue
      def schedule(job, interval, queue=:default)
        Metriks.timer('handler.job.schedule').time do
          job.schedule(queue, interval, payload, params)
        end
      end

      def payload
        @payload ||= Payload.new(event: event, source: source, actor: actor)
      end

      # @abstract Subclass and override {#handle} to implement
      def handle
        raise StandardError, "override #handle in subclass #{self.class.name}"
      end

      # @abstract Subclass and override {#handle?} to implement
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
