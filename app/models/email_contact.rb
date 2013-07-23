class EmailContact < Contact
  def label
    read_attribute(:label) || 'Email'
  end
end
