class V1::EscalationRulesController < V1::ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!

  def sort
    params[:escalation_rules].each_with_index do |id, index|
      EscalationRule.update_all({ position: index + 1}, { id: id })
    end
    render nothing: true
  end
end
