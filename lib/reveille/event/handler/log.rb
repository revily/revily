module Reveille
  module Event
    class Handler
      class Log < Handler
        def handle?
          true
        end

        def handle
          Event::Job::Log.run(:log, payload)
        end

      end
    end
  end
end