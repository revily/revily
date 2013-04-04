class Forms::Registration
  include ActiveAttr::Model

  attribute :name
  attribute :email
  attribute :password
  attribute :password_confirmation
  attribute :subdomain

  attr_reader :user
  attr_reader :account

  validates :name, :email, :password, :password_confirmation, :subdomain,
    presence: true
  validates :email, format: { with: User.email_regexp }
  validates :password,
    length: { within: User.password_length },
    confirmation: true

  def save
    return false unless valid?

    @account = Account.new(subdomain: subdomain)
    @user = User.new(
      name: name,
      email: email,
      password: password,
      password_confirmation: password
    )

    unless @account.valid?
      # errors.add(:subdomain, @account.errors[:subdomain].first) if @account.errors[:subdomain].present?
      @account.errors.each do |attribute, message|
        errors.add(attribute, message)
      end
    end

    unless @user.valid?
      @user.errors.each do |attribute, message|
        errors.add(attribute, message)
      end
    end

    if errors.any?
      false
    else
      persist!
      true
    end
  end

  def persist!
    @user.save
    @account.save

    if @account.errors.any?
      @account.errors.each do |attribute, message|
        errors.add(attribute, message)
      end
      return false
    end

    if @user.errors.any?
      @user.errors.each do |attribute, message|
        errors.add(attribute, message)
      end
      return false
    end
    
    true
  end

end
