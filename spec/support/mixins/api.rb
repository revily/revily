module API
  module Service

    def sign_in_service
      let!(:account) { create(:account) }
      let!(:service) { create(:service, :with_policy, account: account) }
      let!(:token) { service.authentication_token }

      before do
        header 'Authorization', %[token #{token}]
      end
    end

  end

  module User
    
    def sign_in_user
      let!(:oauth) { create(:application) }
      let!(:account) { create(:account) }
      let!(:user) { create(:user, account: account) }
      let!(:client) do
        OAuth2::Client.new(oauth.uid, oauth.secret) do |b|
          b.request :url_encoded
          b.adapter :rack, Rails.application
        end
      end
      let!(:token) { client.password.get_token(user.email, user.password).token }

      before do
        header 'Authorization', %[Bearer #{token}]
      end
    end

  end
end

RSpec.configure do |config|
  config.extend API::Service, api: :true
  config.extend API::User, api: true
end
