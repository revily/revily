class V1::EventsController < V1::ApplicationController
  respond_to :json

  # doorkeeper_for :all, scopes: [ :read, :write ]
  before_action :authenticate_user!
  before_action :context
  before_action :events

  after_action only: [ :index ] { paginate(:events) }

  def index
    @events = events.page(params[:page])
    respond_with @events, expand: expand_params
  end

  def show
    @event = events.find_by!(uuid: params[:id])
    logger.info expand_params
    respond_with @event, expand: expand_params
  end

  private

  def context
    @context ||=
    if params[:incident_id]
      Incident.find_by!(uuid: params[:incident_id])
    elsif params[:policy_id]
      Policy.find_by!(uuid: params[:policy_id])
    elsif params[:policy_rule_id]
      PolicyRule.find_by!(uuid: params[:policy_rule_id])
    elsif params[:schedule_id]
      Schedule.find_by!(uuid: params[:schedule_id])
    elsif params[:schedule_layer_id]
      ScheduleLayer.find_by!(uuid: params[:schedule_layer_id])
    elsif params[:service_id]
      Service.find_by!(uuid: params[:service_id])
    elsif params[:user_id]
      User.find_by!(uuid: params[:user_id])
    else
      nil
    end
  end

  def events
    @events ||= (@context) ? @context.events : Event.all
  end
end
