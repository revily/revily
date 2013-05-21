class V1::UsersController < V1::ApplicationController

  respond_to :json

  def index
    @users = current_account.users

    respond_with @users
  end

  def show
    @user = current_account.users.where(uuid: params[:id]).first

    respond_with @user
  end
  
end
