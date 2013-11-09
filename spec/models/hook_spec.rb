require "spec_helper"

describe Hook do
  pause_events!

  let!(:account) { create(:account) }

  context "validations" do
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:handler) }
    it { expect(subject).to belong_to(:account) }

    describe "handler_exists?" do
      let(:hook) { build_stubbed(:hook, :for_incidents) }
      it "when handler exists" do
        hook.handler = "null"
        expect(hook).to be_valid
      end

      it "when no handler exists" do
        hook.name = "bogus"
        hook.handler = "bogus_handler"
        expect(hook).to_not be_valid
        expect(hook).to have(1).error_on(:name)
      end
    end

    describe "handler_supports_events?" do
      let(:hook) { build_stubbed(:hook, :for_incidents) }

      it "when handler supports all events" do
        expect(hook).to be_valid
      end

      it "when handler does not support all events" do
        class Revily::Event::Handler::Bogus < Revily::Event::Handler
          events "services.*"
        end
        hook.stub(:handler).and_return(Revily::Event::Handler::Bogus)
        hook.events = %w[ incidents ]
        hook.name = "bogus"
        expect(hook).to_not be_valid
        expect(hook).to have(1).error_on(:events)
      end

      it "when handler does not support any events" do
        hook.events = %w[ bogus.event fake.event ]
        expect(hook).to_not be_valid
        expect(hook).to have(1).error_on(:events)
        expect(hook.events).to be_empty
      end
    end
  end

  context "scopes" do
    describe ".active" do
      before do
        create(:hook, account: account)
        create(:hook, account: account, state: "disabled")
      end

      it "returns only active hooks" do
        expect(account.hooks).to have(2).items
        expect(account.hooks.enabled).to have(1).item
      end
    end
  end

  describe "#handler" do
    let(:hook) { build_stubbed(:hook) }

    it "when handler exists" do
      hook.handler = "null"
      expect(hook.handler).to eq "null"
      expect(hook.handler_class).to be Revily::Event::Handler::Null
    end

    it "when no handler exists" do
      hook.handler = "bogus_handler"
      expect(hook.handler_class).to be_nil
    end
  end
end
