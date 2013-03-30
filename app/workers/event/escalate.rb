class Event
  class Escalate
    include Sidekiq::Worker
    
    def perform(event_id)
      @event = Event.find(event_id)

      if @event.acknowledged? || @event.resolved?
        return true
      else
        @event.escalate
      end
    end

  end
end