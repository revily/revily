class ServiceDecorator < Draper::Decorator
  delegate_all
  # decorates_association :incidents, with: IncidentsDecorator

  def incident_counts
    triggered_count = source.incidents.triggered.count
    acknowledged_count = source.incidents.acknowledged.count

    h.content_tag :span do
      "#{triggered_count} triggered, #{acknowledged_count} acknowledged"
    end
  end

  def actions
    source.actions.map do |action|
      %Q[#{action.user.try(:name) || "System"} #{action.action + 'd'} the #{action.actionable_type} 
    "#{action.actionable.name}"]
    end
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       source.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
