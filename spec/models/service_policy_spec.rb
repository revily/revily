require 'spec_helper'

describe ServicePolicy do
  pause_events!

  context 'associations' do
    it { should belong_to(:service) }
    it { should belong_to(:policy) }
  end

  it 'uses uuid for #to_param' do
    obj = create(subject.class)
    expect(obj.to_param).to eq obj.uuid
  end
end
