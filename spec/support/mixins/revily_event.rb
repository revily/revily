module EventMacros

  def pause_events!
    around(:each) do |example|
      Revily::Event.pause!
      example.run
      Revily::Event.unpause!
    end
  end

  def stub_events
    let(:all_events) { %w[
      incident.acknowledge
      incident.create
      incident.delete
      incident.escalate
      incident.resolve
      incident.trigger
      incident.update
      policy.create
      policy.delete
      policy.update
      policy_rule.create
      policy_rule.delete
      policy_rule.update
      schedule.create
      schedule.delete
      schedule.update
      schedule_layer.create
      schedule_layer.delete
      schedule_layer.update
      service.create
      service.delete
      service.disable
      service.enable
      service.update
      user.create
      user.delete
      user.update
    ] }
    before(:each) do
      allow(Revily::Event).to receive(:all).and_return(all_events)
      allow(Revily::Event).to receive(:events).and_return(all_events)
    end
  end

end

RSpec.configure do |config|
  config.extend EventMacros
end
