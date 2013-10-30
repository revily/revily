class Policy < ActiveRecord::Base
  include Revily::Concerns::Identifiable
  include Revily::Concerns::Eventable
  include Revily::Concerns::RecordChange

  events :create, :update, :delete
  
  acts_as_tenant # belongs_to :account

  has_many :policy_rules, -> { order(:position) }, dependent: :destroy, inverse_of: :policy
  has_many :service_policies
  has_many :services, through: :service_policies
  
  validates :name,
    presence: true,
    uniqueness: { scope: :account_id }
    
  validates :loop_limit, 
    numericality: { only_integer: true }

  accepts_nested_attributes_for :policy_rules, allow_destroy: true, reject_if: :all_blank
end
