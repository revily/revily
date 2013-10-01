require 'spec_helper'

describe Revily::Twilio do
  # pause_events!

  describe '.call' do
    let(:contact) { create(:phone_contact) }

    it 'creates a Twilio call' do
      VCR.use_cassette('twilio.call.create') do
        expect { Revily::Twilio.call(contact.address) }.not_to raise_error
      end
    end

    it 'fails with an invalid number' do
      VCR.use_cassette('twilio.call.create.invalid_number') do
        expect { Revily::Twilio.call("+1555121") }.to raise_error(Twilio::APIError)
      end
    end
  end

  describe '.message' do
    let(:contact) { create(:sms_contact) }
    let(:message) { "foo bar is down!" }

    it 'creates a Twilio SMS' do
      VCR.use_cassette('twilio.sms.create') do
        expect { Revily::Twilio.message("+15175551212", message) }.not_to raise_error
      end
    end

    it 'fails with an invalid message' do
      VCR.use_cassette('twilio.sms.create.invalid_message') do
        expect { Revily::Twilio.message("+15175551", nil) }.to raise_error(Twilio::APIError)
      end
    end

    it 'fails with an invalid number' do
      VCR.use_cassette('twilio.sms.create.invalid_number') do
        expect { Revily::Twilio.message("+15175551", message) }.to raise_error(Twilio::APIError)
      end
    end

  end
end
