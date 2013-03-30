class Event
  class DispatchNotifications
    include Sidekiq::Worker

    def perform(event_id)
      event = ::Event.find(event_id)

      event.current_user.contacts.each do |contact|
        Event::NotifyContact.perform_async('trigger', contact.id, event.id)
      end
    end
    
  end
end