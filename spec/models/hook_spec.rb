require 'spec_helper'

describe Hook do
  let!(:account) { create(:account) }

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should belong_to(:account) }

    describe 'handler_exists?' do
      let(:hook) { build_stubbed(:hook, :for_incidents) }
      it 'when handler exists' do
        hook.name = 'test'
        hook.should be_valid
      end

      it 'when no handler exists' do
        hook.name = 'bogus_handler'
        hook.should_not be_valid
        expect(hook).to have(1).error_on(:name)
      end
    end

    describe 'handler_supports_events?' do
      let(:hook) { build_stubbed(:hook, :for_incidents) }

      it 'when handler supports all events' do
        hook.should be_valid
      end

      it 'when handler does not support all events' do
        class Reveille::Event::Handler::Bogus < Reveille::Event::Handler
          events 'services.*'
        end
        hook.stub(:handler).and_return(Reveille::Event::Handler::Bogus)
        hook.events = %w[ incidents ]
        hook.name = 'bogus'
        hook.should_not be_valid
        hook.should have(1).error_on(:events)
      end

      it 'when handler does not support any events' do
        hook.events = %w[ bogus.event fake.event ]
        hook.should_not be_valid
        hook.should have(1).error_on(:events)
        hook.events.should be_empty
      end
    end
  end

  context 'scopes' do
    describe '.active' do
      before do
        create(:hook, account: account)
        create(:hook, account: account, state: 'disabled')
      end

      it 'returns only active hooks' do
        account.hooks.should have(2).items
        account.hooks.enabled.should have(1).item
      end
    end
  end

  describe '#handler' do
    let(:hook) { build_stubbed(:hook) }

    it 'when handler exists' do
      hook.name = 'test'
      hook.handler.should be Reveille::Event::Handler::Test
    end

    it 'when no handler exists' do
      hook.name = 'bogus_handler'
      hook.handler.should be_nil
    end
  end
end
