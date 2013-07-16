module Reveille
  module Event
    class Hook
      class Test < Hook
        def name
          'test'
        end

        def events
          Event.events
        end
      end
    end
  end
end
