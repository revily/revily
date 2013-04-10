class Hound::ActionDecorator < Draper::Decorator
  decorates Hound::Action

  delegate_all

  def message
    message = ""
    message += user.nil? ? "#{(action + 'd').capitalize} " : "#{user.name} #{action + 'd'} "
    message += "#{actionable_type}"
    message += actionable.nil? ? "#{actionable_type}." : " #{actionable.name}."
    message
  end
end