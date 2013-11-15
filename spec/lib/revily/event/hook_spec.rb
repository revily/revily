require "unit_helper"
require "revily/event/hook"

module Revily::Event
  describe Hook do
    MockHook = Class.new(Revily::Event::Hook)

    before do
      MockHook.hook_name "mock"
      MockHook.handler "mock"
      MockHook.events [ "mock.create" ]
    end

    describe ".handler" do
    end

    describe ".hook_name" do

    end

    describe ".events" do

    end

    describe "initialize" do
      let(:hook) { MockHook.new }

      it "valid with valid attribute methods" do
        expect { hook.name }.not_to raise_error()
        expect { hook.events }.not_to raise_error()
        expect(hook.name).to eq "mock"
        expect(hook.events).to eq [ "mock.create" ]
      end
    end

  end
end
