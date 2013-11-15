require "spec_helper"

describe V1::PoliciesController do
  it "routing" do
    expect(get: "/api/policies").to route_to("v1/policies#index", json_params)
    expect(get: "/api/policies/1").to route_to("v1/policies#show", json_params(:id))
    expect(post: "/api/policies").to route_to("v1/policies#create", json_params)
    expect(put: "/api/policies/1").to route_to("v1/policies#update", json_params(:id))
    expect(delete: "/api/policies/1").to route_to("v1/policies#destroy", json_params(:id))
  end
end
