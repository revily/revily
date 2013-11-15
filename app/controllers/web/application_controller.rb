class Web::ApplicationController < ActionController::Base
  include Authentication
  before_action :authenticate_user!

  respond_to :html

  layout "application"

  protect_from_forgery
end
