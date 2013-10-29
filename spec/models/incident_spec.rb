require 'spec_helper'

describe Incident do
  pause_events!

  context 'associations' do
    it { should belong_to(:service) }
    it { should belong_to(:account) }
  end

  context 'validations' do
  end

  context 'attributes' do
    let(:account) { create(:account) }
    let(:service) { create(:service, :with_policy, account: account) }

    it { should serialize(:details) }
    it { should have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      incident = create(:incident, service: service)
      incident.to_param.should == incident.uuid
    end
  end

  context 'scopes' do
  end

  context 'states' do
    let(:service) { create(:service, :with_policy) }

    describe 'initial state' do
      it { build(:incident, service: service).should be_pending }
    end

    describe 'trigger' do
      let(:incident) { build(:incident, service: service) }

      before { incident.save }

      it 'cannot transition to :triggered' do
        incident.trigger

        incident.should have(1).error
      end

      it 'can transition to :acknowledged' do
        incident.acknowledge

        incident.should be_acknowledged
        incident.acknowledged_at.should_not be_nil
        incident.resolved_at.should be_nil
      end

      it 'can transition to :resolved' do
        incident.resolve

        incident.should be_resolved
        incident.should have(0).errors
        incident.resolved_at.should_not be_nil
        incident.acknowledged_at.should_not be_nil
      end
    end

    describe 'escalate' do
      let(:incident) { create(:incident, service: service) }

      it 'can transition from :triggered' do
        incident.trigger
        incident.escalate

        incident.should be_triggered
        incident.should have(0).errors
      end

      it 'can transition from :acknowledged' do
        incident.acknowledge
        incident.escalate

        incident.should be_triggered
        incident.should have(0).errors
      end

      it 'cannot transition from :resolved' do
        incident.resolve
        incident.escalate

        incident.should_not be_triggered
        incident.should be_resolved
        incident.should have(1).error
      end

    end

    describe 'acknowledge' do
      let(:incident) { create(:incident, service: service) }

      before { incident.acknowledge }

      it 'can transition to :acknowledged' do
        incident.acknowledge

        expect(incident).to be_acknowledged
        expect(incident).to have(0).error
      end

      it 'can transition to :triggered' do
        incident.trigger

        incident.should be_triggered
        incident.should have(0).errors
      end

      it 'can transition to :resolved' do
        incident.resolve

        incident.should be_resolved
        incident.should have(0).errors
      end
    end

    describe 'resolve' do
      let(:incident) { create(:incident, service: service) }

      before { incident.resolve }

      it 'cannot transition to :triggered' do
        incident.resolve
        incident.trigger

        incident.should have(1).error
        incident.should be_resolved
      end

      it 'cannot transition to :acknowledged' do
        incident.resolve
        incident.acknowledge

        incident.should have(1).error
        incident.should be_resolved
      end
    end

  end
end
