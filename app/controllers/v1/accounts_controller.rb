class V1::AccountsController < V1::ApplicationController
  respond_to :json

  before_action :require_no_authentication, :only => [ :new, :create ]
  
  def new
  end

  def create
  end

end