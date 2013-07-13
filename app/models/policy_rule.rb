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
    # presence: true
  # validates :assignment_type,
    # presence: true
  #   inclusion: { in: %w[ User Schedule ], message: "must be either 'User' or 'Schedule'" }


  validate :validate_assignment_uniqueness_on_create, on: :create
  validate :validate_assignment_uniqueness_on_update, on: :update
  validate :validate_assignment_attributes, on: :create

  # validate :ensure_assignment_exists

  # accepts_nested_attributes_for :assignment

  after_initialize :set_assignment
  # before_validation :set_assignment

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

  end

  def assignment_attributes
    @assignment_attributes ||= {}
  end

  def validate_assignment_uniqueness_on_create
    existing_rule = policy.policy_rules.find_by(assignment_id: assignment_id, assignment_type: assignment_type)
    errors.add(:assignment, 'has already been taken for this policy') if existing_rule
  end

  def validate_assignment_uniqueness_on_update
    existing_rule = policy.policy_rules.find_by(assignment_id: assignment_id, assignment_type: assignment_type)

   if existing_rule
      return if existing_rule.id == self.id
      errors.add(:assignment, 'has already been taken for this policy')
    end
  end

  def validate_assignment_attributes
    errors.add(:assignment_attributes, ":id can't be blank") if assignment_attributes[:id].nil? && assignment_id.nil?
    errors.add(:assignment_attributes, ":type can't be blank") if assignment_attributes[:type].nil? && assignment_type.nil?
  end

  def validate_assignment_exists
    errors.add(:assignment, "could not be found") if assignment.nil?
  end

  def set_assignment
    # return false if assignment_attributes.nil?
    # return false if assignment_attributes[:type].nil?
    # return false if assignment_attributes[:id].nil?

    return unless assignment_attributes[:type] && assignment_attributes[:id]

    klass = self.assignment_attributes[:type].downcase.pluralize
    assign = account.send(klass).find_by_uuid(assignment_attributes[:id])
    self.assignment = assign
  end

  def assignment_attributes=(assignment_attributes)
    attrs = Hash.new.with_indifferent_access
    attrs[:type] = assignment_attributes[:type].capitalize if assignment_attributes[:type]
    attrs[:id] = assignment_attributes[:id] if assignment_attributes[:id]
    @assignment_attributes = attrs
  end
end
