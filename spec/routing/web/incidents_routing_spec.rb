require "spec_helper"

describe Web::IncidentsController do
  it "routing" do
    expect(get: "/incidents").to route_to("web/incidents#index", params)
    expect(get: "/services/1/incidents").to route_to("web/incidents#index", params(:service_id))
    expect(get: "/services/1/incidents/1").to route_to("web/incidents#show", params(:id, :service_id))
  end
end
