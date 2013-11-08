class UnauthorizedController < ActionController::Metal
  include ActionController::RackDelegation
  include ActionController::UrlFor
  include ActionController::Redirecting
  include ActionController::Rendering
  include ActionController::Renderers::All
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include Rails.application.routes.url_helpers
  include Rails.application.routes.mounted_helpers

  respond_to :html, :json

  delegate :flash, to: :request

  def respond
    respond_with do |format|
      format.json do
        render json: { error: warden_message }, status: :unauthorized
      end
      format.html do
        store_location
        if flash[:alert]
          flash.keep(:alert)
        else
          flash[:alert] = I18n.t(warden_message)
        end
        redirect_to new_sessions_url
      end
    end
  end

  def store_location
    session["return_to"] = attempted_path if request.get?
  end

  def warden
    env["warden"]
  end

  def warden_options
    env["warden.options"]
  end

  def warden_message
    @message ||= warden.message || warden_options.fetch(:message, "unauthorized.user")
  end

  def attempted_path
    warden_options[:attempted_path]
  end

end
