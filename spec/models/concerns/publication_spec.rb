require "spec_helper"

describe Publication do

  describe ".publish" do
    let(:model) { stub_model(Service) }

    before do
      allow(Revily::Event::Publisher).to receive(:publish)
      allow(Event).to receive(:create).and_return(true)
    end

    it "publishes record changes" do
      model.run_callbacks(:commit)
      expect(Revily::Event::Publisher).to have_received(:publish)
    end
  end

end
