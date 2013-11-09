require "unit_helper"

module Revily::Helpers
  describe UniqueToken do
    describe ".generate" do

      it "defaults to a 64-character urlsafe_base64 token" do
        allow(SecureRandom).to receive(:urlsafe_base64) { "dummy" }
        token = UniqueToken.generate
        expect(SecureRandom).to have_received(:urlsafe_base64).with(64)
      end

      it "generates a hex token" do
        token = UniqueToken.generate(type: :hex)
        expect(token.length).to eq 64
        expect(token).to match(/\b[a-f0-9]{64}\b/)
      end

      it "generates a custom length hex token" do
        token = UniqueToken.generate(type: :hex, length: 32)
        expect(token.length).to eq 32
        expect(token).to match(/\b[a-f0-9]{32}\b/)
      end

      it "generates a base64 token" do
        token = UniqueToken.generate
        expect(token.length).to eq 64
        expect(token).to match(/\b[a-zA-Z0-9]{64}\b/)
      end

      it "generates a custom length base64 token" do
        token = UniqueToken.generate(length: 8)
        expect(token.length).to eq 8
        expect(token).to match(/\b[a-zA-Z0-9]{8}\b/)
      end

    end
  end
end
