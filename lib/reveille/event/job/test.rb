module Reveille
  module Event
    class Job
      class Test < Job

        class << self
          def run(queue, *args)
            Reveille::Event::Handler::Test.events << "event"

            # Rails.logger.info "running test handler job"
          end
        end

        def process
          Rails.logger.info "logging"
        end

      end
    end
  end
end
