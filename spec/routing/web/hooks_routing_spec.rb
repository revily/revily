require "spec_helper"

describe Web::HooksController do
  it "routing" do
    expect(get: "/hooks").to route_to("web/hooks#index")
    expect(post: "/hooks").to route_to("web/hooks#create")
    expect(get: "/hooks/1").to route_to("web/hooks#show", params(:id))
    expect(put: "/hooks/1").to route_to("web/hooks#update", params(:id))
    expect(delete: "/hooks/1").to route_to("web/hooks#destroy", params(:id))
  end
end
