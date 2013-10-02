module Revily
  module Event
    class Handler
      class IncidentAcknowledge < Handler
        include Handler::Incidents

        events %w[ incident.acknowledge ]

        def handle
          run Event::Job::IncidentAcknowledge, :incidents

          if acknowledge_timeout?
            schedule Event::Job::IncidentAcknowledgeTimeout, acknowledge_timeout.minutes, :incidents
          end
        end

      end
    end
  end
end
