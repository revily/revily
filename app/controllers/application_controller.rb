class ApplicationController < ActionController::Base
  respond_to :json
  
  protect_from_forgery
  
  def after_sign_in_path_for(resource_or_scope)
    dashboard_url
  end

  def current_account
    current_user.account
  end
  helper_method :current_account

end
