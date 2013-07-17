module Reveille
  module Event
    class Subscription
      class << self
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
        self.class.handlers[name.to_sym] || Handler.const_get(name.to_s.camelize, false)
      rescue NameError => e
        Rails.logger.info "No event handler #{name.inspect} found."
      end

      def notify(event, source)
        if handler.supports?(event)
          # if matches?(event)
          handler.notify(event, source, config)
          # increment_counter(event)
        end
      end

    end
  end
end
