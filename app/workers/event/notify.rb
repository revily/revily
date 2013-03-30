class Event
  class Notify
    include Sidekiq::Worker

    def perform(event_id)

    end
    
  end
end