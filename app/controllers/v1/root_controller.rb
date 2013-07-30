class V1::RootController < V1::ApplicationController
  respond_to :json

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

end
