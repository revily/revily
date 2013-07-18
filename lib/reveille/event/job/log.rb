module Reveille
  module Event
    class Job
      class Log < Job

        def process
          Rails.logger.info self.inspect
        end

      end
    end
  end
end
