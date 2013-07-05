class V1::IntegrationController < V1::ApplicationController
  before_filter :authenticate_service!

  respond_to :json

  def trigger
    @incident = current_service.incidents.unresolved.first_or_initialize_by_key_or_message(incident_params)

    http_status = @incident.new_record? ? :created : :accepted

    respond_with @incident do |format|
      if @incident.save
        format.json { render json: @incident, status: http_status }
      else
        format.json { render json: { errors: @incident.errors }, status: :unprocessable_entity }
      end
    end
  end

  def resolve
    @incident = current_service.incidents.find_by_key_or_message(incident_params)

    respond_with @incident do |format|
      # if @incident.persisted?
      if @incident
        @incident.resolve unless @incident.resolved?
        format.json { render json: @incident, status: :accepted }
      else
        format.json { head :not_found }
      end
    end
  end

  protected

  private

  def permitted_params
    [ :message, :description, :key ]
  end

end
