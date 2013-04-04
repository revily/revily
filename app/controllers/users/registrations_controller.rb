class Users::RegistrationsController < Devise::RegistrationsController
  # def new
    # @registration = Forms::Registration.new
  # end

  def new
    @accout = Account.new
    resource = build_resource({})
    respond_with resource
  end

  def create
    subdomain = params[resource_name].delete(:subdomain)
    account = Account.new(subdomain: subdomain)
    self.resource = build_resource(resource_params) #, {unsafe: true})
    resource.account = account

    if account.save && resource.save
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

  end

  # def resource_params
    # params[resource_name].merge(:account_id => @account.id)
  # end

  # def resource
    # @user
  # end

  # def resource_name

  # end
end
