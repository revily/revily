module Revily::Event
  class Publisher
    include Revily::Log

    attr_reader :object, :account, :action, :source, :actor, :changeset

    class << self
      def publish(object)
        publisher = new(object)
        publisher.publish if publisher.publish?
        publisher
      end
    end

    def initialize(object)
      @object = object
      @source = @object
      @account = @object.account
      @action = @object.event_action
      @actor = Revily::Event.actor
      @changeset = Changeset.new(@object)
    end

    def publish?
      return false if Revily::Event.paused?
      return false if changeset.changes.empty?

      true
    end

    def publish
      create_event
      notify_subscriptions
    end

    def attributes
      { account: account, action: action, source: source, actor: actor, changeset: changeset }
    end

    def to_hash
      attributes
    end

    def hooks
      account.hooks + Revily::Event.hooks
    end

    private

    def create_event
      ::Event.create(self.attributes)
    end

    def subscriptions
      @subscriptions ||= SubscriptionList.new(action, source, actor, hooks).subscriptions
    end

    def notify_subscriptions
      subscriptions.each do |subscription|
        Metriks.timer("subscription.notify").time do
          subscription.notify
        end
      end
    end

  end
end
