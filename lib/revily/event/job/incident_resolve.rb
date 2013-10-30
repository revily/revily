module Revily
  module Event
    class Job
      class IncidentResolve < Incident

        def process
          incident.resolve unless incident.resolved?
        end

      end
    end
  end
end
