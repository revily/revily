class IntegrationController < ApplicationController

  before_filter :authenticate_service!

  respond_to :json

  def trigger
    # @event ||= current_service.events.where("key = ? AND state != 'resolved'", params[:key]).first if params[:key]
    # @event ||= current_service.events.where("message = ? AND state != 'resolved'", params[:message]).first
    # @event ||= current_service.events.create(event_params)

    # @event = current_service.events.key_or_message(key_or_message).first_or_initialize(trigger_event_params)

    @event = current_service.events.where("key = ? AND state != 'resolved'", params[:key]).first_or_initialize(trigger_event_params)

    respond_with @event do |format|

      # if @event.new_record? && @event.save
      if @event.save
        hound_action @event, 'trigger'
        format.json { render json: @event, status: :accepted }
      else
        format.json { render json: @event.errors, status: unprocessable_entity }
      end
    end
    # else
      # hound_action @event, 'trigger'
      # respond_with @event, status: :not_modified
    # end

  end

  def resolve
    @event = current_service.events.key_or_message(key_or_message).first

    if @event
      @event.resolve
      hound_action @event, 'resolve' if @event
    end

    respond_with @event
  end

  # private
  # protected
  def hound_user
    current_service
  end

  private

  def trigger_event_params
    # params.require(:event).permit(:message, :description, :key)
    params.permit(:message, :description, :key)
  end

  def resolve_event_params
    # params.require(:event).permit(:message, :description, :key, :id)
    params.permit(:message, :description, :key, :id)
  end

  def key_or_uuid
    "%#{params[:key] || params[:id]}%"
  end

  def key_or_message
    "%#{params[:key] || params[:message]}%"
  end
end
