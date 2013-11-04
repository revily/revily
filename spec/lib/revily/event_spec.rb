require "unit_helper"

describe Revily::Event do

  describe ".handlers" do
  end

  describe ".jobs" do
  end

  describe ".pause!" do
    before { Revily::Event.pause! }
    it { should be_paused }
  end

  describe ".unpause!" do
    before { Revily::Event.unpause! }
    it { should_not be_paused }
  end
end
