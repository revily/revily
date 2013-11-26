class User < ActiveRecord::Base
  include Identity
  include PasswordAuthentication
  include TokenAuthentication
  include EventSource
  include EventActor
  include Publication
  include Tenancy::ResourceScope

  # @!group Events
  actions :create, :update, :delete
  # @!endgroup

  # @!group Associations
  scope_to :account
  has_many :contacts, dependent: :destroy
  has_many :sms_contacts, class_name: "Contact::Sms"
  has_many :phone_contacts, class_name: "Contact::Phone"
  has_many :email_contacts, class_name: "Contact::Email"
  has_many :policy_rules, as: :assignment
  has_many :user_schedule_layers, -> { order(:position) }, dependent: :destroy
  has_many :schedule_layers, through: :user_schedule_layers, dependent: :destroy
  has_many :schedules, through: :schedule_layers
  has_many :incidents, -> { order("created_at DESC") }, foreign_key: :current_user_id
  has_many :oauth_applications, class_name: "Doorkeeper::Application", as: :owner
  has_many :oauth_access_tokens, class_name: "Doorkeeper::AccessToken", foreign_key: :resource_owner_id
  has_many :access_tokens, class_name: "Doorkeeper::AccessToken", foreign_key: :resource_owner_id
  # @!endgroup

  # @!group Attributes
  accepts_nested_attributes_for :account
  # @!endgroup

  # @!group Validations
  validates :account, presence: true
  validates :name, presence: true, allow_blank: false
  validates :email, presence: true, uniqueness: { scope: [ :account_id ] }
  # @!endgroup

  private

  def ensure_authentication_token
    return if self.uuid?

    write_attribute(
      :authentication_token,
      Revily::Helpers::UniqueToken.generate_token_for(self, :authentication_token, type: :hex, length: 64)
    )
  end

end
