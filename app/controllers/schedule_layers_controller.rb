class ScheduleLayersController < ApplicationController
  respond_to :html, :json

  before_filter :schedule, :schedule_layers

  def index
    @schedule_layers = schedule_layers.all

    respond_with @schedule_layers
  end

  def show
    @schedule_layer = schedule_layers.find_by_uuid(params[:id])

    respond_with @schedule_layer
  end

  def new
    @schedule_layer = schedule_layers.new

    respond_with @schedule_layer
  end

  def create
    @schedule_layer = schedule_layers.create(schedule_layer_params)

    respond_with @schedule_layer
  end

  def update
    @schedule_layer = schedule_layers.update(params[:id], schedule_layer_params)

    respond_with @schedule_layer
  end

  def destroy
    @schedule_layer = schedule_layers.find_by_uuid(params[:id])
    @schedule_layer.destroy

    respond_with @schedule_layer.schedule, @schedule_layer
  end

  private

  def schedule_layer_params
    params.require(:schedule_layer).permit(:position, :rule, :count, :start_at, :schedule_id, :users)
  end

  def schedule
    @schedule ||= Schedule.find_by_uuid(params[:schedule_id]) if params[:schedule_id]
  end

  def schedule_layers
    @schedule_layers ||= (@schedule) ? @schedule.schedule_layers : ScheduleLayer
  end
end
