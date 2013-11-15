require "spec_helper"

describe Web::UsersController do
  it "routing" do
    expect(get: "/users").to route_to("web/users#index")
    expect(post: "/users").to route_to("web/users#create")
    expect(get: "/users/1").to route_to("web/users#show", params(:id))
    expect(put: "/users/1").to route_to("web/users#update", params(:id))
    expect(delete: "/users/1").to route_to("web/users#destroy", params(:id))
  end
end
