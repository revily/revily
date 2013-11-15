require "spec_helper"

describe Integration::ProviderController do
  it "routing" do
    expect(put: "/trigger").to route_to("integration/provider#trigger")
    expect(put: "/acknowledge").to route_to("integration/provider#acknowledge")
    expect(put: "/resolve").to route_to("integration/provider#resolve")
  end
end
