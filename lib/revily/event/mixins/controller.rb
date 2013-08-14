module Revily
  module Event
    module Mixins
      module Controller
        extend ActiveSupport::Concern
        included do
          helper_method :current_actor
          prepend_before_action :set_current_actor
        end

        protected

          def current_actor
            current_user || current_service || nil
            # if defined?(current_user)
            #   current_user
            # elsif defined?(current_service)
            #   current_service
            # else
            #   nil
            # end
          end

          def set_current_actor
            Revily::Event.actor = current_actor
          end
      end
    end
  end
end
