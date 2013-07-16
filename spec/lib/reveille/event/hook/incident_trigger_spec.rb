require 'spec_helper'

describe Reveille::Event::Hook::IncidentTrigger do

  describe 'initialize' do
    let(:hook) { Reveille::Event::Hook::IncidentTrigger.new }

    it 'initializes with correct attributes' do
      expect(hook.name).to eq 'incident_trigger'
      expect(hook.events).to eq [ 'incident.triggered' ]
      expect(hook.config).to eq({})
    end
  end
end
