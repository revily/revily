module Reveille
  module Event
    class Hook
      class Log < Hook

        hook_name 'log'
        events Event.all

      end
    end
  end
end
