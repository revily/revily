class SchedulesController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!
  
  def index
    @schedules = Schedule.all

    respond_with @schedule
  end

  def show
    @schedule = Schedule.find_by_uuid(params[:id]).decorate

    respond_with @schedule
  end

  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.save

    respond_with @schedule
  end

  def edit
    @schedule = Schedule.find_by_uuid(params[:id]).decorate

    respond_with @schedule
  end

  def update
    @schedule = Schedule.find_by_uuid(params[:id])
    @schedule.update_attributes(schedule_params)

    respond_with @schedule
  end

  def destroy
    @schedule = Schedule.find_by_uuid(params[:id])
    @schedule.destroy

    respond_with @schedule
  end

  private

  def schedule_params
    params.require(:schedule).permit(:name, :time_zone)
  end
end
