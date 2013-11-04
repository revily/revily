require "unit_helper"
require "timecop"

module Sidekiq
  module Worker
  end
end

describe Revily::Event::Job do
  before { Timecop.freeze Time.local(2012, 10, 26, 10, 49) }
  after { Timecop.return }

  describe ".schedule" do
    before { Revily::Sidekiq.stub(:schedule) }

    it "schedules a job to run in the future" do
      described_class.schedule(:default, 30.minutes, {}, {})

      expect(Revily::Sidekiq).to have_received(:schedule).with(
        described_class,
        :perform,
        { queue: :default, retries: 8, backtrace: true, at: 1351264740.0 },
        { payload: {}, params: {} }
      )
    end
  end

  describe ".run" do
    before { Revily::Sidekiq.stub(:run) }
    it "runs a job immediately" do
      described_class.run(:default, {}, {})

      expect(Revily::Sidekiq).to have_received(:run).with(
        described_class,
        :perform,
        { queue: :default, retries: 8, backtrace: true},
        { payload: {}, params: {} }
      )
    end
  end

  describe "#run" do
    let(:job) { described_class.new }
    context "valid" do
      before { job.stub(valid?: true, process: true) }

      it "performs a valid job" do
        job.run

        expect(job).to have_received(:process)
      end
    end

    context "invalid" do
      before { job.stub(valid?: false, process: true) }

      it "does not perform an invalid job" do
        job_result = job.run

        expect(job_result).to be_false
        expect(job).not_to have_received(:process)
      end
    end
  end
end
