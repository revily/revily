require "spec_helper"

describe V1::IncidentsController do
  it "routing" do
    expect(get: "/api/services/1/incidents").to route_to("v1/incidents#index", json_params(:service_id))
    expect(get: "/api/incidents/1").to route_to("v1/incidents#show", json_params(:id))
    expect(post: "/api/services/1/incidents").to route_to("v1/incidents#create", json_params(:service_id))
    expect(put: "/api/incidents/1").to route_to("v1/incidents#update", json_params(:id))
    expect(delete: "/api/incidents/1").to route_to("v1/incidents#destroy", json_params(:id))
    expect(put: "/api/incidents/1/trigger").to route_to("v1/incidents#trigger", json_params(:id))
    expect(put: "/api/incidents/1/acknowledge").to route_to("v1/incidents#acknowledge", json_params(:id))
    expect(put: "/api/incidents/1/resolve").to route_to("v1/incidents#resolve", json_params(:id))
  end
end
