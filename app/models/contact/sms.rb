class Contact::Sms < Contact
  def label
    read_attribute(:label) || 'SMS'
  end

  def notify(action, incidents)
    @incidents = incidents
    body = self.send("#{action}_message")

    Revily::Twilio.message(address, body)
  end
  
  private

  def message
    if incidents.length > 1
      "#{incidents.count} ALERTS"
    else
      "ALERT [#{service.name}] #{incidents.first.message}".truncate(128)
    end 
  end

  def controls
    "4:ACK 6:RESOLVE 8:ESCALATE"
  end

  def acknowledge_message
    "All assigned incidents acknowledged."
  end

  def resolve_message
    "All assigned incidents resolved."
  end

  def unknown_message
    "Unknown response. #{controls}"
  end

  def failure_message
    "The incidents assigned to you could not be #{state}d."
  end

  def trigger_message
    "#{message} - #{controls}"
  end

end
