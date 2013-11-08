module Revily
  module Event
    class Publisher
      include Revily::Log

      attr_reader :object, :account, :action, :source, :actor

      def self.publish(object)
        publisher = new(object)
        publisher.publish if publisher.publish?
        publisher
      end

      def initialize(object)
        @object = object
        @source = @object
        @account = @object.account
        @action = @object.event_action
        @actor = Revily::Event.actor
      end

      def publish?
        return false if Revily::Event.paused?
        return false if changeset.changes.empty?

        true
      end

      def publish
        # return false unless publish?

        ::Event.create(
          account: account,
          action: action,
          source: source,
          actor: actor,
          changeset: changeset
        )
      end

      def changeset
        @changeset ||= Changeset.new(object)
      end

    end
  end
end
