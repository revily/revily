if Rails.env.production?
  require "metriks/reporter/logger"

  reporter = Metriks::Reporter::Logger.new
  reporter.start
end
