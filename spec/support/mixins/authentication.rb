require "active_support/concern"

module Support
  module Authentication
    extend ActiveSupport::Concern

    module ClassMethods


      def stub_authentication_for(scope)
        let(:current_account) { build_stubbed(:account, uuid: "asdf") }
        let(:current_user) { build_stubbed(:user, uuid: "asdf", account: current_account) }
        let(:current_service) { build_stubbed(:service, account: current_account) }
        let(:current_actor) { self.send("current_#{scope}") }
        let(:warden) { double("Warden", authenticate!: current_actor, user: current_actor) }

        before(:each) do
          request.env["warden"] = warden
          allow(warden).to receive(:authenticate!).with(scope: scope).and_return(current_actor)
          allow(warden).to receive(:user).with(scope: scope).and_return(current_actor)
          allow(controller).to receive(:current_actor).and_return(current_actor)
          allow(controller).to receive(:current_account).and_return(current_account)
        end
      end

      def stub_no_authentication_for(scope=nil)
        before(:each) do
          request.env["warden"] = nil
          allow(controller).to receive(:current_actor).and_return(nil)
          allow(controller).to receive(:current_account).and_return(nil)
        end
      end

      # def sign_in_user
      #   sign_in(:user)
      # end

      # def sign_in_service
      #   sign_in(:service)
      # end

      def sign_in(scope)
        stub_authentication_for(scope)
      end

      def sign_out(scope=nil)
        stub_no_authentication_for(scope)
      end
    end
  end
end

RSpec.configure do |config|
  config.include Support::Authentication, type: :controller
end
