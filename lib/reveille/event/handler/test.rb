module Reveille
  module Event
    class Handler
      class Test < Handler
        class << self
          attr_accessor :event_list
        end
        self.event_list = []

        events Event.events

        def handle?
          true
        end

        def handle
          run Event::Job::Test, :test
        end

        def targets
          @targets
        end

      end
    end
  end
end
