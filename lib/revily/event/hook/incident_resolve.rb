module Revily
  module Event
    class Hook
      class IncidentResolve < Hook
        
        hook_name 'incident_resolve'
        handler   'incident_resolve'
        events    %w[ incident.resolve ]

      end
    end
  end
end
