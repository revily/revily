class Web::ServicesController < Web::ApplicationController
  before_action :service, only: [:show, :update, :destroy]

  def index
    @services = Service.all
  end

  def show
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      flash[:notice] = "Service was successfully created."
    else
      flash[:alert] = "Service could not be created."
    end

    respond_with @service
  end

  def update
    if @service.update(service_params)
      redirect_to @service, notice: 'Service was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @service.destroy
    redirect_to services_url, notice: 'Service was successfully destroyed.'
  end

  private
  
  def service
    @service = Service.find_by(uuid: params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :auto_resolve_timeout, :acknowledge_timeout)
  end
end
