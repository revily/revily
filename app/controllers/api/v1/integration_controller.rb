class Api::V1::IntegrationController < Api::V1::BaseController
  before_filter :authenticate_service!

  respond_to :json

  def trigger
    @incident = current_service.incidents.unresolved.first_or_initialize_by_key_or_message(incident_params)

    http_status = @incident.new_record? ? :created : :accepted

    respond_with @incident do |format|
      if @incident.save
        hound_action @incident, 'trigger' if @incident.new_record?
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
        hound_action @incident, 'resolve'
        format.json { render json: @incident, status: :accepted }
      else
        format.json { head :not_found }
      end
    end
  end

  protected

  def hound_user
    current_service
  end

  private

  def incident_params
    logger.info params.inspect
    params.permit(:message, :description, :key)
  end

end
