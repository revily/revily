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

      attr_reader :name

      def initialize(name)
        @name = name
      end

      def subscriber
        self.class.handlers[name.to_sym] || Handler.const_get(name.to_s.camelize, false)
      rescue NameError => e
        puts "No event handler #{name.inspect} found."
      end

      def notify(event, *args)
        if matches?(event)
          subscriber.notify(event, *args)
          # increment_counter(event)
        end
      end

      def patterns
        Array(subscriber::EVENTS)
      end

      def matches?(event)
        patterns.any? { |patterns| patterns.is_a?(Regexp) ? patterns.match(event) : patterns == event }
      end
    end
  end
end