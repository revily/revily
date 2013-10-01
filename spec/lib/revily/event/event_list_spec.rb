require 'spec_helper'

describe Revily::Event::EventList do
  describe '.new' do
    let(:patterns) { %w[ user.* ] }
    let(:list) { Revily::Event::EventList.new(patterns) }
    let(:events) { list.events }
    let(:expected) { %w[ user.created user.deleted user.updated ] }

    it 'creates a list of events from a series of patterns' do
      expect(events).to eq(expected)
    end

    it 'defaults to all events' do
      expect(Revily::Event::EventList.new.events).to eq Revily::Event.all
    end

    it 'lists single events' do
      list.patterns = %w[ incident.triggered ]
      expect(events).to eq(%w[ incident.triggered ])
    end

    it 'lists all events' do
      list.patterns = %w[ * ]
      expect(events).to eq(Revily::Event.events)
    end

    it 'strips duplicate events' do
      list.patterns = %w[ incident.triggered incident.triggered ]
      expect(events).to match_array ['incident.triggered']
      expect(events).not_to match_array ['incident.triggered', 'incident.triggered']
    end

    it 'lists single namespace' do
      list.patterns = %w[ incident.* ]
      expect(events).to include('incident.triggered')
      expect(events).to include('incident.acknowledged')
      expect(events).not_to include('service.created')
      expect(events).not_to include('policy.updated')
    end

    it 'strips nonexistent events' do
      list.patterns = %w[ incident.triggered bogus.event ]
      expect(events).not_to include('bogus.event')
      expect(events).to include('incident.triggered')
    end

    it 'lists multiple namespaces' do
      list.patterns = %w[ incident.* service.* ]
      expect(events).to include('incident.triggered')
      expect(events).to include('incident.acknowledged')
      expect(events).to include('service.created')
      expect(events).to include('service.updated')
      expect(events).not_to include('policy.updated')
    end

    it 'lists mix of specific and namespace events' do
      list.patterns = %w[ incident.* service.created ]
      expect(events).to include('incident.triggered')
      expect(events).to include('incident.acknowledged')
      expect(events).to include('service.created')
      expect(events).not_to include('service.updated')
      expect(events).not_to include('policy.updated')
    end

  end
end
