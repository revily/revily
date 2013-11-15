class Web::EventsController < Web::ApplicationController
  before_action :event, only: [ :show ]

  def index
    @events = Event.all

    respond_with @events
  end

  def show
    respond_with @event
  end

  private

  def event
    @event = Event.find_by(uuid: params[:id])
  end
end
