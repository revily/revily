module Revily
  module Event
    class Handler
      class IncidentTrigger < Handler
        include Handler::Incidents

        events %w[ incident.trigger incident.escalate ]

        def handle
          run Event::Job::IncidentTrigger, :incidents
          schedule Event::Job::IncidentEscalationTimeout, escalation_timeout.minutes, :incidents
          schedule Event::Job::IncidentAutoResolveTimeout, auto_resolve_timeout.minutes, :incidents
        end

      end
    end
  end
end
