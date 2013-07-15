require 'spec_helper'

describe Reveille::Event do

  describe '.handlers' do
  end

  describe '.jobs' do
  end

  describe '#dispatch' do
    let(:account) { build_stubbed(:account) }
    let(:hook) { build_stubbed(:hook, account: account) }
    let(:resource) { build_stubbed(:incident) }
    before do
      resource.stub(account: account)
      
    end

    it do

      puts resource.inspect
      puts hook.inspect
      puts resource.account.inspect
    end

  end
end
