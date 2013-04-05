require 'spec_helper'

describe Event do
  describe 'associations' do
    it { should belong_to(:service) }
    it { should have_many(:alerts) }
  end

  describe 'validations' do
    it { should validate_presence_of(:message) }
    # it { should validate_uniqueness_of(:message).scoped_to([:service_id]).on(:save) }
    # it { should validate_uniqueness_of(:key).scoped_to([:service_id]) }
  end

  describe 'attributes' do
    let(:account) { create(:account) }
    let(:service) { create(:service, :with_escalation_policy, account: account) }
    
    it { should serialize(:details) }
    it { should have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      event = create(:event, service: service)
      event.to_param.should == event.uuid
    end
  end

  context 'scopes' do
  end

  describe 'states' do
    # it { should have_states :triggered, :acknowledged, :resolved }
    # it { should handle_event :trigger, when: :pending }
    # it { should handle_event :trigger, when: :acknowledged }

    # it { should handle_event :escalate, when: :triggered }
    # it { should handle_event :escalate, when: :acknowledged }

    # it { should handle_event :acknowledge, when: :triggered }
    # it { should handle_event :resolve, when: :triggered }
    # it { should handle_event :resolve, when: :acknowledged }

    let(:service) { create(:service, :with_escalation_policy) }
    describe 'initial state' do
      it { build(:event, service: service).should be_pending }
    end

    describe 'trigger' do
      let(:event) { build(:event, service: service) }

      before { event.save }

      it { expect(Event::DispatchNotifications).to have_enqueued_jobs(1) }
      it { expect(Event::Escalate).to have_enqueued_jobs(1) }

      it 'cannot transition to :triggered' do
        event.trigger

        event.should have(1).error
      end

      it 'can transition to :acknowledged' do
        event.acknowledge

        event.should be_acknowledged
        event.acknowledged_at.should_not be_nil
        event.resolved_at.should be_nil
      end

      it 'can transition to :resolved' do
        event.resolve

        event.should be_resolved
        event.should have(0).errors
        event.resolved_at.should_not be_nil
        event.acknowledged_at.should_not be_nil
      end
    end

    describe 'escalate' do
      let(:event) { create(:event, service: service) }

      it 'can transition from :triggered' do
        event.trigger
        event.escalate

        event.should be_triggered
        event.should have(0).errors
      end

      it 'can transition from :acknowledged' do
        event.acknowledge
        event.escalate

        event.should be_triggered
        event.should have(0).errors
        event.current_escalation_rule.should == service.escalation_policy.escalation_rules.second
      end

      it 'cannot transition from :resolved' do
        event.resolve
        event.escalate

        event.should_not be_triggered
        event.should be_resolved
        event.should have(1).error
      end

    end

    describe 'acknowledge' do
      let(:event) { create(:event, service: service) }

      before { event.acknowledge }

      it 'cannot transition to :acknowledged' do
        event.acknowledge

        event.should have(1).error
      end

      it 'can transition to :triggered' do
        event.trigger

        event.should be_triggered
        event.should have(0).errors
      end

      it 'can transition to :resolved' do
        event.resolve

        event.should be_resolved
        event.should have(0).errors
      end
    end

    describe 'resolve' do
      let(:event) { create(:event, service: service) }

      before { event.resolve }

      it 'cannot transition to :triggered' do
        event.resolve
        event.trigger

        event.should have(1).error
        event.should be_resolved
      end

      it 'cannot transition to :acknowledged' do
        event.resolve
        event.acknowledge

        event.should have(1).error
        event.should be_resolved
      end
    end

  end
end
