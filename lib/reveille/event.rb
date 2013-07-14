require 'active_support/core_ext/string/inflections'

module Reveille
  module Event
    autoload :Handler,      'reveille/event/handler'
    autoload :Subscription, 'reveille/event/subscription'

    SUBSCRIBERS = %w( log )

    class << self
      def subscriptions
        @subscriptions ||= subscribers.map do |name|
          subscription = Event::Subscription.new(name)
          subscription if subscription.subscriber
        end.compact
      end

      def dispatch(event, *args)
        subscriptions.each do |subscription|
          subscription.notify(event, *args)
        end
      end

      def subscribers
        (SUBSCRIBERS) # + self.account.notifications)
      end
    end

    def dispatch(event, *args)
      Reveille::Event.dispatch(formatted_event(event, self), self, *args)
    end

    protected

      def formatted_event(event, object)
        event = "#{event}ed".gsub(/eded$|eed$/, 'ed') unless [ :log, :ready ].include?(event)
        namespace = object.class.name.underscore.gsub('/', ':')
        [namespace, event].join(':')
      end

  end
end
