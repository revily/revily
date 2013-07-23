class PhoneContact < Contact
  def label
    read_attribute(:label) || 'Phone'
  end
end
