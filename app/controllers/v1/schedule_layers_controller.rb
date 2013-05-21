class V1::ScheduleLayersController < V1::ApplicationController
  respond_to :json

  before_filter :schedule, :schedule_layers

  def index
    @schedule_layers = schedule_layers.all

    respond_with schedule, @schedule_layers
  end

  def show
    @schedule_layer = schedule_layers.find_by_uuid(params[:id])

    respond_with schedule, @schedule_layer
  end

  def new
    @schedule_layer = schedule_layers.new

    respond_with schedule, @schedule_layer
  end

  def create
    @schedule_layer = schedule_layers.create(sanitized_params)

    respond_with schedule, @schedule_layer
  end

  def update
    @schedule_layer = schedule_layers.find_by_uuid(params[:id])
    @schedule_layer.update_attributes(sanitized_params)

    respond_with schedule, @schedule_layer
  end

  def destroy
    @schedule_layer = schedule_layers.find_by_uuid(params[:id])
    @schedule_layer.destroy

    respond_with schedule, @schedule_layer
  end

  private

  def permitted_params
    [ :position, :rule, :count, :start_at, :schedule_id, :users ]
  end

  def schedule
    @schedule ||= Schedule.where(uuid: params[:schedule_id]).first if params[:schedule_id]
  end

  def schedule_layers
    @schedule_layers ||= (@schedule) ? @schedule.schedule_layers : ScheduleLayer
  end
end
