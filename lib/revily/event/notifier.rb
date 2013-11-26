module Revily::Event
  class Notifier
    include Revily::Model
    
    autoload :Email,               "revily/event/notifier/sms"
    autoload :Phone,               "revily/event/notifier/sms"
    autoload :Sms,                 "revily/event/notifier/sms"

    attribute :contact, type: Object
    attribute :incidents, type: Object, default: []

    class << self
      def notify(contact, incidents=[])
        new(contact: contact, incidents: incidents).notify
      end
    end

    def notify
      logger.warn "override Contact#notify in a subclass"
    end


    protected

    def address
      contact.address
    end

  end
end
