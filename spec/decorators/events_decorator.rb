class EventsDecorator < Draper::CollectionDecorator
  delegate :triggered, :acknowledged, :resolved, :unresolved
end