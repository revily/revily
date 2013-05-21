class V1::ServicesController < V1::ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!

  def index
    @services = current_account.services.enabled.includes(:incidents).decorate
    @disabled_services = current_account.services.disabled.decorate
    respond_with @services
  end

  def show
    @service = current_account.services.where(uuid: params[:id]).first.decorate

    respond_with @service
  end

  def new
    @service = current_account.services.new

    respond_with @service
  end

  def create
    @service = current_account.services.new(sanitized_params)
    @service.save

    respond_with @service
  end

  def edit
    @service = current_account.services.where(uuid: params[:id]).first.decorate

    respond_with @service
  end

  def update
    @service = current_account.services.where(uuid: params[:id]).first
    @service.update_attributes(sanitized_params)

    respond_with @service
  end

  def enable
    @service = current_account.services.where(uuid: params[:id]).first
    @service.enable && hound_action(@service, 'enable')

    respond_with @service
  end

  def disable
    @service = current_account.services.where(uuid: params[:id]).first
    @service.disable && hound_action(@service, 'disable')
    respond_with @service
  end

  def destroy
    @service = current_account.services.where(uuid: params[:id]).first
    @service.destroy

    respond_with @service
  end

  private

  def permitted_params
    [:name, :acknowledge_timeout, :auto_resolve_timeout]
  end

end
