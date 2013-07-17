module Reveille
  module Event
    class Handler
      class Web < Handler
        events Event.events
        string :url
        string :url

        white_list :url
        
        def handle?
          true
        end

        def handle
          Event::Job::Web.run(:web, payload)
        end

      end
    end
  end
end