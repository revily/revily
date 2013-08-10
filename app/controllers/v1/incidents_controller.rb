class V1::IncidentsController < V1::ApplicationController
  include ::NewRelic::Agent::MethodTracer

  respond_to :json

  before_action :authenticate_user!
  before_action :service, :incidents

  def index
    # @incidents = incidents.includes(:current_policy_rule, :current_user, service: :policy).page(params[:page])
    @incidents = incidents.includes(:current_user, :current_policy_rule, service: :policy).references(:current_user, :current_policy_rule, service: :policy).page(params[:page])
    logger.info params
    respond_with @incidents#, serializer: PaginationSerializer
  end

  def show
    @incident = incidents.includes(:current_user, :current_policy_rule, :service).find_by!(uuid: params[:id])

    respond_with @incident
  end

  def create
    @incident = incidents.new(incident_params)
    @incident.account = current_account
    self.class.trace_execution_scoped(['IncidentsController#create/incident_save']) do
      @incident.save
    end

    respond_with @incident
  end

  add_method_tracer :create, 'IncidentsController#create'

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
      params.permit(:message, :details, :key)
    end

    def search_params
      params.permit(:state)
    end

    def service
      # @service = Service.joins(:policy => :policy_rules).find_by!(uuid: params[:service_id]) if params[:service_id]
      @service = Service.find_by!(uuid: params[:service_id]) if params[:service_id]
    end

    def incidents
      @incidents = (@service) ? @service.incidents : Incident.all
    end
end
