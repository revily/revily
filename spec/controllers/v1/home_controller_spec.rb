require 'spec_helper'

describe V1::HomeController do

  describe "GET 'index'" do
    before { get :index }

    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

end
