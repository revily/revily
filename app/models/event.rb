class Event < ActiveRecord::Base
  include Identity
  include Tenancy::ResourceScope

  # @!group Attributes
  serialize :changeset, JSON
  # @!endgroup

  # @!group Associations
  scope_to :account
  belongs_to :source, polymorphic: true
  belongs_to :actor, polymorphic: true
  # @!endgroup

  # @!group Callbacks
  after_commit :publish, on: :create
  # @!endgroup

  # @!group Scopes
  scope :recent, -> { limit(50).order(arel_table[:id].desc) }
  # @!endgroup
end
