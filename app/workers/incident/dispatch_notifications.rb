class Incident
  class DispatchNotifications
    include Sidekiq::Worker

    def perform(incident_id)
      incident = ::Incident.find(incident_id)

      incident.current_user.contacts.each do |contact|
        Incident::NotifyContact.perform_async('trigger', contact.id, incident.id)
      end
    end
    
  end
end