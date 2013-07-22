module Reveille
  module Event
    class Subscription
      include Reveille::Model

      attribute :name,   type: String
      attribute :event,  type: String
      attribute :config, type: Object, default: {}
      attribute :source, type: Object
      attribute :actor,  type: Object

      validates :name, :event, :source, presence: true

      def handler
        Handler.const_get(name.to_s.camelize, false)
      rescue NameError => e
        Rails.logger.debug "No event handler #{name.inspect} found."
      end

      def notify
        return false unless handler.supports?(event)
        
        options = { event: event, source: source, actor: actor, config: config }
        handler.notify(options)
      end

    end
  end
end
