class EventsController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!
  before_filter :service, :events

  def index
    @events = events.all
    location_url = service ? service_events_url : events_url
    respond_with @events, location: location_url
  end

  def show
    @event = events.find_by_uuid(params[:id]).decorate

    respond_with @event
  end

  def new
    @event = events.new

    respond_with @event
  end

  def create
    @event = events.new(event_params)
    @event.save

    respond_with @event
  end

  def update
    @event = events.find_by_uuid(params[:id])
    @event.update_attributes(event_params)

    respond_with @event
  end

  def destroy
    @event = events.find_by_uuid(params[:id])
    @event.destroy

    respond_with @event.service, @event
  end

  private

  def event_params
    params.require(:event).permit(:message, :details)
  end

  def service
    @service ||= Service.find_by_uuid(params[:service_id]) if params[:service_id]
  end

  def events
    @events ||= (@service) ? @service.events : Event
  end
end
