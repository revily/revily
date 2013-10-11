class User < ActiveRecord::Base
  include Identifiable
  include Eventable
  include Actable

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, # :trackable,
    :token_authenticatable

  acts_as_tenant # belongs_to :account

  has_many :contacts, dependent: :destroy
  has_many :sms_contacts, class_name: "Contact::Sms"
  has_many :phone_contacts, class_name: "Contact::Phone"
  has_many :email_contacts, class_name: "Contact::Email"
  has_many :policy_rules, as: :assignment
  has_many :user_schedule_layers, -> { order(:position) }, dependent: :destroy
  has_many :schedule_layers,
    through: :user_schedule_layers,
    dependent: :destroy
  has_many :schedules, through: :schedule_layers
  has_many :incidents, -> { order('created_at DESC') }, foreign_key: :current_user_id
  has_many :oauth_applications, class_name: "Doorkeeper::Application", as: :owner
  has_many :oauth_access_tokens, class_name: "Doorkeeper::AccessToken", foreign_key: :resource_owner_id
  has_many :access_tokens, class_name: "Doorkeeper::AccessToken", foreign_key: :resource_owner_id

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
