class Event
  class Retrigger
    include Sidekiq::Worker

    def perform(event_id)
      @event = Event.find(event_id)

      @event.trigger unless ( @event.triggered? || @event.resolved? )
    end

  end
end
