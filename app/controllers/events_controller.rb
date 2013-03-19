class EventsController < ApplicationController
  respond_to :html, :json

  before_filter :service

  def index
    @events = Event.all

    respond_with @events
  end

  def show
    @event = Event.find(params[:id])

    respond_with @event
  end

  def new
    @event = service.events.new

    respond_with @event
  end

  def create
    @event = service.events.create(event_params)

    respond_with service, @event
  end

  def update
    @event = Event.update(params[:id], event_params)

    respond_with service, @event
  end

  def destroy
    @event = Event.destroy(params[:id])

    respond_with service, @event
  end

  private

  def event_params
    params.require(:event).permit(:message, :details)
  end

  def service
    @service ||= Service.find(params[:service_id])
  end
end
