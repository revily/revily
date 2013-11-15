require "spec_helper"

describe Web::EventsController do
  sign_in :user
  
  describe "index" do
    include_examples "index_success"
  end

  describe "show" do
    include_examples "show_success"
  end

end
