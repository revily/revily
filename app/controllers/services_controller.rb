class ServicesController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!
  
  def index
    @services = current_account.services.decorate

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
    @service = current_account.services.new(service_params)
    @service.save

    respond_with @service
  end

  def edit
    @service = current_account.services.where(uuid: params[:id]).first.decorate

    respond_with @service
  end

  def update
    @service = current_account.services.where(uuid: params[:id]).first
    @service.update_attributes(service_params)

    respond_with @service
  end

  def destroy
    @service = current_account.services.where(uuid: params[:id]).first
    @service.destroy

    respond_with @service
  end

  private

  def service_params
    params.require(:service).permit(:name, :acknowledge_timeout, :auto_resolve_timeout)
  end
end
