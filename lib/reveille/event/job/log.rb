module Reveille
  module Event
    class Job
      class Log < Job

        def process
          Rails.logger.info "logging!!!"
        end

      end
    end
  end
end
