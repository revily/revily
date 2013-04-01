class Event
  class AutoResolve
    include Sidekiq::Worker

    def perform(event_id)
      @event = Event.find(event_id)

      @event.resolve unless @event.resolved?
    end

  end
end
