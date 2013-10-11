class V1::HooksController < V1::ApplicationController
  respond_to :json

  doorkeeper_for :all, scopes: [ :read, :write ]
  
  before_action :hooks

  def list
    
  end

  def index
    @hooks = hooks.page(params[:page])

    respond_with @hooks#, serializer: PaginationSerializer
  end

  def show
    @hook = hooks.find_by!(uuid: params[:id])

    respond_with @hook
  end

  def new
    @hook = hooks.new

    respond_with @hook
  end

  def create
    @hook = hooks.new(hook_params)
    @hook.save

    respond_with @hook
  end

  def update
    @hook = hooks.find_by!(uuid: params[:id])
    @hook.update_attributes(hook_params)

    respond_with @hook
  end

  def enable
    @hook = hooks.find_by!(uuid: params[:id])
    @hook.enable

    respond_with @hook
  end

  def disable
    @hook = hooks.find_by!(uuid: params[:id])
    @hook.disable

    respond_with @hook
  end

  def destroy
    @hook = hooks.find_by!(uuid: params[:id])
    @hook.destroy

    respond_with @hook
  end
  private

  def hooks
    @hooks ||= Hook.all
  end

  def hook_params
    params.permit(:name, events: [], config: [{}])
  end

end
