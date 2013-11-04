require "unit_helper"

class Event
end

describe Revily::Event::Publisher::RecordChange do
  let(:object) { double("Service")}
  let(:account) { double("Account") }
  let(:source) { object }
  let(:actor) { double("User") }

  before do
    Revily::Event.stub(:actor).and_return(actor)
    allow(object).to receive(:trigger) { true }
    allow(object).to receive(:account) { account }
    allow(object).to receive(:event_action) { "create" }
    allow(object).to receive(:changes) { { "name" => [ "foo", "bar" ] } }
    allow(Event).to receive(:create).and_return(true)
  end

  it "creates an event" do
    publisher = Revily::Event::Publisher::RecordChange.new(object)
    publisher.publish

    expect(publisher.account).to eq(account)
    expect(publisher.action).to eq(object.event_action)
    expect(publisher.source).to eq(source)
    expect(publisher.actor).to eq(actor)
    expect(publisher.changeset.changes).to eq(object.changes)
    expect(Event).to have_received(:create)
  end
end
