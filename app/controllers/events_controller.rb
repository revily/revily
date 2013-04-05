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
    @event = events.where(uuid: params[:id]).first.decorate

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
    @event = events.where(uuid: params[:id]).first
    @event.update_attributes(event_params)

    respond_with @event
  end

  def destroy
    @event = events.where(uuid: params[:id]).first
    @event.destroy

    respond_with @event.service, @event
  end

  private

  def event_params
    params.require(:event).permit(:message, :details)
  end

  def service
    @service ||= current_account.services.where(uuid: params[:service_id]).first if params[:service_id]
  end

  def events
    @events ||= (@service) ? @service.events : Event
  end
end
