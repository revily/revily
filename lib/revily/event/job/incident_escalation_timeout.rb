module Revily
  module Event
    class Job
      class IncidentEscalationTimeout < Job

        def process
          incident.escalate unless (incident.acknowledged? || incident.resolved?)
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
