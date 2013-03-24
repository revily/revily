# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)      default(""), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  uuid                   :string(255)      not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  authentication_token   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

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
  has_many :user_schedule_layers, order: :position
  has_many :schedule_layers,
    through: :user_schedule_layers,
    # uniq: true,
    dependent: :destroy

  has_many :schedules, through: :schedule_layers

  before_save :ensure_authentication_token
end
