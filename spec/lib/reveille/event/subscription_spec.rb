require 'spec_helper'

describe Reveille::Event::Subscription do
  # class Reveille::Event::Handler::Test
  #   class << self
  #     attr_accessor :events
  #   end

  #   self.events = []

  #   def self.notify(*args)
  #     new(*args).notify
  #   end

  #   def initialize(*args)
  #     self.class.events << args
  #   end

  #   def notify
  #   end
  # end

  describe 'trigger a notification' do
    let(:resource) { build_stubbed(:incident) }
    let(:hook) { build_stubbed(:hook, :test, :for_incidents) }
    let(:subscription) { Reveille::Event::Subscription.new(hook) }

    before do
      subscription.handler.events.clear
    end

    it 'should notify when the event matches' do
      subscription.notify('incident.triggered', resource)
      expect(subscription.handler.events).to have(1).item
    end

    it 'should not notify when the event does not match' do
      subscription.notify('service.created', resource)
      expect(subscription.handler.events).to have(0).items
    end
  end


  describe '#new' do
    context 'initialize' do
      let(:hook) { build_stubbed(:hook, :test, :with_config, :for_incidents) }
      let(:subscription) { Reveille::Event::Subscription.new(hook) }
      subject { subscription }

      it 'initializes the correct attributes' do
        expect(subscription.name).to eq 'test'
        expect(subscription.events).to be_an Array
        expect(subscription.events).to eq %w[ incident.* ]
        expect(subscription.config).to be_a Hash
        expect(subscription.config).to eq({ 'foo' => 'bar', 'baz' => 'qux' })
      end
    end

    context 'missing event handler' do
      let(:hook) { build_stubbed(:hook, name: 'invalid_handler_name') }
      let(:subscription) { Reveille::Event::Subscription.new(hook) }

      it 'raises no exception' do
        expect { subscription.handler }.to_not raise_error
      end
    end
  end

  describe '#matches?' do
    let(:event) { 'incident.triggered' }
    let(:hook) { build_stubbed(:hook, name: 'test', events: %w[ incident.triggered incident.acknowledged ]) }
    let(:subscription) { Reveille::Event::Subscription.new(hook) }

    context 'exact' do
      it 'matches an event pattern' do
        expect(subscription.matches?(event)).to be_true
      end

      it 'does not match a missing event pattern' do
        expect(subscription.matches?('incident.resolved')).to be_false
      end
    end

    context 'wildcards' do
      context 'specific model' do
        let(:hook) { build_stubbed(:hook, name: 'test', events: %w[ incident.*]) }
        let(:subscription) { Reveille::Event::Subscription.new(hook) }

        it 'matches all events' do
          expect(subscription.matches?('incident.triggered')).to be_true
          expect(subscription.matches?('incident.acknowledged')).to be_true
          expect(subscription.matches?('incident.resolved')).to be_true
          expect(subscription.matches?('service.created')).to_not be_true
          expect(subscription.matches?('user.deleted')).to_not be_true
        end
      end

      context 'all models' do
        let(:hook) { build_stubbed(:hook, name: 'test', events: %w[ * ]) }
        let(:subscription) { Reveille::Event::Subscription.new(hook) }

        it 'all events' do
          expect(subscription.matches?('incident.triggered')).to be_true
          expect(subscription.matches?('service.created')).to be_true
          expect(subscription.matches?('policy.updated')).to be_true
          expect(subscription.matches?('schedule.deleted')).to be_true
          expect(subscription.matches?('incident.*')).to be_true
          expect(subscription.matches?('schedule.*')).to be_true
          expect(subscription.matches?('policy.*')).to be_true
        end
      end
    end
  end


end
