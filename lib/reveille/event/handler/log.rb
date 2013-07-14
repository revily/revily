module Reveille
  module Event
    class Handler
      class Log < Handler
        EVENTS = /.*/

        def handle?
          true
        end

        def handle
          logger.debug "account=#{account.id} event=#{event}"
        end

        def logger
          Rails.logger
        end
      end
    end
  end
end