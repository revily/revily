class Event < ActiveRecord::Base
  acts_as_tenant # belongs_to :account

  belongs_to :source, polymorphic: true

  serialize :data, JSON

  scope :recent, -> { limit(50).order(arel_table[:id].desc) }
end
