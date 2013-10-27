require 'spec_helper'

describe Revily::Concerns::RecordChange do
  let(:model) { stub_model(Service) }

  before do
    Revily::Event::Publisher::RecordChange.stub(:publish)
    Event.stub(:create).and_return(true)
  end

  it "publishes record changes" do
    model.run_callbacks(:commit)
    expect(Revily::Event::Publisher::RecordChange).to have_received(:publish)
  end
end