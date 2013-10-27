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
        Event.recent.each do |e|
          puts e.inspect
        end
        Event.recent.map(&:id).should == events.map(&:id).reverse
      end
    end
  end

  describe '#publish' do
    let(:account) { build_stubbed(:account) }
    let(:actor) { build_stubbed(:user, account: account) }
    let(:source) { build_stubbed(:incident, account: account) }
    let(:subscription) { build_stubbed(:subscription, name: 'test', source: source, actor: actor, event: 'incident.triggered') }

    let(:event) { build(:event, source: source, actor: actor, action: 'triggered', account: account) }

    before do
      Revily::Event.actor = actor
      event.stub(:subscriptions => [ subscription ])
    end

    it 'publishes events' do
      subscription.should_receive(:notify).at_least(:once)
      event.save
    end

    context 'not paused' do
      before { Revily::Event.stub(paused?: false) }

      it 'sends event notifications' do
        subscription.should_receive(:notify).at_least(:once)
        event.save
        expect(event.publish).to_not be_false
      end
    end

    context 'paused' do
      before { Revily::Event.stub(paused?: true) }

      it 'returns without sending notifications' do
        subscription.should_not_receive(:notify)
        event.save
        expect(event.publish).to be_false
      end
    end

  end
end
