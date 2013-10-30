
require 'spec_helper'

describe Revily::Event::Handler::Log do
  let(:account) { create(:account) }
  let(:service) { create(:service, account: account) }

  it 'logs events to the Rails logger' do
    pending
    #expect(Rails.logger).to have_received(:debug).
    #   with("account=#{account.id} event=incident:triggered").
    #   at_least(:once)
    # incident = create(:incident, service: service)
  end
end
