class Contact < ActiveRecord::Base
  include Revily::Concerns::Identifiable

  attr_accessor :incidents
  
  def active_model_serializer
    ContactSerializer
  end
  
  RESPONSE_MAP = {
    '4' => { action: 'acknowledge', message: 'All incidents were acknowledged.' },
    '6' => { action: 'resolve', message: 'All incidents were resolved.' },
    '8' => { action: 'escalate', message: 'All incidents were escalated.' }
  }.tap {
    |res| res.default = { action: nil, message: 'Your response was invalid.' }
  }

  acts_as_tenant # belongs_to :account

  belongs_to :account
  belongs_to :user, touch: true

  validates :type, presence: true
  validates :label, presence: true
  validates :account_id, presence: true
  validates :address,
    presence: true,
    uniqueness: { scope: [ :user_id, :type ] }

  def notify(action, incidents)
    logger.warn "override Contact#notify in a subclass"
  end

  def header
    logger.warn "override Contact#greeting in a subclass"
  end

  def footer
    logger.warn "override Contact#greeting in a subclass"
  end

  def message(body)
    message = <<-MESSAGE
#{header} #{body} #{footer}
    MESSAGE
  end
  
  def service
    incidents.first.service
  end

end
