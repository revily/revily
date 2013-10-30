# expect(MyWorker).to have_queued_job(2)
# expect(Collector).to have_queued_job_at(Time.new(2012,1,23,14,00),2)

RSpec::Matchers.define :have_queued_job do |*expected|
  match do |actual|
    actual.jobs.any? { |job| Array(expected) == job["args"] }
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would have a job queued with #{expected}"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual} would not a have a job queued with #{expected}"
  end

  description do
    "have a job queued with #{expected}"
  end
end

RSpec::Matchers.define :have_queued_job_at do |at,*expected|
  match do |actual|
    actual.jobs.any? { |job| job["args"] == Array(expected) && job["at"].to_i == at.to_i }
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would have a job queued with #{expected} at time #{at}"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual} would not a have a job queued with #{expected} at time #{at}"
  end

  description do
    "have a job queued with #{expected} at time #{at}"
  end
end
