require 'spec_helper'

describe ServicesController do

  let(:user) { create(:user) }
  let(:service) { create(:service, user: user) }
  
  before do
    sign_in user
  end

  describe "GET 'index'" do
    before do
      get :index
    end

    it { should respond_with(:success) }
    it { should render_template(:index) }
    it { should assign_to(:services) }
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit'
      response.should be_success
    end
  end

end
  