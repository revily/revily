require 'spec_helper'

describe Reveille::Event::Handler::Log do
  let(:account) { create(:account) }
  let(:service) { create(:service, account: account) }

  it 'logs events to the Rails logger' do
    Rails.logger.should_receive(:debug).
      with("account=#{account.id} event=incident:triggered").
      at_least(:once)
    incident = create(:incident, service: service)
  end
end
