class V1::IncidentsController < V1::ApplicationController
  respond_to :json

  before_filter :authenticate_user!
  before_filter :service, :incidents

  def index
    @incidents = incidents.all
    # location_url = service ? service_incidents_url : incidents_url
    respond_with @incidents #, location: location_url
  end

  def show
    @incident = incidents.where(uuid: params[:id]).first.decorate

    respond_with @incident
  end

  def create
    @incident = incidents.new(sanitized_params)
    @incident.save

    respond_with @incident
  end

  def update
    @incident = incidents.where(uuid: params[:id]).first
    @incident.update_attributes(sanitized_params)

    respond_with @incident
  end

  def destroy
    @incident = incidents.where(uuid: params[:id]).first
    @incident.destroy

    respond_with @incident.service, @incident
  end

  def trigger
    @incident = incidents.where(uuid: params[:id]).first
    @incident.trigger 

    respond_with @incident
  end

  def acknowledge
    @incident = incidents.where(uuid: params[:id]).first
    @incident.acknowledge

    respond_with @incident
  end

  def escalate
    @incident = incidents.where(uuid: params[:id]).first
    @incident.escalate

    respond_with @incident
  end

  def resolve
    @incident = incidents.where(uuid: params[:id]).first
    @incident.resolve

    respond_with @incident
  end

  private

  def permitted_params
    [:message, :details]
  end

  def service
    @service ||= current_account.services.where(uuid: params[:service_id]).first if params[:service_id]
  end

  def incidents
    @incidents ||= (@service) ? @service.incidents : Incident
  end
end
