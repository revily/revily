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
      subscription.handler.events.should have(1).item
    end

    it 'should not notify when the event does not match' do
      subscription.notify('service.created', resource)
      subscription.handler.events.should have(0).items
    end
  end


  describe '#new' do
    context 'initialize' do
      let(:hook) { create(:hook) }
      let(:subscription) { Reveille::Event::Subscription.new(hook) }
      subject { subscription }

      its(:name) { should eq 'test' }
      its(:events) { should be_an Array }
      its(:config) {should be_a Hash }
    end

    context 'missing event handler' do
      let(:hook) { build_stubbed(:hook, name: 'invalid_handler_name') }
      let(:subscription) { Reveille::Event::Subscription.new(hook) }

      it 'raises no exception' do
        -> { subscription.handler }.should_not raise_error
      end
    end
  end

  describe '#matches?' do
    let(:event) { 'incident.triggered' }
    let(:hook) { build_stubbed(:hook, name: 'test', events: %w[ incident.triggered incident.acknowledged ]) }
    let(:subscription) { Reveille::Event::Subscription.new(hook) }

    it 'matches an event pattern' do
      subscription.matches?(event).should be_true
    end

    context 'wildcards' do
      context 'specific model' do
        let(:hook) { build_stubbed(:hook, name: 'test', events: %w[ incident.*]) }
        let(:subscription) { Reveille::Event::Subscription.new(hook) }

        it 'matches all events' do
          subscription.matches?('incident.triggered').should be_true
          subscription.matches?('incident.acknowledged').should be_true
          subscription.matches?('incident.resolved').should be_true
          subscription.matches?('service.created').should_not be_true
        end
      end

      context 'all models' do
        let(:hook) { create(:hook, name: 'test', events: %w[ .* ]) }
        let(:subscription) { Reveille::Event::Subscription.new(hook) }

        it 'all events' do
          subscription.matches?('incident.triggered').should be_true
          subscription.matches?('service.created').should be_true
          subscription.matches?('policy.updated').should be_true
          subscription.matches?('schedule.deleted').should be_true
        end
      end
    end


    it 'does not match a missing event pattern' do
      subscription.matches?('incident.resolved').should be_false
    end
  end


end
