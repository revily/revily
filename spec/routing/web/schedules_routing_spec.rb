require "spec_helper"

describe Web::SchedulesController do
  it "routing" do
    expect(get: "/schedules").to route_to("web/schedules#index")
    expect(post: "/schedules").to route_to("web/schedules#create")
    expect(get: "/schedules/1").to route_to("web/schedules#show", params(:id))
    expect(put: "/schedules/1").to route_to("web/schedules#update", params(:id))
    expect(delete: "/schedules/1").to route_to("web/schedules#destroy", params(:id))
  end
end
