class SMS < Alert
  after_create :notify

  def notify

  end
end
