require 'spec_helper'

describe TwilioController do

  describe "GET 'sms'" do
    it "returns http success" do
      get 'sms'
      response.should be_success
    end
  end

  describe "GET 'phone'" do
    it "returns http success" do
      get 'phone'
      response.should be_success
    end
  end

end
