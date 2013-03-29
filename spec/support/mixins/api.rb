module API
  module Service

    def sign_in_service
      let(:service) { create(:service, :with_escalation_policy) }
      let(:token) { service.authentication_token }

      before do
        header 'Authorization', %[Token token="#{token}"]
      end
    end

  end

  module User
    
    def sign_in_user
      let(:user) { create(:user) }
      let(:token) { user.authentication_token }

      before do
        header 'Authorization', %[Token token="#{token}"]
      end
    end

  end
end

RSpec.configure do |config|
  config.extend API::Service, api: :true
  config.extend API::User, api: true
end
