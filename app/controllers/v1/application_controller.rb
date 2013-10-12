class V1::ApplicationController < ActionController::Base
  respond_to :json

  prepend_before_action :set_current_actor
  set_current_tenant_through_filter
  before_action :set_tenant

  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError do |exception|
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

  def current_resource_owner
    current_user
  end

  def set_current_actor
    Revily::Event.actor = current_actor
  end

  def current_actor
    current_user || current_service || nil
    # current_resource_owner || current_user || current_service
  end
  helper_method :current_actor

  def current_account
    current_actor.try(:account)
  end
  helper_method :current_account

end
