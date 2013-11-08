class Contact::Email < Contact
  def label
    read_attribute(:label) || "Email"
  end

  def notifier
    Revily::Event::Notifier::Email
  end
end
