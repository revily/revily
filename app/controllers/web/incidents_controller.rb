class Web::IncidentsController < Web::ApplicationController
  before_action :service, :incidents
  before_action :incident, only: [ :show ]

  def index
    respond_with @incidents
  end

  def show
    respond_with @incident
  end

  private

  def service
    @service = Service.find_by(uuid: params[:service_id])
  end

  def incidents
    @incidents = (@service) ? @service.incidents : Incident.all
  end

  def incident
    @incident = @incidents.find_by(uuid: params[:id])
  end

end
