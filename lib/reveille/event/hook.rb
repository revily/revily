module Reveille
  module Event
    class Hook
      autoload :IncidentTrigger, 'reveille/event/hook/incident_trigger'
      autoload :Test, 'reveille/event/hook/test'

      attr_accessor :name, :events, :config

      def name
        raise StandardError, "override #name in subclass #{self.class.name}"
      end

      def events
        raise StandardError, "override #name in subclass #{self.class.name}"
      end

      def config
        {}
      end

      def config=(config)
        @config = config.with_indifferent_access
      end

      def handler
        Reveille::Event.handlers[name]
      end
      
      def active
        true
      end

      def active?
        active
      end
    end
  end
end
