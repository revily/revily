class V1::PolicyRulesController < V1::ApplicationController
  respond_to :json

  before_filter :authenticate_user!

  def sort
    params[:policy_rules].each_with_index do |id, index|
      PolicyRule.update_all({ position: index + 1}, { id: id })
    end
    render nothing: true
  end

  def index
    @policy_rules = rules.all

    respond_with @policies
  end

  def show
    @policy = rules.where(uuid: params[:id]).first

    respond_with @policy
  end

  def create
    @policy = rules.new(rule_params)
    @policy.save

    respond_with @policy
  end

  def update
    @policy = rules.where(uuid: params[:id]).first
    @policy.update_attributes(rule_params)

    respond_with @policy
  end

  def destroy
    @policy = rules.where(uuid: params[:id]).first
    @policy.destroy

    respond_with @policy
  end

  def assignables
    respond_with current_account.assignables_hash
  end

  private

    def rule_params
      params.permit(:escalation_timeout, :assignable_id, :assignable_type, :_destroy, :id, :position)
    end

    def policy
      @policy ||= current_account.policies.where(uuid: params[:policy_id]).first if params[:policy_id]
    end

    def rules
      @rules ||= (@policy) ? @policy.policy_rules : PolicyRule
    end
end
