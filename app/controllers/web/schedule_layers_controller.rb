class Web::ScheduleLayersController < Web::ApplicationController
  before_action :schedule
  before_action :schedule_layer, only: [ :update, :destroy ]

  def create
    @schedule_layer = schedule.schedule_layers.new(schedule_layer_params)

    if @schedule_layer.save
      flash[:notice] = "Schedule layer was successfully created."
    else
      flash[:alert] = "Schedule layer could not be created."
    end

    respond_with @schedule_layer
  end

  def update
    if @schedule_layer.update(schedule_layer_params)
      flash[:notice] = "Schedule layer was successfully updated."
    else
      flash[:alert] = "Schedule layer could not be updated."
    end

    respond_with @schedule_layer
  end

  def destroy
    @schedule_layer.destroy
    redirect_to schedule_layers_url, notice: 'Schedule layer was successfully destroyed.'
  end

  private

  def schedule
    @schedule = Schedule.find_by(uuid: params[:schedule_id])
  end

  def schedule_layer
    @schedule_layer = @schedule.schedule_layers.find_by(uuid: params[:id])
  end

  def schedule_layer_params
    params.require(:schedule_layer).permit(:duration, :rule, :count, :position)
  end
end
