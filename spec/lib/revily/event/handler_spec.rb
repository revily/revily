require "unit_helper"

MockHandler = Class.new(Revily::Event::Handler)

describe Revily::Event::Handler do
  let(:handler) { MockHandler }
  let(:event_list) { double("Revily::Event::EventList") }

  before do
    allow(Revily::Event).to receive(:all) { %w[ 
      incident.trigger incident.acknowledge incident.resolve
      service.create service.update service.delete
      policy.create policy.update policy.delete
    ] }
    # allow(Revily::Event::EventList).to receive(:new) { event_list }
    # allow(event_list).to receive(:events).and_return([])# { %w[ foo.create foo.update foo.delete ] }
    MockHandler.events = []
  end

  describe ".events" do
    let(:events) { handler.events }
    it "defaults to empty array" do
      expect(handler.events).to eq []
    end

    it "with no args" do
      handler.events = %w[ incident.trigger ]
      expect(handler.events).to match_array %w[ incident.trigger ]
    end

    it "with args" do
      handler.events %w[ incident.trigger incident.acknowledge ]
      expect(handler.events).to match_array %w[ incident.trigger incident.acknowledge ]
    end

    it "calling multiple times" do
      handler.events "incident.trigger"
      handler.events "incident.acknowledge"
      handler.events "incident.resolve"
      expect(events).to eq(%w[ incident.trigger incident.acknowledge incident.resolve ])
    end

    it "removes duplicate events" do
      handler.events "incident.trigger"
      handler.events "incident.trigger"
      expect(events).to eq(%w[ incident.trigger ])
    end

    it "removes unknown events" do
      handler.events "bogus.event"
      handler.events "fake.event"
      expect(events).to eq(%w[])
    end
  end

  describe ".supports?" do
    it "matches supported event" do
      handler.events "incident.trigger", "incident.resolve"
      expect(handler).to match_event("incident.trigger")
    end

    it "does not match unsupported event" do
      handler.events "incident.trigger", "incident.resolve"
      expect(handler).not_to match_event("service.create")
    end

    context "wildcards" do
      it "matches all (*)" do
        handler.events %w[ * ]
        expect(handler).to match_event("incident.trigger")
        expect(handler).to match_event("service.create")
        expect(handler).to match_event("policy.update")
        expect(handler).to match_event("incident.*")
        expect(handler).to match_event("service.*")
        expect(handler).to match_event("*")
        expect(handler).not_to match_event("bogus.event")
      end

      it "matches single namespace" do
        handler.events %w[ incident.* ]
        expect(handler).to match_event("incident.*")
        expect(handler).to match_event("incident.trigger")
        expect(handler).to match_event("incident.acknowledge")
        expect(handler).not_to match_event("service.create")
        expect(handler).not_to match_event("policy.update")
      end

      it "does not match nonexistent events" do
        handler.events "incident.*"
        expect(handler).not_to match_event("incident.foobar")
      end

      it "matches multiple namespaces" do
        handler.events %w[ incident.* service.* ]
        expect(handler).to match_event("incident.*")
        expect(handler).to match_event("incident.trigger")
        expect(handler).to match_event("service.*")
        expect(handler).to match_event("service.create")
        expect(handler).not_to match_event("policy.update")
      end

      it "matches mix of specific and namespace events" do
        handler.events %w[ incident.* service.create ]
        expect(handler).to match_event("incident.*")
        expect(handler).to match_event("incident.trigger")
        expect(handler).to match_event("service.create")
        expect(handler).not_to match_event("service.update")
        expect(handler).not_to match_event("policy.update")
      end
    end

  end

  describe "notify" do
    let(:event) { "incident.trigger" }
    let(:source) { double(:incident) }
    let(:config) { { foo: "bar", baz: "quz" } }
    let(:options) { { event: event, source: source, config: config } }
    let(:handler) { Revily::Event::Handler::Null.notify(options) }

    pending do
      context "handle? is true" do
        before do
          handler.stub(:handle? => true)
        end

        it "handles the job" do
          expect(Revily::Event::Handler::Null).to have_received(:notify)
        end
      end

      context "handle? is false" do
        before do
          handler.stub(:handle? => false)
        end

        it "does not handle the job" do
          expect(handler).to_not_receive(:notify)
        end
      end
    end
  end
end
