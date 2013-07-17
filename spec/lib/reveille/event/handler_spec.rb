require 'spec_helper'

describe Reveille::Event::Handler do
  class MockHandler < Reveille::Event::Handler; end

  # let(:handler) { Class.new(Reveille::Event::Handler) }
  let(:handler) { MockHandler }
  before { MockHandler.events = []}

  describe '.events' do
    let(:events) { handler.events }
    it 'defaults to empty array' do
      handler.should_receive(:events).and_return([])
      handler.events
    end

    it 'with no args' do
      handler.events = %w[ incident.triggered ]
      handler.should_receive(:events).and_return(['foo.event'])
      handler.events
    end

    it 'with args' do
      handler.events %w[ incident.triggered incident.acknowledged ]
      expect(handler.events).to match_array %w[ incident.triggered incident.acknowledged ]
    end

    it 'calling multiple times' do
      handler.events 'incident.triggered'
      handler.events 'incident.acknowledged'
      handler.events 'incident.resolved'
      expect(events).to eq(%w[ incident.triggered incident.acknowledged incident.resolved ])
    end

    it 'removes duplicate events' do
      handler.events 'incident.triggered'
      handler.events 'incident.triggered'
      expect(events).to eq(%w[ incident.triggered ])
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
    #   Class.new(Reveille::Event::Handler) do
    #     events 'incident.trigger'
    #   end
    # end
    it 'matches supported event' do
      handler.events 'incident.triggered', 'incident.resolved'
      expect(handler).to match_event('incident.triggered')
    end

    it 'does not match unsupported event' do
      handler.events 'incident.triggered', 'incident.resolved'
      expect(handler).not_to match_event('service.created')
    end

    context 'wildcards' do
      it 'matches all (*)' do
        handler.events %w[ * ]
        expect(handler).to match_event('incident.triggered')
        expect(handler).to match_event('service.created')
        expect(handler).to match_event('policy.updated')
        expect(handler).to match_event('incident.*')
        expect(handler).to match_event('service.*')
        expect(handler).to match_event('*')
        expect(handler).not_to match_event('bogus.event')
      end

      it 'matches single namespace' do
        handler.events %w[ incident.* ]
        expect(handler).to match_event('incident.*')
        expect(handler).to match_event('incident.triggered')
        expect(handler).to match_event('incident.acknowledged')
        expect(handler).not_to match_event('service.created')
        expect(handler).not_to match_event('policy.updated')
      end

      it 'does not match nonexistent events' do
        handler.events 'incident.*'
        expect(handler).not_to match_event('incident.foobar')
      end

      it 'matches multiple namespaces' do
        handler.events %w[ incident.* service.* ]
        expect(handler).to match_event('incident.*')
        expect(handler).to match_event('incident.triggered')
        expect(handler).to match_event('service.*')
        expect(handler).to match_event('service.created')
        expect(handler).not_to match_event('policy.updated')
      end

      it 'matches mix of specific and namespace events' do
        handler.events %w[ incident.* service.created ]
        expect(handler).to match_event('incident.*')
        expect(handler).to match_event('incident.triggered')
        expect(handler).to match_event('service.created')
        expect(handler).not_to match_event('service.updated')
        expect(handler).not_to match_event('policy.updated')
      end
    end

  end

end
