class Event < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :account

  serialize :data, JSON

  scope :recent, -> { limit(50).order(arel_table[:id].desc) }
end
