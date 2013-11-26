require "spec_helper"

describe V1::PolicyRulesController do
  it "routing" do
    expect(get: "/api/policies/1/policy_rules").to route_to("v1/policy_rules#index", json_params(:policy_id))
    expect(get: "/api/policy_rules/1").to route_to("v1/policy_rules#show", json_params(:id))
    expect(post: "/api/policies/1/policy_rules").to route_to("v1/policy_rules#create", json_params(:policy_id))
    expect(put: "/api/policy_rules/1").to route_to("v1/policy_rules#update", json_params(:id))
    expect(delete: "/api/policy_rules/1").to route_to("v1/policy_rules#destroy", json_params(:id))
  end
end
