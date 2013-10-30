module Revily
  module Event
    class Job
      class IncidentEscalationTimeout < Incident

        def process
          incident.escalate unless (incident.acknowledged? || incident.resolved?)
        end

      end
    end
  end
end
