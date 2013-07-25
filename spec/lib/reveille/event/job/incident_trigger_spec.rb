require 'spec_helper'

describe Reveille::Event::Job::IncidentTrigger do
  let(:account) { build_stubbed(:account) }
  let(:user) { build_stubbed(:user, account: account) }
  
  let(:payload) {}
  it 'sends notifications to the contacts of the assigned user' do

  end
end
