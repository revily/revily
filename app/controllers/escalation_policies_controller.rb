class EscalationPoliciesController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!

  def index
    @policies = current_account.escalation_policies

    respond_with @escalation_policies
  end

  def show
    @policy = current_account.escalation_policies.where(uuid: params[:id]).first.decorate

    respond_with @policy
  end

  def new
    @policy = current_account.escalation_policies.new

    respond_with @policy
  end

  def create
    @policy = current_account.escalation_policies.new(escalation_policy_params)
    @policy.save

    respond_with @policy
  end

  def edit
    @policy = current_account.escalation_policies.where(uuid: params[:id]).first

    respond_with @policy
  end

  def update
    @policy = current_account.escalation_policies.where(uuid: params[:id]).first
    @policy.update_attributes(escalation_policy_params)

    respond_with @policy
  end

  def destroy
    @policy = current_account.escalation_policies.where(uuid: params[:id]).first
    @policy.destroy

    respond_with @policy
  end

  private

  def escalation_policy_params
    params.require(:escalation_policy).permit(:name, :escalation_loop_limit)
  end

end
