module Revily
  module Event
    class Job
      class Log < Job

        def process
          Rails.logger.info self.attributes
        end

      end
    end
  end
end
