module Reveille
  module Event
    class Hook
      class IncidentResolve < Hook
        def name
          'incident_resolve'
        end

        def events
          %w[ incident.resolved ]
        end
      end
    end
  end
end
