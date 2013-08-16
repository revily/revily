module Revily
  module Event
    class Job
      class IncidentAcknowledge < Job

        def targets
          params['targets'] || []
        end

        def process
          targets.each do |target|
            # do something with each target
          end
        end

      end
    end
  end
end