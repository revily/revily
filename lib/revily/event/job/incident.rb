module Revily
  module Event
    class Job
      class Incident < Job
        abstract true

        def process
          logger.warn "Override #process in a subclass"
        end
        
        private

        def current_user
          source.current_user
        end

        def incident
          source
        end

        def incidents
          current_user.incidents
        end

        # override #source for eager loading of associated records
        def source
          @source ||= ::Incident.includes(current_user: :contacts).find_by(uuid: payload["source"]["id"])
        end

      end
    end
  end
end