module Revily
  module Event
    class Publisher
      include Revily::Log

      autoload :RecordChange, "revily/event/publisher/record_change"
      autoload :StateChange, "revily/event/publisher/state_change"

      attr_reader :object, :account, :action, :source, :actor

      def self.publish(object)
        publisher = new(object)
        publisher.publish
        publisher
      end

      def initialize(object)
        @object = object
        @source = @object
        @account = @object.account
        @action = @object.event_action
        @actor = Revily::Event.actor
      end

      def publish
        ::Event.create(
          account: account,
          action: action,
          source: source,
          actor: actor,
          changeset: changeset
        )
      end

      def changeset
        logger.warn "override Publisher#changeset in a subclass"
      end

    end
  end
end