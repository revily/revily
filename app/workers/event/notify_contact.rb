class Event
  class NotifyContact
    include Sidekiq::Worker

    def perform(event_id, contact_id)
      @event = ::Event.find(event_id)
      @contact = ::Contact.find(contact_id)

      @contact.notify(@event)
    end
    
  end
end