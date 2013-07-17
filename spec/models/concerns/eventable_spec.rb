describe Eventable do
  let(:klass) do
    Class.new(ActiveRecord::Base) do
      self.abstract_class = true
      include Eventable
    end
  end

  describe '.events' do
    it 'returns a list of default events' do
      expect(klass.events).to eq([:created, :updated, :deleted])
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
