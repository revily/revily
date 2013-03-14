class EscalationRule < ActiveRecord::Base
  include Identifiable

  belongs_to :assignable, :polymorphic => true
  belongs_to :escalation_policy

  attr_accessible :escalation_timeout, :assignable, :escalation_policy
end
