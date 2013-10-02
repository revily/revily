require 'spec_helper'

describe Revily::Event::EventList do
  describe '.new' do
    let(:patterns) { %w[ user.* ] }
    let(:list) { Revily::Event::EventList.new(patterns) }
    let(:events) { list.events }
    let(:expected) { %w[ user.create user.delete user.update ] }

    it 'creates a list of events from a series of patterns' do
      expect(events).to eq(expected)
    end

    it 'defaults to all events' do
      expect(Revily::Event::EventList.new.events).to eq Revily::Event.all
    end

    it 'lists single events' do
      list.patterns = %w[ incident.trigger ]
      expect(events).to eq(%w[ incident.trigger ])
    end

    it 'lists all events' do
      list.patterns = %w[ * ]
      expect(events).to eq(Revily::Event.events)
    end

    it 'strips duplicate events' do
      list.patterns = %w[ incident.trigger incident.trigger ]
      expect(events).to match_array ['incident.trigger']
      expect(events).not_to match_array ['incident.trigger', 'incident.trigger']
    end

    it 'lists single namespace' do
      list.patterns = %w[ incident.* ]
      expect(events).to include('incident.trigger')
      expect(events).to include('incident.acknowledge')
      expect(events).not_to include('service.create')
      expect(events).not_to include('policy.update')
    end

    it 'strips nonexistent events' do
      list.patterns = %w[ incident.trigger bogus.event ]
      expect(events).not_to include('bogus.event')
      expect(events).to include('incident.trigger')
    end

    it 'lists multiple namespaces' do
      list.patterns = %w[ incident.* service.* ]
      expect(events).to include('incident.trigger')
      expect(events).to include('incident.acknowledge')
      expect(events).to include('service.create')
      expect(events).to include('service.update')
      expect(events).not_to include('policy.update')
    end

    it 'lists mix of specific and namespace events' do
      list.patterns = %w[ incident.* service.create ]
      expect(events).to include('incident.trigger')
      expect(events).to include('incident.acknowledge')
      expect(events).to include('service.create')
      expect(events).not_to include('service.update')
      expect(events).not_to include('policy.update')
    end

  end
end
