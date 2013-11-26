require "spec_helper"

describe Integration::SmsController do
  it "routing" do
    expect(post: "/sms").to route_to("integration/sms#index")
    expect(post: "/sms/callback").to route_to("integration/sms#callback")
    expect(post: "/sms/fallback").to route_to("integration/sms#fallback")
  end
end
