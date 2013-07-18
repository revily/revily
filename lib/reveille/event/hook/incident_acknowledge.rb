module Reveille
  module Event
    class Hook
      class IncidentAcknowledge < Hook
        
        hook_name 'incident_acknowledge'
        events %w[ incident.acknowledged ]

      end
    end
  end
end
