module Revily
  module Event
    class Hook
      class IncidentAcknowledge < Hook
        
        hook_name "incident_acknowledge"
        handler   "incident_acknowledge"
        events    %w[ incident.acknowledge ]

      end
    end
  end
end
