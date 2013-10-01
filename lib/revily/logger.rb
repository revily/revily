module Revily
  module Logger

    def self.log(data, &blk)
      Scrolls.log(data, &blk)
    end

    def self.log_context(data, &blk)
      Scrolls.context(data, &blk)
    end

    def self.log_exception(data, e)
      Scrolls.log_exception(data, e)
    end

    def self.add_global_context(data)
      Scrolls.add_global_context(data)
    end


    def self.setup_global_context
      {
        :app => 'revily',
        :env => Rails.env,
      }
    end

    def self.setup_syslog
      Scrolls.facility = (ENV['SCROLLS_FACILITY'] || 'local7')
      Scrolls.stream = 'syslog'

      setup
    end

    def self.setup
      setup_global_context
      Scrolls.add_timestamp = true
    end
  end
end
