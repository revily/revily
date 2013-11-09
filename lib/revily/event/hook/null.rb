module Revily
  module Event
    class Hook
      class Null < Hook

        hook_name "null"
        handler   "null"
        events     Revily::Event.all

      end
    end
  end
end
