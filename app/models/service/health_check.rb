class Service
  class HealthCheck
    
    attr_reader :service, :incident_counts

    def initialize(service)
      @service = service
      @incident_counts = @service.incident_counts
    end

    def result
      return "disabled" if disabled?
      return "critical" if critical?
      return "warning" if warning?
      return "ok" if ok?

      "unknown"
    end

    def ok?
      incident_counts.resolved >= 0
    end

    def warning?
      incident_counts.acknowledged > 0
    end

    def critical?
      incident_counts.triggered > 0
    end

    def disabled?
      service.disabled?
    end

  end
end
