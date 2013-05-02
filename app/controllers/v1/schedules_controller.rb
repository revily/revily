class V1::SchedulesController < V1::ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!
  
  def index
    @schedules = current_account.schedules.decorate

    respond_with @schedule
  end

  def show
    @schedule = current_account.schedules.where(uuid: params[:id]).first

    respond_with @schedule
  end

  def new
    @schedule = current_account.schedules.new

    respond_with @schedule
  end

  def create
    @schedule = current_account.schedules.new(sanitized_params)
    @schedule.save

    respond_with @schedule
  end

  def edit
    @schedule = current_account.schedules.where(uuid: params[:id]).first

    respond_with @schedule
  end

  def update
    @schedule = current_account.schedules.where(uuid: params[:id]).first
    @schedule.update_attributes(sanitized_params)

    respond_with @schedule
  end

  def destroy
    @schedule = current_account.schedules.where(uuid: params[:id]).first
    @schedule.destroy

    respond_with @schedule
  end

  private

  def permitted_params
    [ :name, :time_zone ]
  end
end
