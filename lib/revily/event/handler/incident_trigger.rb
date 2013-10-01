module Revily
  module Event
    class Handler
      class IncidentTrigger < Handler

        events %w[ incident.triggered ]

        def handle?
          service && service.enabled? && service.policy && current_policy_rule?
        end

        def handle
          run Event::Job::IncidentTrigger, :incidents
          schedule Event::Job::IncidentEscalate, escalation_timeout.minutes, :incidents
        end

        def incident
          source
        end

        def escalation_timeout
          current_policy_rule.try(:escalation_timeout) || 30
        end

        def service
          incident.service
        end

        def current_policy_rule
          incident.try(:current_policy_rule)
        end

        def current_policy_rule?
          !!current_policy_rule
        end

        def targets
          @targets
        end
      end
    end
  end
end
