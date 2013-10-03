module Revily
  module Event
    class Handler
      class IncidentResolve < Handler
        include Handler::Incidents

        events %w[ incident.resolve ]

        def handle
          run Event::Job::IncidentResolve, :incidents
        end
        
      end
    end
  end
end
