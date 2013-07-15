module Reveille
  module Event
    class Subscription
      class << self
        def register(name, const)
          handlers[name.to_sym] = const
        end

        def handlers
          @handlers ||= {}
        end
      end

      attr_reader :name, :events, :config

      def initialize(hook)
        @name   = hook.name
        @events = hook.events
        @config = hook.config
      end

      def handler
        # Handler.const_get(name.to_s.camelize, false)
        self.class.handlers[name.to_sym] || Handler.const_get(name.to_s.camelize, false)
      rescue NameError => e
        Rails.logger.info "No event handler #{name.inspect} found."
      end

      def notify(event, object)
        if matches?(event)
          handler.notify(event, object, config)
          # increment_counter(event)
        end
      end

      def matches?(event)
        events.any? { |events| /^#{events}$/i.match(event) }
      end
    end
  end
end