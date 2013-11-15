require "spec_helper"

describe Integration::VoiceController do
  it "routing" do
    expect(post: "/voice").to route_to("integration/voice#index")
    expect(post: "/voice/callback").to route_to("integration/voice#callback")
    expect(post: "/voice/fallback").to route_to("integration/voice#fallback")
  end
end
