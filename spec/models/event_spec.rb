require 'spec_helper'

describe Event do

  context 'validations' do
    it { should belong_to(:account) }
    it { should belong_to(:source) }
    it { should belong_to(:actor) }
  end

  describe 'recent' do
    let!(:events) { create_list(:event, 3) }

    pending do
      it 'orders events descending by id' do
        expect(Event.recent.map(&:id)).to eq events.map(&:id).reverse
      end
    end
  end

  describe '#publish' do
    let(:account) { mock_model("Account") }
    let(:actor) { mock_model("User") }
    let(:source) { mock_model("Incident") }
    let(:subscription) { double("Subscription").as_null_object }

    let(:event) { build(:event, source: source, actor: actor, action: 'triggered', account: account) }

    before do
      allow(Revily::Event).to receive(:actor) { actor }
      allow(event).to receive(:subscriptions) { [subscription ] }
    end

    it 'publishes events' do
      event.save

      expect(subscription).to have_received(:notify).at_least(:once)
    end

    context 'not paused' do
      before { Revily::Event.stub(paused?: false) }

      it 'sends event notifications' do
        event.save
        
        expect(subscription).to have_received(:notify).at_least(:once)
        expect(event.publish).to_not be_false
      end
    end

    context 'paused' do
      before { Revily::Event.stub(paused?: true) }

      it 'returns without sending notifications' do
        event.save

        expect(subscription).not_to have_received(:notify)
        expect(event.publish).to be_false
      end
    end

  end
end
