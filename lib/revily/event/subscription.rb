module Revily
  module Event
    class Subscription
      include Revily::Model
      include Revily::Log

      attribute :name,   type: String
      attribute :event,  type: String
      attribute :config, type: Object, default: {}
      attribute :source, type: Object
      attribute :actor,  type: Object

      validates :name, :event, :source, presence: true

      def handler
        @handler ||= Revily::Event.handlers.fetch(name.to_sym)
      rescue KeyError => e
        logger.debug "No event handler #{name.inspect} found."
        return nil
      end

      def notify
        # return false unless handler && handler.supports?(event)
        return false unless handler.supports?(event)
        
        options = { event: event, source: source, actor: actor, config: config }
        handler.notify(options)
      end

      def handler?
        !!handler
      end

    end
  end
end
