class V1::EventsController < V1::ApplicationController
  respond_to :json

  # doorkeeper_for :all, scopes: [ :read, :write ]
  before_action :authenticate_user!
  before_action :events

  def index
    @events = events.page(params[:page])
    respond_with @events
  end

  def show
    @event = events.find_by!(uuid: params[:id])

    respond_with @event
  end

  private

  def events
    @events ||= Event.all
  end
end
