require 'spec_helper'

describe IntegrationController do

  describe "GET 'trigger'" do
    it "returns http success" do
      get 'trigger'
      response.should be_success
    end
  end

  describe "GET 'acknowledge'" do
    it "returns http success" do
      get 'acknowledge'
      response.should be_success
    end
  end

  describe "GET 'resolve'" do
    it "returns http success" do
      get 'resolve'
      response.should be_success
    end
  end

end
