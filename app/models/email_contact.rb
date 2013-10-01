class EmailContact < Contact
  def label
    read_attribute(:label) || 'Email'
  end
  
  def triggered_message
    "#{@incident.message}\n#{response_options}"
  end

  def acknowledged_message
    "All incidents assigned to you were acknowledged."
  end

  def resolved_message
    "All incidents assigned to you were resolved."
  end

  def unknown_message
    "I did not understand your response. ACKNOWLEDGE: 4, RESOLVE: 6, ESCALATE: 8"
  end

  def failure_message
    "The incidents assigned to you could not be #{action}d."
  end

  def notify(action, incident)
    @incident = incident
    body = self.send("#{action}_message")

    # FIXME: lol
    return true
    # Revily::Twilio.message(address, body)
  end

end
