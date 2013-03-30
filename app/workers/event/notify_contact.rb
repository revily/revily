class Event
  class NotifyContact
    include Sidekiq::Worker

    def perform(action, contact_id, event_id=nil)
      contact = ::Contact.find(contact_id)
      event = Event.find(event_id) if event_id

      contact.notify(action, event)
    end
    
  end
end