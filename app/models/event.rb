class Event < ActiveRecord::Base
  include Identifiable
  include ActiveModel::ForbiddenAttributesProtection

  hound actions: [ :create, :update, :trigger, :acknowledge, :resolve ]

  serialize :details, JSON

  belongs_to :service
  has_many :alerts

  validates :message, presence: true

  # validates :message, 
  #   uniqueness: { scope: [ :service_id, :state ] },
  #   on: :create,
  #   :unless => :key?

    # on: :save
  # validates :key, 
  #   # uniqueness: { scope: [ :service_id, :state, :uuid ] },
  #   uniqueness: { scope: [ :service_id, :state ] },
  #   allow_nil: true,
  #   allow_blank: true,
  #   on: :create

  before_save :ensure_key

  scope :unresolved, where("state != 'resolved'")

  def self.first_or_initialize_by_key_or_message(params)
    if params[:key]
      where(key: params[:key])
    elsif params[:message]
      where(message: params[:message])
    end.first_or_initialize(params)
  end

  def self.find_by_key_or_message(params)
    if params[:key]
      where(key: params[:key])
    elsif params[:message]
      where(message: params[:message])
    end.last
  end

  state_machine initial: :triggered do
    state :triggered
    state :acknowledged
    state :resolved

    event :trigger do
      transition [ :acknowledged ] => :triggered
    end

    event :acknowledge do
      transition [ :triggered ] => :acknowledged
    end

    event :resolve do
      transition [ :triggered, :acknowledged ] => :resolved
    end

    before_transition :triggered => :acknowledged, :do => :update_acknowledged_at
    before_transition :triggered => :resolved, :do => [ :update_acknowledged_at, :update_resolved_at ]
    before_transition :acknowledged => :resolved, :do => :update_resolved_at

  end

  def key_or_uuid
    self.key || self.uuid
  end

  def triggered_at
    self.created_at
  end

  private

  def ensure_key
    self[:key] ||= SecureRandom.hex
  end

  def update_resolved_at
    self[:resolved_at] = Time.zone.now
  end

  def update_acknowledged_at
    self[:acknowledged_at] = Time.zone.now
  end

  def fire_alerts!
    AlertWorker.perform_async(self.id)
  end

end
