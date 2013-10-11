class V1::IntegrationController < V1::ApplicationController
  respond_to :json

  #TODO(dryan): Fix integrations :)  
  before_action :authenticate_service!
  skip_before_action :verify_authenticity_token
  # skip_before_action :set_tenant
  before_action :incidents  

  def trigger
    @incident = incidents.integration(params[:message], params[:key]).first_or_initialize(incident_params)
    http_status = @incident.new_record? ? :created : :not_modified

    respond_with @incident do |format|
      if @incident.save
        format.json { render json: @incident, serializer: IntegrationSerializer, status: http_status }
      else
        format.json { render json: { errors: @incident.errors }, status: :unprocessable_entity }
      end
    end
  end

  def acknowledge
    @incident = incidents.integration(params[:message], params[:key]).first

    respond_with @incident do |format|
      if @incident
        # last_state = @incident.state
        if @incident.acknowledge
          format.json { head :no_content }
        else
          format.json { head :not_modified }
        end
      else
        format.json { head :not_found }
      end
    end
  end

  def resolve
    @incident = incidents.integration(params[:message], params[:key]).first

    respond_with @incident do |format|
      if @incident
        if @incident.resolve
          format.json { head :no_content }
        else
          format.json { head :not_modified }
        end
      else
        format.json { head :not_found }
      end
    end
  end

  private

    def incident_params
      params.permit(:message, :description, :key, :details)
    end

    def incidents
      @incidents ||= current_service.incidents
    end

end
