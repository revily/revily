module Revily
  module Event
    class Job
      class Log < Job

        def process
          logger.info self.attributes
        end

      end
    end
  end
end
