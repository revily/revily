require 'spec_helper'

describe Reveille::Event do

  describe '.handlers' do
  end

  describe '.jobs' do
  end

  describe '.pause!' do
    before { Reveille::Event.pause! }
    it { should be_paused }
  end

  describe '.unpause!' do
    before { Reveille::Event.unpause! }
    it { should_not be_paused }
  end
end
