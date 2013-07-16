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

        def supports_events=(*events)
          @supports_events = events.flatten.uniq
        end

        def supports_events(*events)
          @supports_events ||= []
          @supports_events.concat(events.flatten).uniq! unless events.blank?
          @supports_events.delete_if { |e| !all_events.include?(e) }

          return @supports_events
        end

        def supports?(event)
          # puts all_supported_events.inspect
          all_supported_events.include?(event)
        end

        def all_supported_events
          all_supported_events = []
          
          all_events.each do |all|
            supports_events.each do |support|
              all_supported_events << all if /^#{support}$/.match(all)
            end
          end

          all_supported_events.compact.uniq
        end

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
