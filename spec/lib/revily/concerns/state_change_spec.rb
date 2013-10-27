require 'spec_helper'

describe Revily::Concerns::StateChange do
  let(:model) { stub_model(Service) }

  before do
    Revily::Event::Publisher::StateChange.stub(:publish)
    Event.stub(:create).and_return(true)
  end

  it "publishes state changes" do
    model.run_callbacks(:commit)
    expect(Revily::Event::Publisher::StateChange).to have_received(:publish)
  end
end