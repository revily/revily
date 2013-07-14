module Reveille
  module Event
    class Handler
      autoload :Log, 'reveille/event/handler/log'

      class << self

        def notify(event, object, data = {})
          payload = nil
          handler = new(event, object, data, payload)
          handler.notify if handler.handle?
        end

      end

      attr_reader :event, :object, :data, :payload

      def initialize(event, object, data = {}, payload = nil)
        @event   = event
        @object  = object
        @data    = data
        @payload = payload
      end

      def notify
        handle
      end

      def handle
        raise StandardError, "override #handle in subclass #{self.class.name}"
      end

      def handle?
        raise StandardError, "override #handle in subclass #{self.class.name}"
      end

      private

        def account
          @account ||= object.account
        end

    end
  end
end
