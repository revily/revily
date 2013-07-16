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
end
