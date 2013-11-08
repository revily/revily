require "spec_helper"

describe Publication do
  let(:model) { stub_model(Service) }

  before do
    Revily::Event::Publisher.stub(:publish)
    Event.stub(:create).and_return(true)
  end

  it "publishes record changes" do
    model.run_callbacks(:commit)
    expect(Revily::Event::Publisher).to have_received(:publish)
  end
end
