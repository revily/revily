class V1::Users::SessionsController < V1::ApplicationController
  respond_to :json

  before_filter :authenticate_user!, except: [ :create ]
  before_filter :ensure_params_exist, except: [ :destroy ]

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

  def missing_params
    warden.custom_failure!
    return render json: {}, status: 400
  end

  def invalid_credentials
    warden.custom_failure!
    render json: {}, status: 401
  end

end
