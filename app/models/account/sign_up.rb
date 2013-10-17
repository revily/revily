class Account::SignUp
  include Revily::Model

  attr_reader :user, :account

  attribute :name,      type: String
  attribute :subdomain, type: String
  attribute :email,     type: String
  attribute :password,  type: String

  validates :name, :email, :password, 
    presence: true

  def save
    return false unless valid?

    delegate_attributes_for_user
    delegate_attributes_for_account

    delegate_errors_for_user unless @user.valid?
    delegate_errors_for_account unless @account.valid?

    if !errors.any?
      persist!
      true
    else
      false
    end
  end

  private

  def delegate_attributes_for_user
    @user = User.new do |user|
      user.name = name
      user.email = email
      user.password = password
      user.password_confirmation = password
    end
  end

  def delegate_attributes_for_account
    @account = Account.new do |account|
      account.subdomain = subdomain
      account.terms_of_service = true
    end
  end

  def delegate_errors_for_user
    errors.add(:name, @user.errors[:name].first) if @user.errors[:name].present?
    errors.add(:email, @user.errors[:email].first) if @user.errors[:email].present?
    errors.add(:password, @user.errors[:password].first) if @user.errors[:password].present?
  end

  def delegate_errors_for_account
    errors.add(:subdomain, @account.errors[:name].first) if @account.errors[:name].present?
  end

  def persist!
    @user.save!
    @account.save!
  end

end