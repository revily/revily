module Revily
  module Event
    class Job
      class Web < Job

        def process
          logger.debug "processing web handler"
        end

      end
    end
  end
end
