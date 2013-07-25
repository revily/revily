class Contact < ActiveRecord::Base
  include Identifiable

  RESPONSE_MAP = {
    '4' => { action: 'acknowledge', message: 'All incidents were acknowledged.' },
    '6' => { action: 'resolve', message: 'All incidents were resolved.' },
    '8' => { action: 'escalate', message: 'All incidents were escalated.' }
  }.tap {
    |res| res.default = { action: nil, message: 'Your response was invalid.' }
  }

  acts_as_tenant # belongs_to :account

  belongs_to :account

  belongs_to :contactable, polymorphic: true
  has_many :notification_rules

  validates :type, presence: true
  validates :label, presence: true
  validates :address, presence: true

  def self.response_map
    response_map = {
      '4' => { action: 'acknowledge', message: 'All incidents were acknowledged.' },
      '6' => { action: 'resolve', message: 'All incidents were resolved.' },
      '8' => { action: 'escalate', message: 'All incidents were escalated.'}
    }
    response_map.default = { action: nil, message: 'Your response was invalid.' }

    response_map
  end

  def notify(event)
    
  end

  def response_options
    RESPONSE_MAP.map{|k,v| "#{k}: #{v}"}.join(', ')
  end
end
