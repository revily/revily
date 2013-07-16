require 'active_support/core_ext/string/inflections'
require 'active_support/hash_with_indifferent_access'

module Reveille
  module Event
    # include Celluloid
    # include Celluloid::Notifications

    autoload :Handler,      'reveille/event/handler'
    autoload :HandlerMixin, 'reveille/event/handler_mixin'
    autoload :Hook,         'reveille/event/hook'
    autoload :Job,          'reveille/event/job'
    autoload :Subscription, 'reveille/event/subscription'

    class << self
      def handlers
        @handlers ||= hash_from_constant(Event::Handler)
      end

      def jobs
        @jobs ||= hash_from_constant(Event::Job)
      end

      def hooks
        @hooks ||= hash_from_constant(Event::Hook)
      end

      # Due to Rails' preference for autoloading, we call every source here because I have no idea
      # what I'm doing.
      def sources
        @sources ||= Hash[{
          incident: Incident,
          policy: Policy,
          policy_rule: PolicyRule,
          schedule: Schedule,
          schedule_layer: ScheduleLayer,
          service: Service,
          user: User
        }.sort].with_indifferent_access
      end

      def events
        @events ||= begin
          array = %w[ * ]
          sources.each do |name, klass|
            keys = klass.events.map {|event| "#{name}.#{event}" }
            array.concat %W[ #{name}.* ]
            array.concat keys
            array
          end
          array.sort
        end
      end

      def events_hash
        {
          all:            %w[ * ],
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

      def hash_from_constant(constant)
        Hash[constant.constants(false).inject({}) do |hash, const|
          hash[const.to_s.underscore] = constant.const_get(const)
          hash
        end.sort].with_indifferent_access
      end

      private :hash_from_constant
    end

    def hooks
      self.account.hooks.active
    end

    # TODO(dryan): how do we add default global hooks, like incident handling?
    def subscriptions
      @subscriptions ||= hooks.map do |hook|
        subscription = Event::Subscription.new(hook)
        subscription if subscription.handler
      end.compact
    end

    # Global subscriptions, for things that are not customized per-account (triggering, logging, etc) 
    def global_subscriptions
    end

    def dispatch(event, *args)
      subscriptions.each do |subscription|
        subscription.notify(format_event(event, self), self, *args)
      end
    end

    protected

      def format_event(event, object)
        # event = "#{event}ed".gsub(/eded$|eed$/, 'ed') unless [:log, :ready].include?(event)
        namespace = object.class.name.underscore.gsub('/', '.')
        [namespace, event].join('.')
      end

  end
end
