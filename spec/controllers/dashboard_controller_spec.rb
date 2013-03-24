require 'spec_helper'

describe DashboardController do

  describe "GET 'index'" do
    before { get :index }

    it { should respond_with(:success) }
    it { should render_template(:dashboard) }
  end

end
