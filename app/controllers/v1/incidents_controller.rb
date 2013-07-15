class V1::IncidentsController < V1::ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :service, :incidents

  def index
    @incidents = incidents
    # location_url = service ? service_incidents_url : incidents_url
    respond_with @incidents #, location: location_url
  end

  def show
    @incident = incidents.find_by!(uuid: params[:id])

    respond_with @incident
  end

  def create
    @incident = incidents.new(incident_params)
    @incident.account = current_account
    @incident.save

    respond_with @incident
  end

  def update
    @incident = incidents.find_by!(uuid: params[:id])
    @incident.update_attributes(incident_params)

    respond_with @incident
  end

  def destroy
    @incident = incidents.find_by!(uuid: params[:id])
    @incident.destroy

    respond_with @incident.service, @incident
  end

  def trigger
    @incident = incidents.find_by!(uuid: params[:id])
    @incident.trigger 

    respond_with @incident
  end

  def acknowledge
    @incident = incidents.find_by!(uuid: params[:id])
    @incident.acknowledge

    respond_with @incident
  end

  def escalate
    @incident = incidents.find_by!(uuid: params[:id])
    @incident.escalate

    respond_with @incident
  end

  def resolve
    @incident = incidents.find_by!(uuid: params[:id])
    @incident.resolve

    respond_with @incident
  end

  private

  def incident_params
    params.permit(:message, :details)
  end

  def service
    @service = current_account.services.find_by!(uuid: params[:service_id]) if params[:service_id]
  end

  def incidents
    @incidents = (@service) ? @service.incidents : current_account.incidents
  end
end
