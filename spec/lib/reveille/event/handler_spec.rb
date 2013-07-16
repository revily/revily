require 'spec_helper'

describe Reveille::Event::Handler do
  class MockHandler < Reveille::Event::Handler; end

  # let(:handler) { Class.new(Reveille::Event::Handler) }
  let(:handler) { MockHandler }
  before { MockHandler.supports_events = []}

  describe '.supports_events' do
    it 'defaults to empty array' do
      handler.should_receive(:supports_events).and_return([])
      handler.supports_events
    end

    it 'with no args' do
      handler.supports_events = %w[ incident.triggered ]
      handler.should_receive(:supports_events).and_return(['foo.event'])
      handler.supports_events
    end

    it 'with args' do
      handler.supports_events %w[ incident.triggered incident.acknowledged ]
      expect(handler.supports_events).to eq(%w[ incident.triggered incident.acknowledged ])
    end

    it 'calling multiple times' do
      handler.supports_events 'incident.triggered'
      handler.supports_events 'incident.acknowledged'
      handler.supports_events 'incident.resolved'
      expect(handler.supports_events).to eq(%w[ incident.triggered incident.acknowledged incident.resolved ])
    end

    it 'removes duplicate events' do
      handler.supports_events 'incident.triggered'
      handler.supports_events 'incident.triggered'
      expect(handler.supports_events).to eq(%w[ incident.triggered ])
    end

    it 'removes unknown events' do
      handler.supports_events 'bogus.event'
      handler.supports_events 'fake.event'
      expect(handler.supports_events).to eq(%w[])
    end
  end

  describe '.supports?' do
    # let(:events) {  }
    # let(:handler) do
    #   Class.new(Reveille::Event::Handler) do
    #     supports_events 'incident.trigger'
    #   end
    # end
    it 'matches supported event' do
      handler.supports_events 'incident.triggered', 'incident.resolved'
      expect(handler).to support('incident.triggered')
    end

    it 'does not match unsupported event' do
      handler.supports_events 'incident.triggered', 'incident.resolved'
      expect(handler).not_to support('service.created')
    end

    context 'wildcards' do
      it 'matches all (*)' do
        handler.supports_events %w[ * ]
        expect(handler).to support('incident.triggered')
        expect(handler).to support('service.created')
        expect(handler).to support('policy.updated')
        expect(handler).to support('incident.*')
        expect(handler).to support('service.*')
        expect(handler).to support('*')
        expect(handler).not_to support('bogus.event')
      end

      it 'matches single namespace' do
        handler.supports_events %w[ incident.* ]
        expect(handler).to support('incident.*')
        expect(handler).to support('incident.triggered')
        expect(handler).to support('incident.acknowledged')
        expect(handler).not_to support('service.created')
        expect(handler).not_to support('policy.updated')
      end

      it 'does not match nonexistent events' do
        handler.supports_events 'incident.*'
        expect(handler).not_to support('incident.foobar')
      end

      it 'matches multiple namespaces' do
        handler.supports_events %w[ incident.* service.* ]
        expect(handler).to support('incident.*')
        expect(handler).to support('incident.triggered')
        expect(handler).to support('service.*')
        expect(handler).to support('service.created')
        expect(handler).not_to support('policy.updated')
      end

      it 'matches mix of specific and namespace events' do
        handler.supports_events %w[ incident.* service.created ]
        expect(handler).to support('incident.*')
        expect(handler).to support('incident.triggered')
        expect(handler).to support('service.created')
        expect(handler).not_to support('service.updated')
        expect(handler).not_to support('policy.updated')
      end
    end

  end

end
