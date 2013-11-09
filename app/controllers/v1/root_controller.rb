class V1::RootController < V1::ApplicationController
  respond_to :json

  # doorkeeper_for :me
  before_action :authenticate_user!,  only: [ :me ]

  def index
    render json: {
      message: "Revi.ly API",
      version: 1,
      _links: {
        self: { href: "/" },
        hooks: { href: "/hooks" },
        incidents: { href: "/incidents" },
        policies: { href: "/policies" },
        schedules: { href: "/schedules" },
        services: { href: "/services" },
        users: { href: "/users" }
      }
    }
  end

  def me
    respond_with current_user
  end

end
