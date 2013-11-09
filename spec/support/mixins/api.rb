module API
  module Service

    def warden
      last_request.env["warden"]
    end

    def sign_in_service
      let!(:account) { create(:account) }
      let!(:user) { create(:user, account: account) }
      let!(:contact) { create(:phone_contact, user: user, account: account) }
      let!(:policy) { create(:policy, account: account) }
      let!(:policy_rule) { create(:policy_rule, policy: policy, assignment: user, position: 1, account: account) }
      let!(:service) { create(:service, policy: policy, account: account) }
      let!(:token) { service.authentication_token }

      before do
        header "Authorization", "Token #{token}"
      end

      # after do
      #   warden = last_request.env["warden"]
      #   [ :user, :service ].map {|s| warden.user(scope: s, run_callbacks: false) }
      #   warden.raw_session.inspect
      #   warden.logout
      #   warden.clear_strategies_cache!
      # end
    end

  end

  module User

    def sign_in_oauth_user
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
        header "Authorization", "Bearer #{token}"
      end
    end

    def sign_in_user
      let!(:account) { create(:account) }
      let(:user) { create(:user, account: account) }
      let(:token) { user.authentication_token }

      before do
        header "Authorization", "Token #{token}"
      end
    end

  end
end

RSpec.configure do |config|
  config.extend API::Service, api: true
  config.extend API::User, api: true
end
