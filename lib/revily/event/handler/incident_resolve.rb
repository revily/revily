module Revily
  module Event
    class Handler
      class IncidentResolve < Incident

        events %w[ incident.resolve ]

        def handle
          run Event::Job::IncidentResolve, :incidents
        end
        
      end
    end
  end
end
