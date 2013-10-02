module Revily
  module Event
    class Handler
      class IncidentTrigger < Handler
        include Handler::Incidents

        events %w[ incident.trigger ]

        def handle
          run Event::Job::IncidentTrigger, :incidents
          schedule Event::Job::IncidentEscalate, escalation_timeout.minutes, :incidents
        end

      end
    end
  end
end
