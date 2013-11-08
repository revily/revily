class Integration::ApplicationController < ActionController::Base
  include Authentication

  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError do |exception|
    render json: { error: "not found" }, status: :not_found
  end
end
