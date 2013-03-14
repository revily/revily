class IntegrationController < ApplicationController
  before_filter :authenticate_service!

  respond_to :json

  def trigger
    @event = current_service.events.new(params[:event])
    respond_with @event, :location => '/'
    # respond_with params, :location => '/'
  end

  def acknowledge
  end

  def resolve
  end
end
