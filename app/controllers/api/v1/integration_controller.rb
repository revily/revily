class Api::V1::IntegrationController < Api::V1::BaseController
  before_filter :authenticate_service!

  respond_to :json

  def trigger
    @event = current_service.events.unresolved.first_or_initialize_by_key_or_message(event_params)

    http_status = @event.new_record? ? :created : :accepted

    respond_with @event do |format|
      if @event.save
        hound_action @event, 'trigger' if @event.new_record?
        format.json { render json: @event, status: http_status }
      else
        format.json { render json: { errors: @event.errors }, status: :unprocessable_entity }
      end
    end
  end

  def resolve
    @event = current_service.events.find_by_key_or_message(event_params)

    respond_with @event do |format|
      # if @event.persisted?
      if @event
        @event.resolve unless @event.resolved?
        hound_action @event, 'resolve'
        format.json { render json: @event, status: :accepted }
      else
        format.json { head :not_found }
      end
    end
  end

  protected

  def hound_user
    current_service
  end

  private

  def event_params
    logger.info params.inspect
    params.permit(:message, :description, :key)
  end

end
