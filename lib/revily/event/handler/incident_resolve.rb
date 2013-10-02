module Revily
  module Event
    class Handler
      class IncidentResolve < Handler

        events %w[ incident.resolve ]

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
