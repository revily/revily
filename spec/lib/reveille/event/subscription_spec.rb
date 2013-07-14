require 'spec_helper'

describe Reveille::Event::Subscription do
  class Reveille::Event::Handler::TestHandler
    class << self
      attr_accessor :events
    end

    self.events = []

    EVENTS = /incident:triggered/

    def self.notify(*args)
      new(*args).notify
    end

    def initialize(*args)
      self.class.events << args
    end

    def notify
    end
  end

  describe 'trigger a notification' do
    let(:subscription) { Reveille::Event::Subscription.new(:test_handler) }

    before do
      subscription.subscriber.events.clear
    end

    it 'should notify when the event matches' do
      subscription.notify('incident:triggered')
      subscription.subscriber.events.should have(1).item
    end

    it 'should not notify when the event does not match' do
      subscription.notify('incident:acknowledged')
      subscription.subscriber.events.should have(0).items
    end
  end

  describe 'missing event handler' do
    let(:subscription) { Reveille::Event::Subscription.new(:missing_handler) }

    it 'raises no exception' do
      -> { subscription.subscriber }.should_not raise_error
    end
  end


end
