require "unit_helper"
require "revily/event/subscription"

module Revily::Event
  describe Subscription do
    describe "notifying a handler" do
      let(:account) { double("Account") }
      let(:source)  { double("Incident") }
      let(:hook) { double("Hook") }
      let(:options) { { name: hook.name, config: hook.config, source: source, event: "incident.trigger" } }
      let(:subscription) { described_class.new(options) }
      let(:handler) { double("Revily::Event::Handler::Null") }

      before do
        allow(hook).to receive(:name).and_return("null")
        allow(hook).to receive(:config).and_return({ "foo" => "bar", "baz" => "qux" })
        allow(subscription).to receive(:handler).and_return(handler)
        allow(handler).to receive(:notify)
      end

      it "should notify when the event matches" do
        allow(handler).to receive(:supports?).and_return(true)
        subscription.notify

        expect(handler).to have_received(:notify)
      end

      it "should not notify when the event does not match" do
        allow(handler).to receive(:supports?).and_return(false)
        subscription.notify

        expect(handler).not_to have_received(:notify)
      end
    end


    describe "#new" do
      let(:account) { double("Account") }
      let(:source)  { double("Incident") }
      let(:hook) { double("Hook") }
      let(:options) { { name: hook.name, config: hook.config, source: source, event: "incident.trigger" } }
      let(:subscription) { described_class.new(options) }
      let(:handler) { double("Revily::Event::Handler::Null") }

      before do
        allow(hook).to receive(:name).and_return("null")
        allow(hook).to receive(:config).and_return({ "foo" => "bar", "baz" => "qux" })
        allow(subscription).to receive(:handler) { handler }
      end

      context "initialize" do
        it "with the correct attributes" do
          expect(subscription.name).to eq "null"
          expect(subscription.event).to be_a String
          expect(subscription.event).to eq "incident.trigger"
          expect(subscription.config).to be_a Hash
          expect(subscription.config).to eq({ "foo" => "bar", "baz" => "qux" })
        end
      end

      context "missing event handler" do
        let(:hook) { double("Hook") }
        let(:subscription) { described_class.new(options) }

        before do
          allow(hook).to receive(:name).and_return("invalid_handler_name")
        end

        it "raises no exception" do
          expect { subscription.handler }.to_not raise_error
        end
      end
    end
  end
end
