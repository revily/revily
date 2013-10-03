class PhoneContact < Contact
  def label
    read_attribute(:label) || 'Phone'
  end

  def notify(action, incidents)
    @incidents = incidents
    # body = self.send("#{action}_message")

    Revily::Twilio.call(address)
  end
end
