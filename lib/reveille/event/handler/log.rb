module Reveille
  module Event
    class Handler
      class Log < Handler

        supports_events 'incident.*'
        
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