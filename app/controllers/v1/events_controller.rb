class V1::EventsController < V1::ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :events
  
  def index
    @events = events
    respond_with @events
  end

  def show
    @event = events.find_by!(uuid: params[:id])

    respond_with @event
  end

  private

  def events
    @events ||= current_account.events
  end
end
