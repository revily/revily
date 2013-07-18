module Reveille
  module Event
    class Job
      class Test < Job

        def process
          Reveille::Event::Handler::Test.event_list << "event"
        end

      end
    end
  end
end
