require "active_support/core_ext/string/inflections"
require "active_support/core_ext/hash/indifferent_access"

module Revily
  module Event
    # include Celluloid
    # include Celluloid::Notifiers

    autoload :Changeset,         "revily/event/changeset"
    autoload :EventList,         "revily/event/event_list"
    autoload :Handler,           "revily/event/handler"
    autoload :HandlerSerializer, "revily/event/handler_serializer"
    autoload :HandlerMixin,      "revily/event/handler_mixin"
    autoload :Hook,              "revily/event/hook"
    autoload :HookSerializer,    "revily/event/hook_serializer"
    autoload :Job,               "revily/event/job"
    autoload :JobSerializer,     "revily/event/job_serializer"
    # autoload :Matcher,           "revily/event/matcher"
    autoload :Notifier,          "revily/event/notifier"
    autoload :Payload,           "revily/event/payload"
    autoload :PayloadSerializer, "revily/event/payload_serializer"
    autoload :Publisher,         "revily/event/publisher"
    autoload :Subscription,      "revily/event/subscription"

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

      # Due to Rails" preference for autoloading, we call every source here
      # because I have no idea what I"m doing.
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

      def actors
        @actors ||= Hash[{
          service: ::Service,
          user: ::User
        }.sort].with_indifferent_access
      end
      
      def events
        @events ||= sources.map do |name, klass|
          klass.actions.map do |action|
            "#{name}.#{action}"
          end
        end.flatten.sort.uniq
      end
      alias_method :all, :events

      def hash_from_constant(constant)
        Hash[constant.constants(false).map do |c|
          const = constant.const_get(c)
          next if const.abstract?
          [const.key, const]
        end.compact.sort].with_indifferent_access
      end
      private :hash_from_constant
    end
  end
end
