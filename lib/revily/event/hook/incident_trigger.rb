require "revily/event/hook"

module Revily
  module Event
    class Hook
      class IncidentTrigger < Hook

        hook_name "incident_trigger"
        handler   "incident_trigger"
        events    %w[ incident.trigger incident.escalate ]

      end
    end
  end
end
