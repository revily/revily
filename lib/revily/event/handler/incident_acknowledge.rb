module Revily
  module Event
    class Handler
      class IncidentAcknowledge < Incident

        events %w[ incident.acknowledge ]

        def handle
          run Event::Job::IncidentAcknowledge, :incidents
          schedule Event::Job::IncidentAcknowledgeTimeout, acknowledge_timeout.minutes, :incidents if acknowledge_timeout?
        end

      end
    end
  end
end
