class V1::RootController < V1::ApplicationController
  respond_to :json

  doorkeeper_for :me

  def index
    render json: {
      message: "Revi.ly API",
      version: 1,
      _links: {
        self: { href: '/' },
        hooks: { href: '/hooks' },
        incidents: { href: '/incidents' },
        policies: { href: '/policies' },
        schedules: { href: '/schedules' },
        services: { href: '/services' },
        users: { href: '/users' }
      }
    }
  end

  def me
    access_token = request.headers["Authorization"].match(/^Bearer (.+)$/)[1]
    @user = User.joins(:oauth_access_tokens).where("oauth_access_tokens.token = ?", access_token).first
    render json: @user
  end

end
