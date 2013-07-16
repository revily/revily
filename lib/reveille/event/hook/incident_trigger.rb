module Reveille
  module Event
    class Hook
      class IncidentTrigger < Hook
        def name
          'incident_trigger'
        end

        def events
          %w[ incident.triggered ]
        end
      end
    end
  end
end
