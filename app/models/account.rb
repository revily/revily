class Account < ActiveRecord::Base
  attr_accessible :subdomain

  has_many :users, dependent: :destroy

  validates :subdomain, 
    uniqueness: true
    
  accepts_nested_attributes_for :users
end
