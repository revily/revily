# == Schema Information
#
#     Table name: policy_rules
#
#      id                   :integer          not null, primary key
#      escalation_timeout   :integer          default(30)
#      position             :integer
#      uuid                 :string(255)      not null
#      assignable_id        :integer
#      assignable_type      :string(255)
#      policy_id :integer
#      created_at           :datetime         not null
#      updated_at           :datetime         not null
#

class PolicyRule < ActiveRecord::Base
  include Identifiable

  attr_accessor :assignment_id, :assignment

  belongs_to :assignable, polymorphic: true
  belongs_to :policy

  acts_as_list scope: :policy

  validates :escalation_timeout,
    presence: true
  validates :assignable_id,
    uniqueness: { scope: :policy_id }
  # #   presence: true
  # validates :assignable_type,
  # #   presence: true,
  #   inclusion: { in: %w[ User Schedule ] },
  #   unless: lambda {|a| a.assignment.present? }
  # validates :assignment,
  #   presence: true,
  #   on: :create

  validates :assignable,
    presence: true,
    uniqueness: { scope: :policy_id },
    if: "assignment.present?"

  accepts_nested_attributes_for :assignable

  before_validation :ensure_assignment

  def current_user
    @assignee ||= if assignable.respond_to?(:current_user_on_call)
      assignable.current_user_on_call
    else
      assignable
    end
  end

  def account
    self.policy.account
  end

  def ensure_assignment
    self.assignable = assignment
  end

  def assignment
    @assignment ||= account.users.find_by(uuid: assignment_id) || account.schedules.find_by(uuid: assignment_id)
    if @assignment.nil?
      errors.add(:assignment_id, "could not be found") unless errors[:assignment_id].include?("could not be found")
    end
    @assignment
  end

end
