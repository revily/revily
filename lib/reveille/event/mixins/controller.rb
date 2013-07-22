module Reveille
  module Event
    module Mixins
      module Controller

        def self.included(base)
          base.before_filter :set_current_actor
        end

        protected

        def current_actor
          if defined?(current_user)
            current_user
          elsif defined?(current_service)
            current_service
          else
            nil
          end
        end

        def set_current_actor
          Reveille::Event.event_store[:actor] = current_actor
        end
      end
    end
  end
end
