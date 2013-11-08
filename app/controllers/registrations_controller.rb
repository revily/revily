class RegistrationsController < ApplicationController
  skip_before_filter :authenticate!

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to :root, notice: t("registrations.user.success")
    end
  end

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
