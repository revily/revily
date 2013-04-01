class DashboardController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!

  def index
    @events = current_user.events.unresolved.decorate
    @all_events = current_user.events.decorate
    respond_with @events
  end
  
end
