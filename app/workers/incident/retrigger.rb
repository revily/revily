class Incident
  class Retrigger
    include Sidekiq::Worker

    def perform(incident_id)
      @incident = Incident.find(incident_id)

      @incident.trigger unless ( @incident.triggered? || @incident.resolved? )
    end

  end
end
