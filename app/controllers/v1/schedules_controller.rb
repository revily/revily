class V1::SchedulesController < V1::ApplicationController
  respond_to :json

  doorkeeper_for :all, scopes: [ :read, :write ]

  before_action :schedules

  def index
    @schedules = schedules.page(params[:page])

    respond_with @schedules#, serializer: PaginationSerializer
  end

  def show
    @schedule = schedules.find_by!(uuid: params[:id])

    respond_with @schedule
  end

  def new
    @schedule = schedules.new

    respond_with @schedule
  end

  def create
    @schedule = schedules.new(schedule_params)
    @schedule.save

    respond_with @schedule
  end

  def edit
    @schedule = schedules.find_by!(uuid: params[:id])

    respond_with @schedule
  end

  def update
    @schedule = schedules.find_by!(uuid: params[:id])
    @schedule.update_attributes(schedule_params)

    respond_with @schedule
  end

  def destroy
    @schedule = schedules.find_by!(uuid: params[:id])
    @schedule.destroy

    respond_with @schedule
  end


  def on_call
    @schedule = schedules.find_by!(uuid: params[:id])

    respond_with @schedule.current_user_on_call
  end

  def policy_rules
    # @schedule = schedules.includes(:policy_rules => :policy, :schedule_layers => :users).references(:policy_rules => :policy, :schedule_layers => :users).find_by!(uuid: params[:id])
    @schedule = schedules.find_by!(uuid: params[:id])
    # @policy_rules = @schedule.policy_rules.includes(:policy).select('policy.rules.*', 'policies.id').page(params[:page]) #.references(:policies)
    @policy_rules = @schedule.policy_rules.includes(:policy).page(params[:page]) #.references(:policies)

    respond_with @policy_rules, minimal: true
  end

  def users
    @schedule = schedules.joins(:policy_rules).find_by!(uuid: params[:id])
    @users = @schedule.users

    respond_with @users
  end

  private

  def schedule_params
    params.permit(:name, :time_zone)
  end

  def schedules
    @schedules = Schedule.all
  end
end
