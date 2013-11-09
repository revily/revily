module Revily::Event
  class SubscriptionList

    attr_reader :action, :source, :actor, :hooks

    def initialize(action, source, actor, hooks=[])
      @action = action
      @source = source
      @actor = actor
      @hooks = hooks
    end

    def subscriptions
      @subscriptions ||= hooks.map do |hook|
        options = {
          name:   hook.handler,
          config: hook.config,
          source: source,
          actor:  actor,
          event:  format_event(action, source)
        }
        subscription = Subscription.new(options)
        subscription if subscription.handler?
      end.compact
    end

    def format_event(action, source)
      namespace = source.class.name.underscore.gsub("/", ".")
      [namespace, action].join(".")
    end

  end
end
