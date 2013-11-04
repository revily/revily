require 'spec_helper'

class MockHook <Revily::Event::Hook
  hook_name "mock"
  events [ "mock.create" ]
end

describe Revily::Event::Hook do
  describe 'initialize' do
    let(:hook) { MockHook.new }

    it 'valid with valid attribute methods' do
      expect { hook.name }.not_to raise_error()
      expect { hook.events }.not_to raise_error()
      expect(hook.name).to eq "mock"
      expect(hook.events).to eq [ 'mock.create' ]
    end
  end
end
