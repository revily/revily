class DashboardController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!

  def index
    @assigned_events = current_user.events.unresolved.decorate
    @open_events = current_account.events.decorate
    @all_events = current_account.events.decorate

    @services = current_account.services.decorate
    
    respond_with @events
  end
  
end
