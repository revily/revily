require "spec_helper"

describe Web::PolicyRulesController do
  it "routing" do
    expect(post: "/policies/1/policy_rules").to route_to("web/policy_rules#create", params(:policy_id))
    expect(put: "/policies/1/policy_rules/1").to route_to("web/policy_rules#update", params(:id, :policy_id))
    expect(delete: "/policies/1/policy_rules/1").to route_to("web/policy_rules#destroy", params(:id, :policy_id))
  end
end
