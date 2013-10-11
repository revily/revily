class V1::ApplicationController < ActionController::Base
  respond_to :json

  prepend_before_action :set_current_actor

  # before_action do
  #   logger.debug ap current_actor
  #   logger.debug ap current_account
  #   logger.debug ap doorkeeper_token
  #   logger.debug ap request.headers["Authorization"]
  # end

  set_current_tenant_through_filter
  before_action :set_tenant

  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError do |e|
    render json: { error: 'not found' }, status: :not_found
  end

  def after_sign_in_path_for(resource_or_scope)
    dashboard_url
  end

  protected

  def set_tenant
    set_current_tenant current_actor.try(:account)
  end

  def default_json
    request.format = :json if params[:format].nil?
  end

  def auth!
    unless params[:auth_token] && ( user_signed_in? || service_signed_in? )
      # render json: {}, status: 401
      render nothing: true, status: 401
    end
  end

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_actor
    # current_user || current_service || nil
    current_resource_owner || current_service
  end
  helper_method :current_actor

  def set_current_actor
    Revily::Event.actor = current_actor
  end

  def current_account
    current_actor.try(:account)
  end
  helper_method :current_account
  
end
