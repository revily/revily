module Revily
  module Event
    class Job
      class Test < Job

        def process
          Revily::Event::Handler::Test.event_list << "event"
        end

      end
    end
  end
end
