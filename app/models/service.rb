class Service < ActiveRecord::Base
  include Identifiable
  
  devise :token_authenticatable

  has_many :events
  belongs_to :escalation_policy

  attr_accessible :acknowledgement_timeout, :auto_resolve_timeout, :name, :state

  before_save :ensure_authentication_token
end
