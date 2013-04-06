class IncidentsController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!
  before_filter :service, :incidents

  def index
    @incidents = incidents.all
    location_url = service ? service_incidents_url : incidents_url
    respond_with @incidents, location: location_url
  end

  def show
    @incident = incidents.where(uuid: params[:id]).first.decorate

    respond_with @incident
  end

  def new
    @incident = incidents.new

    respond_with @incident
  end

  def create
    @incident = incidents.new(incident_params)
    @incident.save

    respond_with @incident
  end

  def update
    @incident = incidents.where(uuid: params[:id]).first
    @incident.update_attributes(incident_params)

    respond_with @incident
  end

  def destroy
    @incident = incidents.where(uuid: params[:id]).first
    @incident.destroy

    respond_with @incident.service, @incident
  end

  private

  def incident_params
    params.require(:incident).permit(:message, :details)
  end

  def service
    @service ||= current_account.services.where(uuid: params[:service_id]).first if params[:service_id]
  end

  def incidents
    @incidents ||= (@service) ? @service.incidents : Incident
  end
end
