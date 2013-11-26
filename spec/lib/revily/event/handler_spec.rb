require "unit_helper"
# require "revily/event"
require "revily/event/handler"

# class MockHandler < Revily::Event::Handler
#   events []
#   def handle
#     run Revily::Event::Job::Null
#   end
# end

module Revily::Event
  describe Handler do
    stub_events

    class MockHandler < Revily::Event::Handler
      # events []
      def handle
        run Revily::Event::Job::Null
      end
    end
  end

  describe ".events" do
    let(:handler) { MockHandler }
    let(:event_list) { double("Revily::Event::EventList") }
    let(:job) { double("Revily::Event::Job::Null") }

    before do
      handler.events = []
    end

    it "defaults to empty array" do
      expect(handler.events).to eq []
    end

    it "using setter" do
      handler.events = %w[ incident.trigger ]
      expect(handler.events).to match_array %w[ incident.trigger ]
    end

    it "with args" do
      puts EventList.new("incident.trigger", "incident.acknowledge").events.inspect
      handler.events %w[ incident.trigger incident.acknowledge ]
      expect(handler.events).to match_array %w[ incident.trigger incident.acknowledge ]
    end

    it "calling multiple times" do
      handler.events "incident.trigger"
      handler.events "incident.acknowledge"
      handler.events "incident.resolve"
      expect(handler.events).to eq(%w[ incident.trigger incident.acknowledge incident.resolve ])
    end

    it "removes duplicate events" do
      handler.events "incident.trigger"
      handler.events "incident.trigger"
      expect(handler.events).to eq(%w[ incident.trigger ])
    end

    it "removes unknown events" do
      handler.events "bogus.event"
      handler.events "fake.event"
      expect(handler.events).to eq(%w[])
    end
  end

  describe ".supports?" do
    let(:handler) { MockHandler }
    let(:event_list) { double("Revily::Event::EventList") }
    let(:job) { double("Revily::Event::Job::Null") }

    before do
      handler.events = []
    end

    it "supports supported event" do
      handler.events "incident.trigger", "incident.resolve"
      expect(handler).to support_event("incident.trigger")
    end

    it "does not support unsupported event" do
      handler.events "incident.trigger", "incident.resolve"
      expect(handler).to_not support_event("service.create")
    end

    context "wildcards" do
      it "supports all (*)" do
        handler.events %w[ * ]
        expect(handler).to support_event("incident.trigger")
        expect(handler).to support_event("service.create")
        expect(handler).to support_event("policy.update")
        expect(handler).to support_event("incident.*")
        expect(handler).to support_event("service.*")
        expect(handler).to support_event("*")
        expect(handler).to_not support_event("bogus.event")
      end

      it "supports single namespace" do
        handler.events %w[ incident.* ]
        expect(handler).to support_event("incident.*")
        expect(handler).to support_event("incident.trigger")
        expect(handler).to support_event("incident.acknowledge")
        expect(handler).to_not support_event("service.create")
        expect(handler).to_not support_event("policy.update")
      end

      it "does not support nonexistent events" do
        handler.events "incident.*"
        expect(handler).to_not support_event("incident.foobar")
      end

      it "supports multiple namespaces" do
        handler.events %w[ incident.* service.* ]
        expect(handler).to support_event("incident.*")
        expect(handler).to support_event("incident.trigger")
        expect(handler).to support_event("service.*")
        expect(handler).to support_event("service.create")
        expect(handler).to_not support_event("policy.update")
      end

      it "supports mix of specific and namespace events" do
        handler.events %w[ incident.* service.create ]
        expect(handler).to support_event("incident.*")
        expect(handler).to support_event("incident.trigger")
        expect(handler).to support_event("service.create")
        expect(handler).to_not support_event("service.update")
        expect(handler).to_not support_event("policy.update")
      end
    end

  end

  describe ".notify" do
    let(:event) { "incident.trigger" }
    let(:source) { double("Incident") }
    let(:config) { { foo: "bar", baz: "quz" } }
    let(:options) { { event: event, source: source, config: config } }
    let(:handler) { MockHandler.new(options) }
    let(:job) { double("Revily::Event::Job::Null") }

    before do
      allow(job).to receive(:run)
    end

    context "handle? is true", :pending do
      before do
        allow(handler).to receive(:handle?).and_return(true)
      end

      it "handles the job" do
        expect(job).to have_received(:run)
      end
    end

    context "handle? is false" do
      before do
        handler.stub(:handle? => false)
      end

      it "does not handle the job" do
        expect(job).to_not have_received(:run)
      end
    end
  end
end
