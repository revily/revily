class V1::UsersController < V1::ApplicationController
  respond_to :json

  before_action :users
  
  def index
    @users = users.page(params[:page])

    respond_with @users, serializer: PaginationSerializer
  end

  def show
    @user = users.find_by!(uuid: params[:id])

    respond_with @user
  end
  
  private

  def users
    @users ||= User.all
  end

end
