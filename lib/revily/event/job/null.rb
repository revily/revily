module Revily
  module Event
    class Job
      class Null < Job

        def process
          Revily::Event::Handler::Null.event_list << "event"
        end

      end
    end
  end
end
