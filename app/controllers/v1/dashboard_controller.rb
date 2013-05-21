class V1::DashboardController < V1::ApplicationController
  respond_to :html

  before_filter :authenticate_user!

  def index

    @assigned_incidents = current_user.incidents.unresolved.decorate
    @open_incidents = current_account.incidents.decorate
    @all_incidents = current_account.incidents.decorate

    @services = current_account.services.includes(:incidents).decorate
    
    respond_with @incidents
  end
  
end
