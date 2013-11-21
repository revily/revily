class V1::ApplicationController < ActionController::Base
  include Authentication

  respond_to :json
  # protect_from_forgery with: :null_session
  # skip_before_action :verify_authenticity_token, 
    # if: ->(c) { c.request.format == "application/json" }
  
  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError do |exception|
    render json: { error: "not found" }, status: :not_found
  end

  protected

  def query_params
    @query_params ||= request.query_parameters.inject({}) do |res, (key, value)|
      res[key] = value.is_a?(String) ? value.strip.split(",") : value
      res
    end
  end

  def expand_params
    @expand_params ||= (params[:expand]) ? params[:expand].split(",") : []
  end

end
