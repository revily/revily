require "unit_helper"
require "revily/event/publisher"

module Revily::Event
  describe Publisher do
    let(:changeset) { double("Changeset", changes: { name: [ "foo", "bar" ] }) }
    let(:hook) { double("Hook", handler: "double", config: {}) }
    let(:subscription) { double("Subscription", handle?: true, notify: true) }
    let(:subscription_list) { double("SubscriptionList", subscriptions: [ subscription ])}

    let(:object) do
      double("Service",
             account: double("Account", hooks: []),
             source: double("Service", class: "service"),
             actor: double("User"),
             event_action: "create",
             changeset: changeset)
    end

    before do
      stub_const("Event", class_double("Event", create: true).as_stubbed_const)
      allow(Event).to receive(:create).and_return(true)
      allow(Revily::Event).to receive(:actor).and_return(object.actor)
      allow(Revily::Event).to receive(:hooks).and_return([ hook ])
      allow(Revily::Event).to receive(:paused?).and_return(false)
      allow(SubscriptionList).to receive(:new).and_return(subscription_list)
      allow(Changeset).to receive(:new).and_return(changeset)
      # stub_class_double("Revily::Event::SubscriptionList", new: subscription_list)
      # stub_class_double("Event", create: true)
      # stub_const("Event", class_double("Event", create: true)).as_stubbed_const
      # stub_class_double("Revily::Event::Changeset", new: changeset)
      # stub_class_double("Revily::Event", hooks: [hook], actor: object.actor, paused?: false)
    end

    describe ".publish" do

      it "publishes an event" do
        described_class.publish(object)

        expect(::Event).to have_received(:create)
        expect(SubscriptionList).to have_received(:new)
      end

      it "does not publish if events are paused" do
        allow(Revily::Event).to receive(:paused?).and_return(true)

        described_class.publish(object)

        expect(::Event).to_not have_received(:create)
        expect(SubscriptionList).to_not have_received(:new).with(anything)
      end

      it "does not publish if changeset is empty" do
        allow(changeset.changes).to receive(:empty?).and_return(true)

        described_class.publish(object)

        expect(::Event).to_not have_received(:create)
        expect(SubscriptionList).to_not have_received(:new).with(anything)
      end
    end

    describe "#publish" do
      let(:publisher) { described_class.new(object) }

      it "publishes an event" do
        publisher.publish

        expect(::Event).to have_received(:create)
        expect(SubscriptionList).to have_received(:new)
      end
    end

    describe "#hooks" do
      let(:publisher) { described_class.new(object) }
      let(:account_hook) { double("Hook", handler: "account", config: {}) }
      let(:global_hook) { double("Hook", handler: "global", config: {}) }

      it "lists both account-level and global hooks" do
        allow(object.account).to receive(:hooks).and_return([ account_hook ])
        allow(Revily::Event).to receive(:hooks).and_return([ global_hook ])

        expect(publisher.hooks).to include(account_hook)
        expect(publisher.hooks).to include(global_hook)
      end
    end

  end
end
