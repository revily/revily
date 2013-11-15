require "spec_helper"

describe V1::ScheduleLayersController do
  it "routing" do
    expect(get: "/api/schedules/1/schedule_layers").to route_to("v1/schedule_layers#index", json_params(:schedule_id))
    expect(get: "/api/schedule_layers/1").to route_to("v1/schedule_layers#show", json_params(:id))
    expect(post: "/api/schedules/1/schedule_layers").to route_to("v1/schedule_layers#create", json_params(:schedule_id))
    expect(put: "/api/schedule_layers/1").to route_to("v1/schedule_layers#update", json_params(:id))
    expect(delete: "/api/schedule_layers/1").to route_to("v1/schedule_layers#destroy", json_params(:id))
  end
end
