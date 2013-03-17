class EscalationRule < ActiveRecord::Base
  include Identifiable

  belongs_to :assignable, polymorphic: true
  belongs_to :escalation_policy

  validates :escalation_timeout, presence: true
end
