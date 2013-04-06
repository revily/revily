class IncidentDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       source.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def state_label
    css_class = case source.state
    when 'triggered'
      'label-important'
    when 'acknowledged'
      'label-warning'
    when 'resolved'
      'label-success'
    end
    helpers.content_tag :span, class: "label #{css_class}" do
      source.state.upcase
    end
  end
end
