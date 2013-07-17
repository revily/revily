module Reveille
  module Event
    class Handler
      class IncidentResolve < Handler

        events %w[ incident.resolved ]
        
        def handle?
          true
        end

        def handle
          Event::Job::IncidentResolve.run(:incidents, payload, targets: targets)
        end

        def targets
          @targets
        end
      end
    end
  end
end