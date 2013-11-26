require "spec_helper"

describe V1::HooksController do
  it "routing" do
    expect(get: "/api/hooks").to route_to("v1/hooks#index", json_params)
    expect(get: "/api/hooks/1").to route_to("v1/hooks#show", json_params(:id))
    expect(post: "/api/hooks").to route_to("v1/hooks#create", json_params)
    expect(put: "/api/hooks/1").to route_to("v1/hooks#update", json_params(:id))
    expect(delete: "/api/hooks/1").to route_to("v1/hooks#destroy", json_params(:id))
    expect(put: "/api/hooks/1/enable").to route_to("v1/hooks#enable", json_params(:id))
    expect(put: "/api/hooks/1/disable").to route_to("v1/hooks#disable", json_params(:id))
  end
end
