module Reveille
  module Event
    class Hook
      class Test < Hook

        hook_name 'test'
        events Event.all

      end
    end
  end
end
