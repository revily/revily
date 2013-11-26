require "spec_helper"

describe V1::ServicesController do
  it "routing" do
    expect(get: "/api/services").to route_to("v1/services#index", json_params)
    expect(get: "/api/services/1").to route_to("v1/services#show", json_params(:id))
    expect(post: "/api/services").to route_to("v1/services#create", json_params)
    expect(put: "/api/services/1").to route_to("v1/services#update", json_params(:id))
    expect(delete: "/api/services/1").to route_to("v1/services#destroy", json_params(:id))
    expect(put: "/api/services/1/enable").to route_to("v1/services#enable", json_params(:id))
    expect(put: "/api/services/1/disable").to route_to("v1/services#disable", json_params(:id))
  end
end
