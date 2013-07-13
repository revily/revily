class V1::UsersController < V1::ApplicationController
  respond_to :json

  before_action :users
  
  def index
    @users = users

    respond_with @users
  end

  def show
    @user = users.find_by!(uuid: params[:id])

    respond_with @user
  end
  
  private

  def users
    @users ||= current_account.users
  end

end
