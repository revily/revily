require "unit_helper"

class Event
end

describe Revily::Event::Publisher::StateChange do
  let(:object) { double("Incident")}
  let(:account) { double("Account") }
  let(:source) { object }
  let(:actor) { double("User") }

  before do
    Revily::Event.stub(:actor).and_return(actor)
    object.stub(
      trigger: true,
      account: account,
      event_action: "acknowledge",
      transition_from: "triggered",
      transition_to: "acknowledged"
    )
    Event.stub(:create).and_return(true)
  end

  it "creates an event" do
    publisher = Revily::Event::Publisher::StateChange.new(object)
    publisher.publish

    expect(publisher.account).to eq(account)
    expect(publisher.action).to eq(object.event_action)
    expect(publisher.source).to eq(source)
    expect(publisher.actor).to eq(actor)
    expect(publisher.changeset).to eq({ state: [ object.transition_from, object.transition_to ] })
    expect(Event).to have_received(:create)
  end
end
