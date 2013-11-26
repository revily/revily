require "spec_helper"

describe V1::PoliciesController do
  it "routing" do
    expect(get: "/api/users").to route_to("v1/users#index", json_params)
    expect(get: "/api/users/1").to route_to("v1/users#show", json_params(:id))
    expect(post: "/api/users").to route_to("v1/users#create", json_params)
    expect(put: "/api/users/1").to route_to("v1/users#update", json_params(:id))
    expect(delete: "/api/users/1").to route_to("v1/users#destroy", json_params(:id))
  end
end
