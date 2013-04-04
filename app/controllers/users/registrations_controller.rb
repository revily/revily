class Users::RegistrationsController < Devise::RegistrationsController
  def new
    @registration = Forms::Registration.new
  end

  def create
    @registration = Forms::Registration.new(params[:registration])

    if @registration.save
      resource = @registration.user

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(:user, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end

    user = User.new(params[:user])
    account = Account.new(subdomain: params[:subdomain])
  end

  private

  # def resource
    # @user
  # end

  # def resource_name

  # end
end
