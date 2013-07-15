module Reveille
  module Event
    class Job
      class Web < Job

        def process
          Rails.logger.info "processing web handler"
        end

      end
    end
  end
end