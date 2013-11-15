require "spec_helper"

describe Web::HooksController do
  sign_in :user
  
  describe "index" do
    include_examples "index_success"
  end

  describe "show" do
    include_examples "show_success"
  end

  describe "new" do
    include_examples "new_success"
  end

  describe "create" do
    include_examples "create_success"
    include_examples "create_failure"
  end

  describe "edit" do
    include_examples "edit_success"
  end

  describe "update" do
    include_examples "update_success"
    include_examples "update_failure"
  end

  describe "destroy" do
    include_examples "destroy_success"
    include_examples "destroy_failure"
  end
end
