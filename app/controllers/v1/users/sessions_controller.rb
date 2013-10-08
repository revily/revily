class V1::Users::SessionsController < Devise::SessionsController
  before_filter :authenticate_user!, except: [ :create ]
  before_filter :ensure_params_exist, except: [ :destroy ]
  respond_to :json

  def create
    resource = User.find_for_database_authentication(email: session_params[:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(session_params[:password])
      sign_in(:user, resource)
      resource.ensure_authentication_token!
      render json: { id: resource.uuid, auth_token: resource.authentication_token }, status: :ok
      return
    end
    invalid_login_attempt
  end

  def destroy
    resource = User.find_by_authentication_token(params[:auth_token] || header_token)
    sign_out(resource_name)
    render json: {}.to_json, status: :ok
  end

  protected

  def session_params
    params.permit(:email, :password)
  end
  
  def ensure_params_exist
    return unless session_params[:email].blank? && session_params[:password].blank?
    render json: { message: "email and password are required parameters" }, status: 422
  end

  def invalid_login_attempt
    render json: { message: "there was an error with your email or password" }, status: 401
  end

  def header_token
    header_token = request.headers["Authorization"]
    if header_token && header_token =~ /^token (.+)$/
      $~[1]
    end
  end


  # def create
  #   return missing_params unless params[:email] && params[:password]

  #   build_resource
  #   resource = resource_from_credentials
  #   return invalid_credentials unless resource

  #   resource.ensure_authentication_token!
  #   data = {
  #     # user: {
  #       user_id: resource.id,
  #       auth_token: resource.authentication_token
  #     # }
  #   }

  #   render json: data, status: 201
  # end

  # def destroy
  #   return missing_params unless params[:auth_token]

  #   resource = resource_class.find_by_authentication_token(params[:auth_token])
  #   return invalid_credentials unless resource

  #   sign_out(resource_name)
  #   # resource.reset_authentication_token!

  #   render json: { user_id: resource.id }, status: 200
  # end

  # protected



  # def resource_from_credentials
  #   data = { email: params[:email] }
  #   if res = resource_class.find_for_database_authentication(data)
  #     if res.valid_password?(params[:password])
  #       res
  #     end
  #   end
  # end

  def missing_params
    warden.custom_failure!
    return render json: {}, status: 400
  end

  def invalid_credentials
    warden.custom_failure!
    render json: {}, status: 401
  end

end
