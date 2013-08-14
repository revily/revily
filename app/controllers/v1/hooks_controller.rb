class V1::HooksController < V1::ApplicationController
  include Revily::Event::Mixins::Controller
  
  respond_to :json

  before_action :authenticate_user!
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

  def create
    logger.info params
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
    logger.info params.inspect
    params.permit(:name, events: [], config: [{}])
  end

end
