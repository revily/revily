class Web::SchedulesController < Web::ApplicationController
  before_action :schedule, only: [:show, :update, :destroy]

  def index
    @schedules = Schedule.all
  end

  def show
  end

  def new
    @schedule = Schedule.new
  end

  def edit
  end

  def create
    @schedule = Schedule.new(schedule_params)

    if @schedule.save
      flash[:notice] = "Schedule was successfully created."
    else
      flash[:alert] = "Schedule could not be created."
    end

    respond_with @schedule
  end

  def update
    if @schedule.update(schedule_params)
      flash[:notice] = "Schedule was successfully updated."
    else
      flash[:alert] = "Schedule could not be updated."
    end

    respond_with @schedule
  end

  def destroy
    @schedule.destroy
    redirect_to schedules_url, notice: 'Schedule was successfully destroyed.'
  end

  private

  def schedule
    @schedule = Schedule.find_by(uuid: params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:name, :time_zone)
  end
end
