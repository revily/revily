require 'spec_helper'

describe Event do
  
  let!(:events) { create_list(:event, 3) }

  describe 'recent' do
    
    it 'orders events descending by id' do
      Event.recent.map(&:id).should == events.map(&:id).reverse
    end

  end
end
