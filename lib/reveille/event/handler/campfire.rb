module Reveille
  module Event
    class Handler
      class Campfire < Handler
        EVENTS = /.*/

        def handle?
          true
        end

        def handle
          Event::Job::Campfire.run(:campfire, payload, targets: targets)
        end

        def targets
          @targets
        end

      end
    end
  end
end