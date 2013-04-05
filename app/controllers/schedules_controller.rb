class SchedulesController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!
  
  def index
    @schedules = current_account.schedules.decorate

    respond_with @schedule
  end

  def show
    @schedule = current_account.schedules.find_by_uuid(params[:id]).decorate

    respond_with @schedule
  end

  def new
    @schedule = current_account.schedules.new

    respond_with @schedule
  end

  def create
    @schedule = current_account.schedules.new(schedule_params)
    @schedule.save

    respond_with @schedule
  end

  def edit
    @schedule = current_account.schedules.find(params[:id]).decorate

    respond_with @schedule
  end

  def update
    @schedule = current_account.schedules.find(params[:id])
    @schedule.update_attributes(schedule_params)

    respond_with @schedule
  end

  def destroy
    @schedule = current_account.schedules.find(params[:id])
    @schedule.destroy

    respond_with @schedule
  end

  private

  def schedule_params
    params.require(:schedule).permit(:name, :time_zone)
  end
end
