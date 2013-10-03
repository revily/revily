module Revily
  module Event
    class Job
      class IncidentAutoResolveTimeout < Job

        def process
          incident.resolve unless incident.resolved?
        end

        private

        def incident
          source
        end

        def source
          @source ||= Incident.find_by(uuid: payload["source"]["id"])
        end
        
      end
    end
  end
end
