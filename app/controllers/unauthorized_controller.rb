class UnauthorizedController < ActionController::Metal
  include ActionController::RackDelegation
  include ActionController::UrlFor
  include ActionController::Redirecting
  include ActionController::Rendering
  include ActionController::Renderers::All
  
  def respond
    render json: { error: I18n.t(warden_message) }, status: :unauthorized
  end

  def warden
    env["warden"]
  end

  def warden_options
    env["warden.options"]
  end

  def warden_message
    @message ||= (warden && warden.message[:message] || warden_options.fetch(:message, "unauthorized.user"))
  end

end
