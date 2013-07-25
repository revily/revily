class V1::PolicyRulesController < V1::ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :policy
  before_action :policy_rules

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
    @policy_rule = policy_rules.find_by!(uuid: params[:id])

    respond_with @policy_rule
  end

  def create
    @policy_rule = policy_rules.new(policy_rule_params)
    @policy_rule.account = current_account
    @policy_rule.save

    respond_with policy, @policy_rule
  end

  def update
    @policy_rule = policy_rules.find_by_uuid!(params[:id])
    @policy_rule.update_attributes(policy_rule_params)

    respond_with policy, @policy_rule
  end

  def destroy
    @policy_rule = policy_rules.find_by!(uuid: params[:id])
    @policy_rule.destroy

    respond_with policy, @policy_rule
  end

  private

    def policy_rule_params
      params.permit(:escalation_timeout, :position, assignment_attributes: [ :id, :type ])
    end

    def policy
      @policy = Policy.find_by!(uuid: params[:policy_id]) if params[:policy_id]
    end

    def policy_rules
      @policy_rules = @policy.policy_rules
    end
end
