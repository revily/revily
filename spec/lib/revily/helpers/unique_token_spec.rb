require "unit_helper"
require "models/user"

module Revily::Helpers
  describe UniqueToken do

    describe ".generate_token" do
      it "defaults to a 64-character urlsafe_base64 token" do
        allow(SecureRandom).to receive(:urlsafe_base64) { "dummy" }
        token = UniqueToken.generate_token
        expect(SecureRandom).to have_received(:urlsafe_base64).with(64)
      end

      it "generates a hex token" do
        token = UniqueToken.generate_token(type: :hex)
        expect(token.length).to eq 64
        expect(token).to match(/\b[a-f0-9]{64}\b/)
      end

      it "generates a custom length hex token" do
        token = UniqueToken.generate_token(type: :hex, length: 32)
        expect(token.length).to eq 32
        expect(token).to match(/\b[a-f0-9]{32}\b/)
      end

      it "generates a base64 token" do
        token = UniqueToken.generate_token
        expect(token.length).to eq 64
        expect(token).to match(/\b[a-zA-Z0-9]{64}\b/)
      end

      it "generates a custom length base64 token" do
        token = UniqueToken.generate_token(length: 8)
        expect(token.length).to eq 8
        expect(token).to match(/\b[a-zA-Z0-9]{8}\b/)
      end
    end

    describe ".generate_token_for" do
      let(:attribute) { :uuid }
      let(:klass) { class_double("User") }
      let(:object) { instance_double("User") }

      before do
        allow(klass).to receive(:is_a?).with(Class).and_return(true)
        allow(klass).to receive(:find_by).and_return(false)
        allow(object).to receive(:is_a?).with(Class).and_return(false)
        allow(object).to receive(:class).and_return(klass)
      end

      it "generates a unique token for a class" do
        token = UniqueToken.generate_token_for(klass, attribute, type: :hex)

        expect(klass).to have_received(:find_by).with(attribute => token)
      end

      it "generates a unique token for an object" do
        token = UniqueToken.generate_token_for(object, attribute, type: :hex)

        expect(object).to have_received(:class)
        expect(object.class).to have_received(:find_by).with(attribute => token)
      end
    end

  end
end
