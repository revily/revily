# == Schema Information
#
#     Table name: policy_rules
#
#      id                   :integer          not null, primary key
#      escalation_timeout   :integer          default(30)
#      position             :integer
#      uuid                 :string(255)      not null
#      assignment_id        :integer
#      assignment_type      :string(255)
#      policy_id :integer
#      created_at           :datetime         not null
#      updated_at           :datetime         not null
#

class PolicyRule < ActiveRecord::Base
  include Identifiable

  attr_accessor :assignment_attributes

  belongs_to :assignment, polymorphic: true
  belongs_to :policy

  acts_as_list scope: :policy

  validates :escalation_timeout,
    presence: true
  # validates :assignment_id,
  #   uniqueness: { scope: :policy_id },
  #   presence: true
  # validates :assignment_type,
  #   presence: true,
  #   inclusion: { in: %w[ User Schedule ], message: "must be either 'User' or 'Schedule'" }


  validate :ensure_unique_assignment

  accepts_nested_attributes_for :assignment

  before_validation :set_assignment

  def current_user
    @assignee ||= if assignment.respond_to?(:current_user_on_call)
      assignment.current_user_on_call
    else
      assignment
    end
  end

  def account
    self.policy.account
  end

  def ensure_unique_assignment
    if policy.policy_rules.find_by(assignment_id: assignment_id, assignment_type: assignment_type)
      errors.add(:assignment, 'has already been created on this policy')
    end
  end

  def set_assignment
    klass = self.assignment_attributes[:type].downcase.pluralize
    assign = account.send(klass).find_by_uuid(assignment_attributes[:id])
    self.assignment = assign
  end

  def assignment_type=(value)
    write_attribute(:assignment_type, value.capitalize)
  end
end
