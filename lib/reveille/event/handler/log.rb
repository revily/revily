module Reveille
  module Event
    class Handler
      class Log < Handler
        # queue 'logs'
        events 'incident.*'

        def handle?
          true
        end

        def handle
          # run Event::Job::Log, :log
          logger.info "running log job"
          Event::Job::Log.run(:log, payload: payload, params: params)
        end

      end
    end
  end
end
