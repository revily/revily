class Event
  class AutoResolve
    include Sidekiq::Worker

    def perform(event_id)
      @event = Event.find(event_id)

      if @event.resolved?
        return true
      else
        @event.resolve
      end
    end

  end
end
