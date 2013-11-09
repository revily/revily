require "unit_helper"

module Revily::Event
  describe Publisher do
    include Support::TestDoubles

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
      stub_class_double("Event", create: true)
      stub_class_double("Revily::Event::SubscriptionList", new: subscription_list)
      stub_class_double("Revily::Event::Changeset", new: changeset)
      stub_class_double("Revily::Event", hooks: [hook], actor: object.actor, paused?: false)
    end

    describe ".publish" do

      it "publishes an event" do
        Publisher.publish(object)

        expect(::Event).to have_received(:create)
        expect(SubscriptionList).to have_received(:new)
      end

      it "does not publish if events are paused" do
        allow(Revily::Event).to receive(:paused?).and_return(true)

        Publisher.publish(object)

        expect(::Event).to_not have_received(:create)
        expect(Revily::Event::SubscriptionList).to_not have_received(:new).with(anything)
      end

      it "does not publish if changeset is empty" do
        allow(changeset.changes).to receive(:empty?).and_return(true)

        Publisher.publish(object)

        expect(::Event).to_not have_received(:create)
        expect(Revily::Event::SubscriptionList).to_not have_received(:new).with(anything)
      end
    end

    describe "#publish" do
      let(:publisher) { Publisher.new(object) }

      it "publishes an event" do
        publisher.publish

        expect(::Event).to have_received(:create)
        expect(SubscriptionList).to have_received(:new)
      end
    end

    describe "#hooks" do
      let(:publisher) { Publisher.new(object) }
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
