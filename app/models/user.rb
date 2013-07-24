class User < ActiveRecord::Base
  include Identifiable
  include Eventable
  include Actable

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :token_authenticatable

  acts_as_tenant # belongs_to :account

  has_many :contacts, as: :contactable
  has_many :sms_contacts, as: :contactable, class_name: "SmsContact"
  has_many :phone_contacts, as: :contactable, class_name: "PhoneContact"
  has_many :email_contacts, as: :contactable, class_name: "EmailContact"
  has_many :policy_rules, as: :assignment
  has_many :user_schedule_layers, -> { order(:position) }
  has_many :schedule_layers,
    through: :user_schedule_layers,
    dependent: :destroy
  has_many :schedules, through: :schedule_layers
  has_many :incidents, -> { order('created_at DESC') }, foreign_key: :current_user_id

  accepts_nested_attributes_for :account

  validates :account, 
    presence: true
  validates :name, 
    presence: true,
    allow_blank: false
  validates :email,
    uniqueness: { scope: [ :account_id ] }
  
  before_save :ensure_authentication_token
end
