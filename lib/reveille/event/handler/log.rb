module Reveille
  module Event
    class Handler
      class Log < Handler
        events '*'

        def handle?
          true
        end

        def handle
          run Event::Job::Log, :log
        end

      end
    end
  end
end
