require 'spec_helper'

describe Revily::Concerns::Eventable do
  class MockModel < ActiveRecord::Base
    self.abstract_class = true
    include Eventable
  end

  describe '.events' do
    it 'returns a list of default events' do
      expect(MockModel.events).to eq([:create, :update, :delete])
    end
  end

  describe 'event callbacks' do
    let(:service) { build(:service) }
    it 'after create' do
      pending "after_create callbacks are broken"
      expect { service.save && service.reload }.to change { service.events.count }.from(0).to(1)
    end

    it 'after update' do
      pending "after_update callbacks currently disabled"
      service.save
      service.name = Forgery(:name).company_name

      expect { service.save && service.reload }.to change { service.events.count }.from(1).to(2)
    end

  end

  describe 'callbacks' do
    pending do
      let(:policy) { build_stubbed(:policy) }

      before do
        policy.stub(:save).and_return(true)
      end

      it 'receives callbacks' do
        policy.should_receive(:dispatch)
        policy.save
      end
    end
  end
end
