require "spec_helper"

describe Web::ScheduleLayersController do
  it "routing" do
    expect(post: "/schedules/1/schedule_layers").to route_to("web/schedule_layers#create", params(:schedule_id))
    expect(put: "/schedules/1/schedule_layers/1").to route_to("web/schedule_layers#update", params(:id, :schedule_id))
    expect(delete: "/schedules/1/schedule_layers/1").to route_to("web/schedule_layers#destroy", params(:id, :schedule_id))
  end
end
