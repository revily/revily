module Reveille
  module Event
    class Handler
      class IncidentAcknowledge < Handler

        events %w[ incident.acknowledged ]
        
        def handle?
          true
        end

        def handle
          Event::Job::IncidentAcknowledge.run(:incidents, payload, targets: targets)
        end

        def targets
          @targets
        end
      end
    end
  end
end