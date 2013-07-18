module Reveille
  module Event
    class Subscription
      include Reveille::Model

      attribute :name,   type: String
      attribute :event,  type: String
      attribute :config, type: Object, default: {}
      attribute :source, type: Object

      validates :name, :event, :source,  presence: true

      def handler
        Handler.const_get(name.to_s.camelize, false)
      rescue NameError => e
        Rails.logger.debug "No event handler #{name.inspect} found."
      end

      def notify
        options = { event: event, source: source, config: config}.with_indifferent_access
        logger.debug "subscription invalid: #{to_log}" and return false unless valid?
        logger.debug "handler not supported: #{to_log}" and return false unless handler.supports?(event)
        logger.debug "notifying handler: #{to_log}"

        handler.notify(options)
      end

    end
  end
end
