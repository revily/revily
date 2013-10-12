class V1::ScheduleLayersController < V1::ApplicationController
  respond_to :json

  # doorkeeper_for :all, scopes: [ :read, :write ]
  before_action :authenticate_user!
  before_action :schedule
  before_action :schedule_layers

  def index
    @schedule_layers = schedule_layers.page(params[:page])

    respond_with @schedule_layers#, serializer: PaginationSerializer
  end

  def show
    @schedule_layer = schedule_layers.find_by!(uuid: params[:id])

    respond_with schedule, @schedule_layer
  end

  def new
    @schedule_layer = schedule_layers.new

    respond_with @schedule_layer
  end

  def create
    @schedule_layer = schedule_layers.new(schedule_layer_params)
    @schedule_layer.account = current_account
    @schedule_layer.save

    respond_with schedule, @schedule_layer, location: schedule_schedule_layer_url(schedule, @schedule_layer)
  end

  def update
    @schedule_layer = schedule_layers.find_by!(uuid: params[:id])
    @schedule_layer.update_attributes(schedule_layer_params)

    respond_with schedule, @schedule_layer
  end

  def destroy
    @schedule_layer = schedule_layers.find_by!(uuid: params[:id])
    @schedule_layer.destroy

    respond_with schedule, @schedule_layer
  end

  private

    def schedule_layer_params
      params.permit(:position, :rule, :count, :start_at, :schedule_id, :users)
    end

    def schedule
      @schedule = Schedule.find_by!(uuid: params[:schedule_id]) if params[:schedule_id]
    end

    def schedule_layers
      @schedule_layers = (@schedule) ? @schedule.schedule_layers : ScheduleLayer.all
    end
end
