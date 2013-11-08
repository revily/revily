class ApplicationController < ActionController::Base
  include Authentication
  
  respond_to :html

  protect_from_forgery
end
