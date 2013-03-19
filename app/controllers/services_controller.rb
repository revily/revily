class ServicesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :json

  def index
    @services = Service.all

    respond_with @service
  end

  def show
    @service = Service.find(params[:id]).decorate

    respond_with @service
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.create(service_params)

    respond_with @service
  end

  def edit
    @service = Service.find(params[:id]).decorate

    respond_with @service
  end

  def update
    @service = Service.update(params[:id], service_params)

    respond_with @service
  end

  def destroy
    @service = Service.destroy(params[:id])

    respond_with @service
  end

  private

  def service_params
    params.require(:service).permit(:name, :acknowledge_timeout, :auto_resolve_timeout)
  end
end
