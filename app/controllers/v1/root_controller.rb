class V1::RootController < V1::ApplicationController
  respond_to :json
  
  def index
    render json: {
      incidents_url: incidents_url,
      services_url: services_url,
      policies_url: policies_url,
      schedules_url: schedules_url,
      users_url: users_url
    }
  end

end