class Web::SessionsController < Web::ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create ]

  def new
    @session = Session.new
  end

  def create
    @user = warden.authenticate!(scope: :user)
    sign_in(:user, @user)
    respond_with @user, location: dashboard_path
  end

  def destroy
    warden.logout
    redirect_to :root
  end
end
