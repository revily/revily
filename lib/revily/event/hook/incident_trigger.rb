module Revily
  module Event
    class Hook
      class IncidentTrigger < Hook

        hook_name 'incident_trigger'
        events %w[ incident.triggered ]

      end
    end
  end
end
