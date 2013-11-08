class Policy < ActiveRecord::Base
  include Identity
  include Revily::Concerns::Eventable
  include Publication
  include Tenancy::ResourceScope

  # @!group Events
  actions :create, :update, :delete
  # @!endgroup
  
  # @!group Attributes
  accepts_nested_attributes_for :policy_rules, allow_destroy: true, reject_if: :all_blank
  # @!endgroup

  # @!group Associations
  scope_to :account
  has_many :policy_rules, -> { order(:position) }, dependent: :destroy, inverse_of: :policy
  has_many :service_policies
  has_many :services, through: :service_policies
  # @!endgroup

  # @!group Validations
  validates :name, presence: true, uniqueness: { scope: :account_id }
  validates :loop_limit, numericality: { only_integer: true }
  # @!endgroup

end
