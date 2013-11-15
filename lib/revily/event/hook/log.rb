require "revily/event/hook"

module Revily
  module Event
    class Hook
      class Log < Hook

        hook_name "log"
        handler   "log"
        events    Event.all

      end
    end
  end
end
