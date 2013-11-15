class Web::HooksController < Web::ApplicationController
  before_action :hook, only: [:show, :update, :destroy]

  def index
    @hooks = Hook.all

    respond_with @hooks
  end

  def show
    respond_with @hooks
  end

  def create
    @hook = Hook.new(hook_params)
    if @hook.save
      flash[:notice] = "Hook was successfully created."
    else
      flash[:alert] = "Hook could not be created."
    end

    respond_with @hook, location: hooks_path
  end

  def update
    if @hook.update(hook_params)
      flash[:notice] = "Hook was successfully updated."
    else
      flash[:alert] = "Hook could not be updated."
    end

    respond_with @hook
  end

  def destroy
    if @hook.destroy
      flash[:notice] = "Hook was successfully deleted."
    else
      flash[:alert] = "Hook could not be deleted."
    end

    respond_with @hook
  end

  private

  def hook
    @hook = Hook.find_by(uuid: params[:id])
  end

  def hook_params
    params.require(:hook).permit(:name, :handler, :config, :events)
  end
end
