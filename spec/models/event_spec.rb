require 'spec_helper'

describe Event do
  
  context 'validations' do
    it { should belong_to(:account) }
    it { should belong_to(:source) }
  end
  let!(:events) { create_list(:event, 3) }

  describe 'recent' do
    
    it 'orders events descending by id' do
      Event.recent.map(&:id).should == events.map(&:id).reverse
    end

  end
end
