class Contact < ActiveRecord::Base
  include Identifiable

  # disable STI
  self.inheritance_column = nil

  belongs_to :user
  has_many :notification_rules
  
  attr_accessible :address, :label, :type, :uuid
end
