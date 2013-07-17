module Reveille
  module Event
    class Handler
      class IncidentTrigger < Handler

        events %w[ incident.triggered ]
        
        def handle?
          true
        end

        def handle
          Event::Job::IncidentTrigger.run(:incidents, payload, targets: targets)
          Event::Job::IncidentEscalate.schedule(:incidents, escalation_timeout, payload, targets: targets)
        end

        def escalation_timeout
          source.try(:current_policy_rule).try(:escalation_timeout) || 30
        end

        def targets
          @targets
        end
      end
    end
  end
end