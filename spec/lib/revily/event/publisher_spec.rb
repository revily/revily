require "unit_helper"

describe Revily::Event::Publisher do
  let(:object) { double(:service) }
  let(:account) { double(:account) }
  let(:source) { object }
  let(:actor) { double(:user) }
  let(:changeset) { double(:changeset) }
  let(:event_class) { class_double("Event") }
  let(:changes) { { "name" => [ "foo", "bar" ] } }

  before do
    allow(Revily::Event).to receive(:actor).and_return(actor)
    allow(object).to receive(:trigger) { true }
    allow(object).to receive(:account) { account }
    allow(object).to receive(:event_action) { "create" }
    allow(object).to receive(:changes).and_return(changes)
    allow(Event).to receive(:create).and_return(true)
    allow(Revily::Event::Changeset).to receive(:new).and_return(changeset)
    allow(changeset).to receive(:changes).and_return(changes)
  end

  it "creates an event" do
    publisher = Revily::Event::Publisher.new(object)
    publisher.publish

    expect(publisher.account).to eq(account)
    expect(publisher.action).to eq(object.event_action)
    expect(publisher.source).to eq(source)
    expect(publisher.actor).to eq(actor)
    expect(publisher.changeset.changes).to eq(object.changes)
    expect(Event).to have_received(:create)
  end
end
