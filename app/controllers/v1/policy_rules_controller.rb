class V1::PolicyRulesController < V1::ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :policy, :policy_rules

  def sort
    params[:policy_rules].each_with_index do |id, index|
      PolicyRule.update_all({ position: index + 1}, { id: id })
    end
    render nothing: true
  end

  def index
    @policy_rules = policy_rules
    respond_with @policy_rules
  end

  def show
    @policy_rule = policy_rules.where(uuid: params[:id]).first

    respond_with @policy_rule
  end

  def create
    @policy_rule = policy_rules.new(policy_rule_params)
    @policy_rule.save

    respond_with @policy_rule
  end

  def update
    @policy_rule = policy_rules.where(uuid: params[:id]).first
    @policy_rule.update_attributes(policy_rule_params)

    respond_with @policy_rule
  end

  def destroy
    @policy_rule = policy_rules.where(uuid: params[:id]).first
    @policy_rule.destroy

    respond_with @policy_rule
  end

  def assignables
    respond_with current_account.assignables_hash
  end

  private

    def policy_rule_params
      params.permit(:escalation_timeout, :assignment_id, :_destroy, :id, :position)
    end

    def policy
      @policy = current_account.policies.where(uuid: params[:policy_id]).first if params[:policy_id]
    end

    def policy_rules
      # @policy_rules ||= (@policy) ? @policy.policy_rules : current_account.policy_rules
      @policy_rules = @policy ? @policy.policy_rules : PolicyRule
    end
end
