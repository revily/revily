class V1::UsersController < V1::ApplicationController

  respond_to :html, :json

  def index
    @users = current_account.users
  end

  def show
    @user = current_account.users.find(params[:id])
  end
  
end
