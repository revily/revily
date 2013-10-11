class V1::UsersController < V1::ApplicationController
  respond_to :json

  doorkeeper_for :all, scopes: [ :read, :write ]

  before_action :users
  
  def index
    @users = users.page(params[:page])

    respond_with @users#, serializer: PaginationSerializer
  end

  def show
    @user = users.find_by!(uuid: params[:id])

    respond_with @user
  end

  def new
    @user = users.new

    respond_with @user
  end

  def create
    @user = users.new(user_params)
    @user.save

    respond_with @user
  end

  def update
    @user = users.find_by!(uuid: params[:id])
    @user.update_attributes(user_params)
  
    respond_with @user
  end

  def destroy
    @user = users.find_by!(uuid: params[:id])
    @user.destroy

    respond_with @user
  end

  private

  def users
    @users ||= User.all
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

end
