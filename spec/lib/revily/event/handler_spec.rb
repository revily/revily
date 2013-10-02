require 'spec_helper'

describe Revily::Event::Handler do
  class MockHandler < Revily::Event::Handler; end
  let(:handler) { MockHandler }
  before { MockHandler.events = []}

  describe '.events' do
    let(:events) { handler.events }
    it 'defaults to empty array' do
      handler.should_receive(:events).and_return([])
      handler.events
    end

    it 'with no args' do
      handler.events = %w[ incident.trigger ]
      handler.should_receive(:events).and_return(['foo.event'])
      handler.events
    end

    it 'with args' do
      handler.events %w[ incident.trigger incident.acknowledge ]
      expect(handler.events).to match_array %w[ incident.trigger incident.acknowledge ]
    end

    it 'calling multiple times' do
      handler.events 'incident.trigger'
      handler.events 'incident.acknowledge'
      handler.events 'incident.resolve'
      expect(events).to eq(%w[ incident.trigger incident.acknowledge incident.resolve ])
    end

    it 'removes duplicate events' do
      handler.events 'incident.trigger'
      handler.events 'incident.trigger'
      expect(events).to eq(%w[ incident.trigger ])
    end

    it 'removes unknown events' do
      handler.events 'bogus.event'
      handler.events 'fake.event'
      expect(events).to eq(%w[])
    end
  end

  describe '.supports?' do
    # let(:events) {  }
    # let(:handler) do
    #   Class.new(Revily::Event::Handler) do
    #     events 'incident.trigger'
    #   end
    # end
    it 'matches supported event' do
      handler.events 'incident.trigger', 'incident.resolve'
      expect(handler).to match_event('incident.trigger')
    end

    it 'does not match unsupported event' do
      handler.events 'incident.trigger', 'incident.resolve'
      expect(handler).not_to match_event('service.create')
    end

    context 'wildcards' do
      it 'matches all (*)' do
        handler.events %w[ * ]
        expect(handler).to match_event('incident.trigger')
        expect(handler).to match_event('service.create')
        expect(handler).to match_event('policy.update')
        expect(handler).to match_event('incident.*')
        expect(handler).to match_event('service.*')
        expect(handler).to match_event('*')
        expect(handler).not_to match_event('bogus.event')
      end

      it 'matches single namespace' do
        handler.events %w[ incident.* ]
        expect(handler).to match_event('incident.*')
        expect(handler).to match_event('incident.trigger')
        expect(handler).to match_event('incident.acknowledge')
        expect(handler).not_to match_event('service.create')
        expect(handler).not_to match_event('policy.update')
      end

      it 'does not match nonexistent events' do
        handler.events 'incident.*'
        expect(handler).not_to match_event('incident.foobar')
      end

      it 'matches multiple namespaces' do
        handler.events %w[ incident.* service.* ]
        expect(handler).to match_event('incident.*')
        expect(handler).to match_event('incident.trigger')
        expect(handler).to match_event('service.*')
        expect(handler).to match_event('service.create')
        expect(handler).not_to match_event('policy.update')
      end

      it 'matches mix of specific and namespace events' do
        handler.events %w[ incident.* service.create ]
        expect(handler).to match_event('incident.*')
        expect(handler).to match_event('incident.trigger')
        expect(handler).to match_event('service.create')
        expect(handler).not_to match_event('service.update')
        expect(handler).not_to match_event('policy.update')
      end
    end

  end

  describe 'notify' do
    let(:event) { 'incident.trigger' }
    let(:source) { build_stubbed(:incident) }
    let(:config) { { foo: 'bar', baz: 'quz' } }
    let(:options) { { event: event, source: source, config: config } }
    let(:handler) { Revily::Event::Handler::Test.notify(options) }

    # context 'handle? is true' do
    #   before do
    #     handler.stub(:handle? => true)
    #   end

    #   it 'handles the job' do
    #     Revily::Event::Handler::Test.should_receive(:notify)
    #     puts 
    #   end
    # end

    # context 'handle? is false' do
    #   before do
    #     handler.stub(:handle? => false)
    #   end

    #   it 'does not handle the job' do
    #     handler.should_not_receive(:notify)
    #   end
    # end
  end
end
