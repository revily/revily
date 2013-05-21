class V1::ApplicationController < ActionController::Base
  respond_to :json

  def after_sign_in_path_for(resource_or_scope)
    dashboard_url
  end

  def current_account
    current_user.account
  end
  helper_method :current_account

  protected

  def default_json
    request.format = :json if params[:format].nil?
  end

  def auth!
    unless params[:auth_token] && user_signed_in?
      render json: {}, status: 401
    end
  end
  
end
