module Reveille
  module Event
    class Job
      class IncidentTrigger < Job

        def targets
          params[:targets]
        end

        def process
          Rails.logger.debug "processing "
          # targets.each do |target|
            # do something with each target
          # end
        end

      end
    end
  end
end
