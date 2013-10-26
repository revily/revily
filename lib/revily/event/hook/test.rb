module Revily
  module Event
    class Hook
      class Test < Hook

        hook_name 'test'
        handler   'test'
        events     Event.all

      end
    end
  end
end
