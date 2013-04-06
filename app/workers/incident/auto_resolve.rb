class Incident
  class AutoResolve
    include Sidekiq::Worker

    def perform(incident_id)
      @incident = Incident.find(incident_id)

      @incident.resolve unless @incident.resolved?
    end

  end
end
