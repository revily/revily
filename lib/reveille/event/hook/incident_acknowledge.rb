module Reveille
  module Event
    class Hook
      class IncidentAcknowledge < Hook
        def name
          'incident_acknowledge'
        end

        def events
          %w[ incident.acknowledged ]
        end
      end
    end
  end
end
