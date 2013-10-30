module Revily
  module Event
    class Job
      class IncidentAcknowledgeTimeout < Incident

        def process
          incident.trigger unless (incident.triggered? || incident.resolved?)
        end

      end
    end
  end
end
