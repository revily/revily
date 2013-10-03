require 'spec_helper'

describe Revily::Event::Hook::IncidentTrigger do

  describe 'initialize' do
    let(:hook) { Revily::Event::Hook::IncidentTrigger.new }

    it 'initializes with correct attributes' do
      expect(hook.name).to eq 'incident_trigger'
      expect(hook.events).to eq [ 'incident.trigger', 'incident.escalate' ]
      expect(hook.config).to eq({})
    end
  end
end
