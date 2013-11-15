require "spec_helper"

describe Web::EventsController do
  it "routing" do
    expect(get: "/events").to route_to("web/events#index")
    expect(get: "/events/1").to route_to("web/events#show", params(:id))
  end
end
