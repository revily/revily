class Contact::Phone < Contact
  def label
    read_attribute(:label) || 'Phone'
  end

  def notifier
    Revily::Event::Notifier::Phone
  end
end
