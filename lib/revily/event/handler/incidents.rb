module Revily
  module Event
    class Handler
      module Incidents
        def handle?
          service && service.enabled? && service.policy && current_policy_rule?
        end

        def incident
          source
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

        def escalation_timeout
          current_policy_rule.try(:escalation_timeout) || 30
        end

        def acknowledge_timeout
          service.try(:acknowledge_timeout)
        end

        def acknowledge_timeout?
          !!acknowledge_timeout
        end

      end
    end
  end
end
