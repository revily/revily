class Api::V1::EventsController < Api::V1::BaseController
  respond_to :json

  before_filter :authenticate_user!
  before_filter :service, :events

  api :GET, '/events', 'List all events'
  api :GET, '/services/:service_id/events', 'List all events for a given service'
  param :service_id, :number, desc: 'The service id', required: true
  def index
    @events = events.all

    respond_with @events
  end

  api :GET, '/events/:id', 'Show an event'
  param :id, :number, desc: 'The event id', required: true
  def show
    @event = events.find(params[:id])

    respond_with @event
  end

  api :POST, '/services/:service_id/events', 'Create an event'
  param :service_id, String, desc: 'the id of the service', required: true
  param :key, String, desc: 'unique key used to identify the event', required: true
  param :message, String, desc: 'short message defining the event', required: true
  param :description, String, desc: 'in-depth details of the event'
  def create
    @event = events.new(event_params)
    @event.save

    respond_with @event
  end

  api :PUT, '/events/:id', 'Update an event'
  param :service_id, String, desc: 'the id of the service', required: true
  param :id, String, desc: 'unique key used to identify the event', required: true
  param :message, String, desc: 'short message defining the event'
  param :description, String, desc: 'in-depth details of the event'
  def update
    @event = events.find(params[:id])
    @event.update_attributes(event_params)

    respond_with @event
  end

  api :DELETE, '/events/:id', 'Delete an event'
  def destroy
    @event = events.find(params[:id])
    @event.destroy

    respond_with @event
  end

  private

  def event_params
    params.permit(:key, :message, :description)
  end

  def service
    @service ||= Service.find(params[:service_id]) if params[:service_id]
  end

  def events
    @events ||= (@service) ? @service.events : Event
  end
end
