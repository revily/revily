require "spec_helper"

describe Web::PoliciesController do
  it "routing" do
    expect(get: "/policies").to route_to("web/policies#index")
    expect(post: "/policies").to route_to("web/policies#create")
    expect(get: "/policies/1").to route_to("web/policies#show", params(:id))
    expect(put: "/policies/1").to route_to("web/policies#update", params(:id))
    expect(delete: "/policies/1").to route_to("web/policies#destroy", params(:id))
  end
end
