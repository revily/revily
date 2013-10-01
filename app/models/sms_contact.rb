class SmsContact < Contact
  def label
    read_attribute(:label) || 'SMS'
  end
  
  def header
    "ALERT #{incident.uuid}: #{service.name.truncate(16)}"
  end

  def footer
    "4: ACK 6: RESOLVE 8: ESCALATE"
  end

  def triggered_message
    "#{header} - #{@incident.message} - #{footer}"
  end

  def acknowledged_message
    "All incidents assigned to you were acknowledged."
  end

  def resolved_message
    "All incidents assigned to you were resolved."
  end

  def unknown_message
    "Unknown response. #{footer}"
  end

  def failure_message
    "The incidents assigned to you could not be #{state}d."
  end

  def notify(action, incident)
    @incident = incident
    body = self.send("#{action}_message")

    Revily::Twilio.message(address, body)
  end

  def message
    incident.message.truncate()
  end
end
