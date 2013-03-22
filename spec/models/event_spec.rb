require 'spec_helper'

describe Event do
  context 'associations' do
    it { should belong_to(:service) }
    it { should have_many(:alerts) }
  end

  context 'validations' do
    it { should validate_presence_of(:message) }
    # it { should validate_uniqueness_of(:message).scoped_to([:service_id]).on(:save) }
    # it { should validate_uniqueness_of(:key).scoped_to([:service_id]) }
  end

  context 'attributes' do
    it { should serialize(:details) }
    it { should have_readonly_attribute(:uuid) }
  end

  context 'scopes' do
  end

  context 'states' do
    describe 'initial state' do
      it { create(:event).should be_triggered }
    end

    describe 'trigger' do
      let(:event) { create(:event) }

      it 'does not transition to :triggered' do
        event.trigger

        event.should have(1).error
      end

      it 'transitions to :acknowledged' do
        event.acknowledge

        event.should be_acknowledged
        event.acknowledged_at.should_not be_nil
        event.resolved_at.should be_nil
      end

      it 'transitions to :resolved' do
        event.resolve

        event.should be_resolved
        event.should have(0).errors
        event.resolved_at.should_not be_nil
        event.acknowledged_at.should_not be_nil
      end
    end

    describe 'acknowledge' do
      let(:event) { create(:event) }

      before { event.acknowledge }

      it 'does not transition to :acknowledged' do
        event.acknowledge

        event.should have(1).error
      end

      it 'transitions to :triggered' do
        event.trigger

        event.should be_triggered
        event.should have(0).errors
      end

      it 'transitions to :resolved' do
        event.resolve

        event.should be_resolved
        event.should have(0).errors
      end
    end

    describe 'resolve' do
      let(:event) { create(:event) }

      before { event.resolve }

      it 'does not transition to :triggered' do
        event.resolve
        event.trigger

        event.should have(1).error
        event.should be_resolved
      end

      it 'does not transition to :acknowledged' do
        event.resolve
        event.acknowledge

        event.should have(1).error
        event.should be_resolved
      end
    end

  end
end
