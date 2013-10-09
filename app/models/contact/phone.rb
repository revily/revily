class Contact::Phone < Contact
  def label
    read_attribute(:label) || 'Phone'
  end

  def notify(action, incidents)
    @incidents = incidents

    Revily::Twilio.call(address)
  end
end
