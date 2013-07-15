module Reveille
  module Event
    class Handler
      include HandlerMixin

      autoload :Campfire, 'reveille/event/handler/campfire'
      autoload :Log,      'reveille/event/handler/log'
      autoload :Test,     'reveille/event/handler/test'
      autoload :Web,      'reveille/event/handler/web'

      class << self
        def notify(event, object, config)
          handler = new(event, object, config)
          handler.notify if handler.handle?
        end

        def default_events(*events)
          if events.empty?
            @default_events ||= []
          else
            @default_events = events.flatten.uniq
          end
        end
      end

      attr_reader :event, :object, :data

      def initialize(event, object, config)
        @event   = event
        @object  = object
        @config  = config
      end

      def notify
        handle
      end

      def payload
        @payload ||= {}
      end

      def handle
        raise StandardError, "override #handle in subclass #{self.class.name}"
      end

      def handle?
        raise StandardError, "override #handle in subclass #{self.class.name}"
      end

      private

        def account
          @account ||= object.try(:account)
        end

    end
  end
end
