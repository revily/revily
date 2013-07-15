module Reveille
  module Event
    class Handler
      class Web < Handler
        def handle?
          true
        end

        def handle
          Event::Job::Web.run(:web, payload)
        end

      end
    end
  end
end