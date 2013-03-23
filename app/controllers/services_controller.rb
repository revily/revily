class ServicesController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!
  
  def index
    @services = Service.all

    respond_with @service
  end

  def show
    @service = Service.find_by_uuid(params[:id]).decorate

    respond_with @service
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
    @service.save

    respond_with @service
  end

  def edit
    @service = Service.find_by_uuid(params[:id]).decorate

    respond_with @service
  end

  def update
    @service = Service.find_by_uuid(params[:id])
    @service.update_attributes(service_params)

    respond_with @service
  end

  def destroy
    @service = Service.find_by_uuid(params[:id])
    @service.destroy

    respond_with @service
  end

  private

  def service_params
    params.require(:service).permit(:name, :acknowledge_timeout, :auto_resolve_timeout)
  end
end
