class V1::ServicesController < V1::ApplicationController
  respond_to :json

  before_filter :authenticate_user!
  before_filter :services
  
  def index
    @services = services.all
    respond_with @services
  end

  def show
    @service = services.where(uuid: params[:id]).first.decorate

    respond_with @service
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

  def edit
    @service = services.where(uuid: params[:id]).first.decorate

    respond_with @service
  end

  def update
    @service = services.where(uuid: params[:id]).first
    @service.update_attributes(service_params)

    respond_with @service
  end

  def enable
    @service = services.where(uuid: params[:id]).first
    @service.enable && hound_action(@service, 'enable')

    respond_with @service
  end

  def disable
    @service = services.where(uuid: params[:id]).first
    @service.disable && hound_action(@service, 'disable')
    respond_with @service
  end

  def destroy
    @service = services.where(uuid: params[:id]).first
    @service.destroy

    respond_with @service
  end

  private

  def services
    @services ||= current_account.services
  end

  def service_params
    params.permit(:name, :acknowledge_timeout, :auto_resolve_timeout)
  end

end
