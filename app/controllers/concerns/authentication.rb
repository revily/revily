module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :warden, :signed_in?, :current_user, :current_account, :current_actor, :current_service
  end

  # protected

  def current_user
    @current_user ||= warden.user(scope: :user)
  end

  def current_service
    @current_service ||= warden.user(scope: :service)
  end

  def user_signed_in?
    !!current_user
  end

  def service_signed_in?
    !!current_service
  end

  def sign_in(scope, resource)
    if warden.user(scope: scope) == resource
      true
    else
      warden.set_user(resource, scope: scope)
    end
  end

  def sign_out(scope=nil)
    return sign_out_all_scopes unless scope
    user = warden.user(scope: scope, run_callbacks: false)

    warden.raw_session.inspect
    warden.logout(scope)
    warden.clear_strategies_cache!(scope: scope)
    instance_variable_set(:"@current_#{scope}", nil)

    !!user
  end

  def sign_out_all_scopes
    users = [ :user, :service ].map {|s| warden.user(scope: s, run_callbacks: false) }

    warden.raw_session.inspect
    warden.logout
    warden.clear_strategies_cache!

    users.any?
  end

  def warden
    request.env["warden"]
  end

  def authenticate_user!
    authenticate!(:user)
    # sign_in :user, current_
  end

  def authenticate_service!
    authenticate!(:service)
    # sign_in :service, current_service
  end

  def authenticate!(scope)
    # current_actor = warden.authenticate!(scope: scope)
    current_actor = warden.authenticate!(scope: scope)
    # logger.info warden.user(scope: scope).inspect
    # logger.info current_actor.inspect
    set_current_actor
    set_current_account
  end

  def current_resource_owner
    current_user
  end

  def set_current_actor
    Revily::Event.actor = current_actor
  end

  def current_actor
    @current_actor #||= (current_user || current_service || nil)
  end

  def current_actor=(current_actor)
    @current_actor = current_actor
  end

  def set_current_account
    Account.current = current_account
  end

  def current_account
    @current_account ||= current_actor.try(:account)
  end

  def current_account=(current_account)
    @current_account = current_account
  end
end
