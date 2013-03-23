class EventsController < ApplicationController
  respond_to :html, :json

  before_filter :service, :events

  def index
    @events = events.all

    respond_with @events
  end

  def show
    @event = events.find(params[:id])

    respond_with @event
  end

  def new
    @event = events.new

    respond_with @event
  end

  def create
    @event = events.create(event_params)

    respond_with @event
  end

  def update
    @event = events.update(params[:id], event_params)

    respond_with @event
  end

  def destroy
    @event = events.find(params[:id])
    @event.destroy

    respond_with @event.service, @event
  end

  private

  def event_params
    params.require(:event).permit(:message, :details)
  end

  def service
    @service ||= Service.find(params[:service_id]) if params[:service_id]
  end

  def events
    @events ||= (@service) ? @service.events : Event
  end
end
