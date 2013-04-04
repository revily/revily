class Account < ActiveRecord::Base
  attr_accessible :subdomain

  has_many :users
end
