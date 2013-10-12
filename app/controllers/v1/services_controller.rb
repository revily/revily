class V1::ServicesController < V1::ApplicationController
  respond_to :json

  # doorkeeper_for :all, scopes: [ :read, :write ]
  before_action :authenticate_user!
  before_action :services
  
  def index
    @services = services.page(params[:page])
    if stale? @services
      respond_with @services #, serializer: PaginationSerializer
    end
  end

  def show
    @service = services.find_by!(uuid: params[:id])

    if stale? @service
      respond_with @service
    end
  end

  def new
    @service = services.new

    respond_with @service
  end

  def create
    @service = services.new(service_params)
    @service.save

    respond_with @service
  end

  def update
    @service = services.find_by!(uuid: params[:id])
    @service.update_attributes(service_params)

    respond_with @service
  end

  def enable
    @service = services.find_by!(uuid: params[:id])
    @service.enable

    respond_with @service
  end

  def disable
    @service = services.find_by!(uuid: params[:id])
    @service.disable
    respond_with @service
  end

  def destroy
    @service = services.find_by!(uuid: params[:id])
    @service.destroy

    respond_with @service
  end

  private

  def services
    @services ||= Service.all
  end

  def service_params
    params.permit(:name, :acknowledge_timeout, :auto_resolve_timeout, :policy_id)
  end

end
