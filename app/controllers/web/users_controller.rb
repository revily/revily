class Web::UsersController < Web::ApplicationController
  before_action :user, only: [:show, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "User was successfully created."
    else
      flash[:alert] = "User could not be created."
    end

    respond_with @user
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "User was successfully updated."
    else
      flash[:alert] = "User could not be updated."
    end

    respond_with @user
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def user
    @user = User.find_by(uuid: params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
