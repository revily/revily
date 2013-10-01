module Revily
  module Logger

    def log(data, &blk)
      Scrolls.log(data, &blk)
    end

    def log_context(data, &blk)
      Scrolls.context(data, &blk)
    end

    def log_exception(data, e)
      Scrolls.log_exception(data, e)
    end

    def setup_global_context
      {
        :app => 'revily',
        :env => Rails.env,
      }
    end

    def setup_syslog
      Scrolls.facility = (ENV['SCROLLS_FACILITY'] || 'local7')
      Scrolls.stream = 'syslog'
    end

    def setup
      setup_global_context
      Scrolls.add_timestamp = true
    end
  end
end
