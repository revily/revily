class Phone < Alert
  after_create :notify

  def notify

  end
end
