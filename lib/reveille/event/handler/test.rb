module Reveille
  module Event
    class Handler
      class Test < Handler
        class << self
          attr_accessor :events
        end

        self.events = []

        supports_events Event.events

        def handle?
          true
        end

        def handle
          Event::Job::Test.run(:test, payload)
        end

        def targets
          @targets
        end

        def payload
          @payload ||= {
            source: source,
            config: {}
          }
        end

      end
    end
  end
end
