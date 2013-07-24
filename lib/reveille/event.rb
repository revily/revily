require 'active_support/core_ext/string/inflections'
require 'active_support/hash_with_indifferent_access'

module Reveille
  module Event
    # include Celluloid
    # include Celluloid::Notifications

    autoload :EventList,         'reveille/event/event_list'
    autoload :Handler,           'reveille/event/handler'
    autoload :HandlerSerializer, 'reveille/event/handler_serializer'
    autoload :HandlerMixin,      'reveille/event/handler_mixin'
    autoload :Hook,              'reveille/event/hook'
    autoload :HookSerializer,    'reveille/event/hook_serializer'
    autoload :Job,               'reveille/event/job'
    autoload :JobSerializer,     'reveille/event/job_serializer'
    autoload :Matcher,           'reveille/event/matcher'
    autoload :Mixins,            'reveille/event/mixins'
    autoload :Payload,           'reveille/event/payload'
    autoload :PayloadSerializer, 'reveille/event/payload_serializer'
    autoload :Subscription,      'reveille/event/subscription'

    class << self

      attr_accessor :paused

      def actor
        RequestStore.store[:current_actor]
      end

      def actor=(actor)
        RequestStore.store[:current_actor] = actor
      end

      def pause!
        @paused = true
      end

      def unpause!
        @paused = false
      end

      def pause(&block)
        @paused = true
        block.call if block_given?
        @paused = false
      end

      def paused?
        @paused ||= false
      end

      def handlers
        @handlers ||= hash_from_constant(Event::Handler)
      end

      def jobs
        @jobs ||= hash_from_constant(Event::Job)
      end

      def hooks
        @hooks ||= hash_from_constant(Event::Hook).values.uniq.map(&:new)
      end

      # Due to Rails' preference for autoloading, we call every source here
      # because I have no idea what I'm doing.
      def sources
        @sources ||= Hash[{
                            incident: ::Incident,
                            policy: ::Policy,
                            policy_rule: ::PolicyRule,
                            schedule: ::Schedule,
                            schedule_layer: ::ScheduleLayer,
                            service: ::Service,
                            user: ::User
        }.sort].with_indifferent_access
      end

      def events
        @events ||= sources.map do |name, klass|
          klass.events.map do |event|
            "#{name}.#{event}"
          end
        end.flatten.sort.uniq
      end
      alias_method :all, :events

      def hash_from_constant(constant)
        Hash[constant.constants(false).map { |c| [c.to_s.underscore, constant.const_get(c)] }.sort]
      end
      private :hash_from_constant
    end
  end
end
