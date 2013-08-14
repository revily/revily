require 'spec_helper'

describe V1::VoiceController do
  pause_events!
  
  describe 'POST /voice' do
    let(:account) { build_stubbed(:account) }
    let(:user) { build_stubbed(:user, account: account) }
    let(:incident) { build_stubbed(:incident, state: 'triggered', account: account, current_user: user) }

    let(:call) { ttt_call('/voice', Revily::Twilio.number, "+15175551212") }
    it do
      # ap incident
      # ap call
    end
  end

  describe 'POST /voice/receive' do

  end
end
