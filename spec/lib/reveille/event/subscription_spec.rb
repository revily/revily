require 'spec_helper'

describe Revily::Event::Subscription do
  describe 'triggering a notification' do
    # class MockHandler < Revily::Event::Handler
    # events 'incident.created'
    # end
    let(:account) { build_stubbed(:account) }
    let(:source)  { build_stubbed(:incident, account: account) }
    let(:hook) { build_stubbed(:hook, :test, :with_config, :for_incidents, account: account) }
    let(:options) { { name: hook.name, config: hook.config, source: source, event: 'incident.triggered' } }
    let(:subscription) { Revily::Event::Subscription.new(options) }

    before do
      subscription.handler.event_list.clear
    end

    pending 'brittle tests are brittle' do
      it 'should notify when the event matches' do
        subscription.handler.stub(:supports? => true)
        subscription.handler.should_receive(:notify)
        subscription.notify
      end

      it 'should not notify when the event does not match' do
        subscription.handler.stub(:supports? => false)
        subscription.handler.should_not_receive(:notify)
        subscription.should_receive(:notify).and_return(false)
        subscription.notify
      end
    end
  end


  describe '#new' do
    context 'initialize' do
      let(:account) { build_stubbed(:account) }
      let(:source)  { build_stubbed(:incident, account: account) }
      let(:hook) { build_stubbed(:hook, :test, :with_config, :for_incidents, account: account) }
      let(:options) { { name: hook.name, config: hook.config, source: source, event: 'incident.triggered' } }
      let(:subscription) { Revily::Event::Subscription.new(options) }

      it 'with the correct attributes' do
        expect(subscription.name).to eq 'test'
        expect(subscription.event).to be_a String
        expect(subscription.event).to eq 'incident.triggered'
        expect(subscription.config).to be_a Hash
        expect(subscription.config).to eq({ 'foo' => 'bar', 'baz' => 'qux' })
      end
    end

    context 'missing event handler' do
      let(:hook) { build_stubbed(:hook, name: 'invalid_handler_name') }
      let(:subscription) { Revily::Event::Subscription.new(hook.attributes) }

      it 'raises no exception' do
        expect { subscription.handler }.to_not raise_error
      end
    end
  end
end
