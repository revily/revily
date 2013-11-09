class Contact::Sms < Contact
  def label
    read_attribute(:label) || "SMS"
  end

  def notifier
    Revily::Event::Notifier::Sms
  end
end
