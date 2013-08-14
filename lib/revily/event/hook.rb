module Revily
  module Event
    class Hook
      include Revily::Model

      autoload :IncidentAcknowledge, 'revily/event/hook/incident_acknowledge'
      autoload :IncidentResolve,     'revily/event/hook/incident_resolve'
      autoload :IncidentTrigger,     'revily/event/hook/incident_trigger'
      autoload :Log,                 'revily/event/hook/log'
      autoload :Test,                'revily/event/hook/test'

      class << self
        def hook_name(name=nil)
          return @hook_name if name.blank?
          @hook_name = name
          attribute :name, type: String, default: @hook_name
        end

        def events(*events)
          return @events if events.blank?
          @events = events.flatten
          attribute :events, type: Object, default: @events
        end
      end

      attribute :config, type: Object, default: {}
      attribute :active, type: Boolean, default: true

      validates :name, :events, presence: true

      def active_model_serializer
        HookSerializer
      end

      def handler
        Revily::Event.handlers[name]
      end

      def initialize(attrs={})
        attrs = attrs.with_indifferent_access
        # remove attributes that conflict with our class method assignments
        attrs.delete(:name)
        attrs.delete(:events)
        super(attrs)
      end

    end
  end
end
