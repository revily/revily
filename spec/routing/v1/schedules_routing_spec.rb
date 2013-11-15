require "spec_helper"

describe V1::SchedulesController do
  it "routing" do
    expect(get: "/api/schedules").to route_to("v1/schedules#index", json_params)
    expect(get: "/api/schedules/1").to route_to("v1/schedules#show", json_params(:id))
    expect(post: "/api/schedules").to route_to("v1/schedules#create", json_params)
    expect(put: "/api/schedules/1").to route_to("v1/schedules#update", json_params(:id))
    expect(delete: "/api/schedules/1").to route_to("v1/schedules#destroy", json_params(:id))
  end
end
