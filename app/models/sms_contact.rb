class SmsContact < Contact
  def label
    read_attribute(:label) || 'SMS'
  end
  
  def trigger_message
    "#{@incident.message}\n#{response_options}"
  end

  def acknowledge_message
    "All incidents assigned to you were acknowledged."
  end

  def resolve_message
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

    $twilio.account.sms.messages.create(
      from: ENV['TWILIO_NUMBER'],
      to: address,
      body: self.send("#{action}_message")
    )
  end
end
