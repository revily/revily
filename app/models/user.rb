class User < ActiveRecord::Base
  include Identity
  include PasswordAuthentication
  include TokenAuthentication
  include Revily::Concerns::Eventable
  include Revily::Concerns::Actable
  include Publication
  include Tenancy::ResourceScope

  actions :create, :update, :delete

  scope_to :account
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
  has_many :incidents, -> { order("created_at DESC") }, foreign_key: :current_user_id
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
    presence: true,
    uniqueness: { scope: [ :account_id ] }

  private

  def ensure_authentication_token
    loop do
      token = SecureRandom.urlsafe_base64
      unless User.where(authentication_token: token).any?
        write_attribute(:authentication_token, token)
        break
      end
    end
  end

end
