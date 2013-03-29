# == Schema Information
#
# Table name: escalation_rules
#
#  id                   :integer          not null, primary key
#  escalation_timeout   :integer          default(30)
#  position             :integer
#  uuid                 :string(255)      not null
#  assignable_id        :integer
#  assignable_type      :string(255)
#  escalation_policy_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class EscalationRule < ActiveRecord::Base
  include Identifiable
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :assignable, polymorphic: true
  belongs_to :escalation_policy

  acts_as_list scope: :escalation_policy

  validates :escalation_timeout, presence: true


  def assignee
    @assignee ||= if assignable.respond_to?(:current_user_on_call)
      assignable.current_user_on_call
    else
      assignable
    end
  end

end
