module Revily
  module Event
    class Job
      class IncidentAcknowledgeTimeout < Job

        def process
          source.trigger
        end

        def incident
          source
        end
        
        private

        def source
          @source ||= Incident.find_by(uuid: payload["source"]["id"])
        end
      end
    end
  end
end
