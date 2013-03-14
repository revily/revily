class EventsController < ApplicationController
  respond_to :html, :json

  def index
    @events = Event.all

    respond_with @events
  end

  def show
    @event = Event.find(params[:id])

    respond_with @event
  end

  def create
    @event = Event.create(params[:event])

    respond_with @event
  end

  def update
    @event = Event.update(params[:id], params[:event])

    respond_with @event
  end

  def destroy
    @event = Event.destroy(params[:id])

    respond_with @event
  end
end
