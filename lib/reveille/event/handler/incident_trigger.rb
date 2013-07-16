module Reveille
  module Event
    class Handler
      class IncidentTrigger
        def handle?
          true
        end

        def handle
          Event::Job::IncidentTrigger.run(:incidents, payload, targets: targets)
        end

        def targets
          @targets
        end
      end
    end
  end
end