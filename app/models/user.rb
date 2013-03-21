class User < ActiveRecord::Base
  include Identifiable

  hound_user
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :token_authenticatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :contacts
  has_many :notification_rules, through: :contacts
  has_many :escalation_rules, as: :assignable
  has_many :user_schedules
  has_many :schedules, through: :user_schedules
  
  before_save :ensure_authentication_token
end
