module Revily
  module Event
    class Job
      class IncidentAutoResolveTimeout < Job
        include Job::Incidents

        def process
          incident.resolve unless incident.resolved?
        end

      end
    end
  end
end
