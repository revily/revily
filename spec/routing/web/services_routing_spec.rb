require "spec_helper"

describe Web::ServicesController do
  it "routing" do
    expect(get: "/services").to route_to("web/services#index")
    expect(post: "/services").to route_to("web/services#create")
    expect(get: "/services/1").to route_to("web/services#show", params(:id))
    expect(put: "/services/1").to route_to("web/services#update", params(:id))
    expect(delete: "/services/1").to route_to("web/services#destroy", params(:id))
  end
end
