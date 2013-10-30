require 'spec_helper'

describe Incident do
  pause_events!

  context 'associations' do
    it { expect(subject).to belong_to(:service) }
    it { expect(subject).to belong_to(:account) }
  end

  context 'validations' do
  end

  context 'attributes' do
    let(:account) { create(:account) }
    let(:service) { create(:service, :with_policy, account: account) }

    it { expect(subject).to serialize(:details) }
    it { expect(subject).to have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      incident = create(:incident, service: service)
      expect(incident.to_param).to eq incident.uuid
    end
  end

  context 'scopes' do
  end

  context 'states' do
    let(:service) { create(:service, :with_policy) }

    describe 'initial state' do
      let(:incident) { build(:incident, service: service) }
      it { expect(incident).to be_pending }
    end

    describe 'trigger' do
      let(:incident) { build(:incident, service: service) }

      before { incident.save }

      it 'cannot transition to :triggered' do
        incident.trigger

        expect(incident).to have(1).error
      end

      it 'can transition to :acknowledged' do
        incident.acknowledge

        expect(incident).to be_acknowledged
        expect(incident.acknowledged_at).to_not be_nil
        expect(incident.resolved_at).to be_nil
      end

      it 'can transition to :resolved' do
        incident.resolve

        expect(incident).to be_resolved
        expect(incident).to have(0).errors
        expect(incident.resolved_at).to_not be_nil
        expect(incident.acknowledged_at).to_not be_nil
      end
    end

    describe 'escalate' do
      let(:incident) { create(:incident, service: service) }

      it 'can transition from :triggered' do
        incident.trigger
        incident.escalate

        expect(incident).to be_triggered
        expect(incident).to have(0).errors
      end

      it 'can transition from :acknowledged' do
        incident.acknowledge
        incident.escalate

        expect(incident).to be_triggered
        expect(incident).to have(0).errors
      end

      it 'cannot transition from :resolved' do
        incident.resolve
        incident.escalate

        expect(incident).to_not be_triggered
        expect(incident).to be_resolved
        expect(incident).to have(1).error
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

        expect(incident).to be_triggered
        expect(incident).to have(0).errors
      end

      it 'can transition to :resolved' do
        incident.resolve

        expect(incident).to be_resolved
        expect(incident).to have(0).errors
      end
    end

    describe 'resolve' do
      let(:incident) { create(:incident, service: service) }

      before { incident.resolve }

      it 'cannot transition to :triggered' do
        incident.resolve
        incident.trigger

        expect(incident).to have(1).error
        expect(incident).to be_resolved
      end

      it 'cannot transition to :acknowledged' do
        incident.resolve
        incident.acknowledge

        expect(incident).to have(1).error
        expect(incident).to be_resolved
      end
    end

  end
end
