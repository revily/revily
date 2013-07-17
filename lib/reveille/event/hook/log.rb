module Reveille
  module Event
    class Hook
      class Log < Hook
        def name
          'log'
        end

        def events
          Event.events
        end
      end
    end
  end
end
