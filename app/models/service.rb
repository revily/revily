class Service < ActiveRecord::Base
  include Identifiable
  
  devise :token_authenticatable

  has_many :events
  has_many :alerts, through: :events

  has_one :service_escalation_policy
  has_one :escalation_policy, through: :service_escalation_policy

  validates :name, :acknowledge_timeout, :auto_resolve_timeout, :state,
    presence: true

  before_save :ensure_authentication_token

  state_machine initial: :enabled do
    state :enabled
    state :disabled

    event :enable do
      transition [ :disabled ] => :enabled
    end

    event :disable do
      transition [ :enabled ]=> :disabled
    end
  end
end
