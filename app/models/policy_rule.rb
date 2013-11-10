class PolicyRule < ActiveRecord::Base
  include Identity
  include EventSource
  include Publication
  include Tenancy::ResourceScope

  # @!group Events
  actions :create, :update, :delete
  # @!endgroup

  # @!group Attributes
  attr_accessor :assignment_attributes
  acts_as_list scope: :policy
  # @!endgroup

  # @!group Associations
  scope_to :account
  belongs_to :assignment, polymorphic: true
  belongs_to :policy
  # @!endgroup

  # @!group Validations
  validates :escalation_timeout, presence: true
  validate :validate_assignment_uniqueness_on_create, on: :create
  validate :validate_assignment_uniqueness_on_update, on: :update
  validate :validate_assignment_attributes, on: :create
  # @!endgroup

  # @!group Callbacks
  after_initialize :set_assignment
  # @!endgroup

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
    errors.add(:assignment, "has already been taken for this policy") if existing_rule
  end

  def validate_assignment_uniqueness_on_update
    existing_rule = policy.policy_rules.find_by(assignment_id: assignment_id, assignment_type: assignment_type)

    if existing_rule
      return if existing_rule.id == self.id
      errors.add(:assignment, "already exists for this policy")
    end
  end

  def validate_assignment_attributes
    errors.add(:assignment_attributes, ":id cannot be blank") if assignment_attributes[:id].nil? && assignment_id.nil?
    errors.add(:assignment_attributes, ":type cannot be blank") if assignment_attributes[:type].nil? && assignment_type.nil?
  end

  def validate_assignment_exists
    errors.add(:assignment, "could not be found") if assignment.nil?
  end

  def set_assignment
    return unless assignment_attributes && assignment_attributes[:type] && assignment_attributes[:id]

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
