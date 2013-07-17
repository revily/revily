require 'spec_helper'

describe Reveille::Event::Subscription do
  describe 'triggering a notification' do
    # class MockHandler < Reveille::Event::Handler
    # events 'incident.created'
    # end

    let(:resource) { build_stubbed(:incident) }
    let(:hook) { build_stubbed(:hook, :test, :for_incidents) }
    let(:subscription) { Reveille::Event::Subscription.new(hook) }

    before do
      subscription.handler.event_list.clear
    end

    it 'should notify when the event matches' do
      subscription.handler.stub(:supports?).and_return(true)
      subscription.handler.should_receive(:notify)
      subscription.notify('incident.triggered', resource)
    end

    it 'should not notify when the event does not match' do
      subscription.handler.stub(:supports?).and_return(false)
      subscription.handler.should_not_receive(:notify)
      subscription.notify('service.created', resource)
    end
  end


  describe '#new' do
    context 'initialize' do
      let(:hook) { build_stubbed(:hook, :test, :with_config, :for_incidents) }
      let(:subscription) { Reveille::Event::Subscription.new(hook) }
      subject { subscription }

      it 'with the correct attributes' do
        expect(subscription.name).to eq 'test'
        expect(subscription.events).to be_an Array
        expect(subscription.events).to include('incident.triggered', 'incident.acknowledged')
        expect(subscription.config).to be_a Hash
        expect(subscription.config).to eq({ 'foo' => 'bar', 'baz' => 'qux' })
      end
    end

    context 'missing event handler' do
      let(:hook) { build_stubbed(:hook, name: 'invalid_handler_name') }
      let(:subscription) { Reveille::Event::Subscription.new(hook) }

      it 'raises no exception' do
        expect { subscription.handler }.to_not raise_error
      end
    end
  end
end
