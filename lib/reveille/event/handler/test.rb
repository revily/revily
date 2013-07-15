module Reveille
  module Event
    class Handler
      class Test < Handler
        class << self
          attr_accessor :events
        end

        self.events = []

        default_events Event.all_events

        def handle?
          true
        end

        def handle
          # puts self.inspect
          # self.class.events << self
          Event::Job::Test.run(:test, payload)
        end

        def targets
          @targets
        end

        def payload
          @payload ||= {
            object: object.to_json,
            config: {}
          }
        end

      end
    end
  end
end
