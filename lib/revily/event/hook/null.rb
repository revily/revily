module Revily
  module Event
    class Hook
      class Null < Hook

        hook_name 'null'
        handler   'null'
        events     Event.all

      end
    end
  end
end
