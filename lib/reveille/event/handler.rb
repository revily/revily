module Reveille
  module Event
    class Handler
      include HandlerMixin

      autoload :Campfire, 'reveille/event/handler/campfire'
      autoload :IncidentTrigger, 'reveille/event/handler/incident_trigger'
      autoload :Log,      'reveille/event/handler/log'
      autoload :Test,     'reveille/event/handler/test'
      autoload :Web,      'reveille/event/handler/web'

      class << self        
        def notify(event, source, config)
          handler = new(event, source, config)
          handler.notify if handler.handle?
        end

        def events=(*events)
          @events = events.flatten.uniq
        end

        def events(*events)
          return @events unless events.present?
          matched_events ||= Event::EventList.new(events).events
          @events ||= []
          @events.concat(matched_events).uniq! unless events.blank?
          @events.delete_if { |e| !all_events.include?(e) }

          return @events
        end

        def matches?(pattern)
          supports?(pattern)
        end
        
        def supports?(pattern)
          matcher = Event::Matcher.new(pattern, events)
          matcher.matches?(pattern)
        end

        alias_method :matches?, :supports?

        def all_events
          all_events = []
          
          all_events.each do |all|
            events.each do |support|
              all_events << all if /^#{support}$/.match(all)
            end
          end

          all_events.compact.uniq.sort
        end

        # def events
          # @events ||= Event::Matcher.new(events, all_events).matches
        # end

        def all_events
          Reveille::Event.events
        end
      end

      attr_reader :event, :source, :data

      def initialize(event, source, config)
        @event   = event
        @source  = source
        @config  = config
      end

      def notify
        handle
      end

      def payload
        @payload ||= Payload.new(event, source)
      end

      def handle
        raise StandardError, "override #handle in subclass #{self.class.name}"
      end

      def handle?
        raise StandardError, "override #handle in subclass #{self.class.name}"
      end

      private

        def account
          @account ||= source.try(:account)
        end

    end
  end
end
