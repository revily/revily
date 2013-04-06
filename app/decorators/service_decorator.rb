class ServiceDecorator < Draper::Decorator
  delegate_all
  # decorates_association :events, with: EventsDecorator

  def current_status
    events = source.events
    if source.disabled?
      h.content_tag :i, "", class: 'icon-circle-blank muted'
    elsif events.any?(&:triggered?)
      helpers.content_tag :i, "", class: 'icon-exclamation-sign text-error'
    elsif events.any?(&:acknowledged?)
      helpers.content_tag :i, "", class: 'icon-minus-sign text-warning'
    else
      helpers.content_tag :i, "", class: 'icon-ok-sign text-success'
    end
  end

  def event_counts
    triggered_count = source.events.triggered.count
    acknowledged_count = source.events.acknowledged.count

    h.content_tag :span do
      "#{triggered_count} triggered, #{acknowledged_count} acknowledged"
    end
  end

  def triggered_count
    h.content_tag :span do
      "#{source.events.triggered.count} triggered"
    end
  end

  def acknowledged_count
    h.content_tag :span do
      "#{source.events.acknowledged.count} acknowledged"
    end
  end

  def resolved_count
    h.content_tag :span, class: 'badge badge-success' do
      source.events.resolved.count.to_s
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
