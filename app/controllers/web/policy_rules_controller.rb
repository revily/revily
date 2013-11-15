class Web::PolicyRulesController < Web::ApplicationController
  before_action :policy
  before_action :policy_rule, only: [ :update, :destroy ]

  def create
    @policy_rule = policy.policy_rules.new(policy_rule_params)

    if @policy_rule.save
      flash[:notice] = "Policy Rule was successfully created."
    else
      flash[:alert] = "Policy Rule could not be created."
    end

    respond_with @policy_rule, location: policy_path(policy)
  end

  def update
    if @policy_rule.update(policy_rule_params)
      flash[:notice] = "Policy rule was successfully updated."
    else
      flash[:alert] = "Policy rule could not be updated."
    end

    respond_with @policy_rule
  end

  def destroy
    @policy_rule.destroy
    redirect_to policy_rules_url, notice: 'Policy rule was successfully destroyed.'
  end

  private

  def policy
    @policy = Policy.find_by(uuid: params[:policy_id])
  end

  def policy_rule
    @policy_rule = @policy.policy_rules.find_by(uuid: params[:id])
  end

  def policy_rule_params
    params.require(:policy_rule).permit(:position, :escalation_timeout, :assignment_id, :assignment_type)
  end
end
