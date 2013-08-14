module Revily
  module Event
    class Hook
      class IncidentResolve < Hook
        
        hook_name 'incident_resolve'
        events %w[ incident.resolved ]

      end
    end
  end
end
