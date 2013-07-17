module Reveille
  module Event
    class Job
      class Test < Job

        class << self
          def run(queue, *args)
            Reveille::Event::Handler::Test.event_list << "event"
          end
        end

        def process
          Reveille::Event::Handler::Test.event_list << "event"
        end

      end
    end
  end
end
