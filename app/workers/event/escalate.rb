class Event
  class Escalate
    include Sidekiq::Worker
    
    def perform(event_id)
      @event = Event.find(event_id)

      @event.escalate unless ( @event.acknowledged? || @event.resolved? )
    end

  end
end