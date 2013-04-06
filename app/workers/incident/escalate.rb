class Incident
  class Escalate
    include Sidekiq::Worker
    
    def perform(incident_id)
      @incident = Incident.find(incident_id)

      @incident.escalate unless ( @incident.acknowledged? || @incident.resolved? )
    end

  end
end