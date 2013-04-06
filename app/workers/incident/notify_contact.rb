class Incident
  class NotifyContact
    include Sidekiq::Worker

    def perform(action, contact_id, incident_id=nil)
      contact = ::Contact.find(contact_id)
      incident = Incident.find(incident_id) if incident_id

      contact.notify(action, incident)
    end
    
  end
end