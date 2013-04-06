class IncidentsDecorator < Draper::CollectionDecorator
  delegate :triggered, :acknowledged, :resolved, :unresolved
end