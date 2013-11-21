class DashboardController < ApplicationController
  respond_to :html
  protect_from_forgery

  # before_action :authenticate_user!

  def index
    Rails.logger.info ap session.inspect
    Rails.logger.info ap current_user
  end

  def sink
  end
end
