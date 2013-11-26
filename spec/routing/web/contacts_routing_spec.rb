require "spec_helper"

describe Web::ContactsController do
  it "routing" do
    expect(post: "/users/1/contacts").to route_to("web/contacts#create", params(:user_id))
    expect(put: "/users/1/contacts/1").to route_to("web/contacts#update", params(:id, :user_id))
    expect(delete: "/users/1/contacts/1").to route_to("web/contacts#destroy", params(:id, :user_id))
  end
end
