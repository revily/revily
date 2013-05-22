class V1::UsersController < V1::ApplicationController
  respond_to :json

  before_filter :users
  
  def index
    @users = users.all

    respond_with @users
  end

  def show
    @user = users.where(uuid: params[:id]).first

    respond_with @user
  end
  
  private

  def users
    @users ||= current_account.users
  end

end
