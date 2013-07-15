require 'active_support/core_ext/string/inflections'
require 'active_support/hash_with_indifferent_access'

module Reveille
  module Event
    # include Celluloid
    # include Celluloid::Notifications

    autoload :Handler,      'reveille/event/handler'
    autoload :HandlerMixin, 'reveille/event/handler_mixin'
    autoload :Job,          'reveille/event/job'
    autoload :Subscription, 'reveille/event/subscription'

    class << self
      def handlers
        @handlers ||= Event::Handler.constants.inject({}.with_indifferent_access) do |hash, const|
          hash[const.downcase] = Event::Handler.const_get(const)
          hash
        end
      end

      def jobs
        @jobs ||= Event::Job.constants.inject({}.with_indifferent_access) do |hash, const|
          hash[const.downcase] = Event::Job.const_get(const)
          hash
        end
      end

      def events_hash
        {
          all:            %w[ .* ],
          contact:        %w[ contact.* contact.created contact.updated contact.deleted contact.notified ],
          incident:       %w[ incident.* incident.triggered incident.acknowledged incident.resolved ],
          policy:         %w[ policy.* policy.created policy.updated policy.deleted ],
          policy_rule:    %w[ policy_rule.* policy_rule.created policy_rule.updated policy_rule.deleted ],
          schedule:       %w[ schedule.* schedule.created schedule.updated schedule.deleted ],
          schedule_layer: %w[ schedule_layer.* schedule_layer.created schedule_layer.updated schedule_layer.deleted ],
          service:        %w[ service.* service.created service.updated service.deleted ],
          user:           %w[ user.* user.created user.updated user.deleted ]
        }
      end

      def all_events
        events_hash.values.flatten.sort
      end
    end

    def hooks
      self.account.hooks.active
    end

    def subscriptions
      @subscriptions ||= hooks.map do |hook|
        subscription = Event::Subscription.new(hook)
        subscription if subscription.handler
      end.compact
    end

    def dispatch(event, *args)
      formatted_event = format_event(event, self)
      subscriptions.each do |subscription|
        subscription.notify(formatted_event, self, *args)
      end
      # Reveille::Event.dispatch(formatted_event(event, self), self, *args)
    end

    protected

      def format_event(event, object)
        event = "#{event}ed".gsub(/eded$|eed$/, 'ed') unless [:log, :ready].include?(event)
        namespace = object.class.name.underscore.gsub('/', '.')
        [namespace, event].join('.')
      end

  end
end
