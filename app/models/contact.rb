class Contact < ActiveRecord::Base
  include Identity
  include Publication
  include Tenancy::ResourceScope

  # @!group Events
  actions :create, :update, :delete
  # @!endgroup

  # @!group Attributes
  attr_accessor :incidents
  # @!endgroup

  # @!group Associations
  scope_to :account
  belongs_to :account
  belongs_to :user, touch: true
  # @!endgroup

  # @!group Validations
  validates :type, presence: true
  validates :label, presence: true
  validates :account_id, presence: true
  validates :address, presence: true, uniqueness: { scope: [ :user_id, :type ] }
  # @!endgroup

  def active_model_serializer
    ContactSerializer
  end

  RESPONSE_MAP = {
    "4" => { action: "acknowledge", message: "All incidents were acknowledged." },
    "6" => { action: "resolve", message: "All incidents were resolved." },
    "8" => { action: "escalate", message: "All incidents were escalated." }
  }.tap {
    |res| res.default = { action: nil, message: "Your response was invalid." }
  }

  def notifier
    logger.warn "override Contact#notification_class in a subclass"
  end

  def notify(incidents=[])
    notifier.notify(self, incidents)
  end

  def service
    incidents.first.service
  end

end
