require 'spec_helper'

describe Revily::Event::Hook do
  describe 'initialize' do
    context 'invalid' do
      let(:klass) do
        Class.new(Revily::Event::Hook) do
        end
      end
      let(:hook) { klass.new }
      it 'enforces required attributes' do
        expect { hook.name }.to raise_error()
        expect { hook.events }.to raise_error()
      end
    end

    context 'valid' do
      let(:klass) do
        Class.new(Revily::Event::Hook) do
          def name; 'test_hook'; end
          def events; [ 'foo.bar' ]; end
        end
      end
      let(:hook) { klass.new }

      it 'valid with valid attribute methods' do
        expect { hook.name }.not_to raise_error()
        expect { hook.events }.not_to raise_error()
        expect(hook.name).to eq "test_hook"
        expect(hook.events).to eq [ 'foo.bar' ]
      end
    end
  end
end
