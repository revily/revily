class Contact < ActiveRecord::Base
  include Identifiable
  include ActiveModel::ForbiddenAttributesProtection

  # attr_accessible :address, :label

  belongs_to :user
  has_many :notification_rules

  validates :type, presence: true
  validates :label, presence: true
  validates :address, presence: true
end
