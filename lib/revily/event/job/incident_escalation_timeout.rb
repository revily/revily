module Revily
  module Event
    class Job
      class IncidentEscalationTimeout < Job
        include Job::Incidents

        def process
          incident.escalate unless (incident.acknowledged? || incident.resolved?)
        end

      end
    end
  end
end
