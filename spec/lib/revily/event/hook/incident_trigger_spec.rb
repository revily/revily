require "unit_helper"
require "revily/event/hook/incident_trigger"

class Revily::Event::Hook
  describe IncidentTrigger do

    describe "initialize" do
      let(:hook) { described_class.new }

      it "initializes with correct attributes" do
        expect(hook.name).to eq "incident_trigger"
        expect(hook.events).to eq [ "incident.trigger", "incident.escalate" ]
        expect(hook.config).to eq({})
      end
    end
  end
end
