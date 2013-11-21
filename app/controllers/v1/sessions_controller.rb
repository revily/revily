class V1::SessionsController < V1::ApplicationController
  respond_to :json
  
  skip_before_action :authenticate_user!, only: [ :new, :create ]

  def new
    @session = Session.new
  end

  def create
    Rails.logger.info params.inspect
    @user = warden.authenticate!(scope: :user)
    sign_in(:user, @user)
    # respond_with @user, location: dashboard_path
    # respond_with current_user
    render json: { id: @user.uuid, authentication_token: @user.authentication_token }, status: :created
  end

  def destroy
    warden.logout
    redirect_to :root
  end
end
