class Event
  class Retrigger
    include Sidekiq::Worker

    def perform(event_id)
      @event = Event.find(event_id)

      if @event.triggered? || @event.resolved?
        return true
      else
        @event.trigger
      end
    end

  end
end
