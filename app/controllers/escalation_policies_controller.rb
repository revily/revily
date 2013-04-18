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
    # this is bad and I should feed bad.
    (params[:escalation_policy][:escalation_rules_attributes] ||= {}).each do |key, rule|
      assignable = current_account.users.find_by_uuid(rule[:assignable_id]) || current_account.schedules.find_by_uuid(rule[:assignable_id])
      params[:escalation_policy][:escalation_rules_attributes][key][:assignable_type] = assignable.class.name
      params[:escalation_policy][:escalation_rules_attributes][key][:assignable_id] = assignable.id
    end
    # e
    @policy = current_account.escalation_policies.new(escalation_policy_params)
    @policy.save

    respond_with @policy
  end

  def edit
    @policy = current_account.escalation_policies.where(uuid: params[:id]).first

    respond_with @policy
  end

  def update
    (params[:escalation_policy][:escalation_rules_attributes] ||= {}).each do |key, rule|
      assignable = current_account.users.find_by_uuid(rule[:assignable_id]) || current_account.schedules.find_by_uuid(rule[:assignable_id])
      params[:escalation_policy][:escalation_rules_attributes][key][:assignable_type] = assignable.class.name
      params[:escalation_policy][:escalation_rules_attributes][key][:assignable_id] = assignable.id
    end
    @policy = current_account.escalation_policies.where(uuid: params[:id]).first
    @policy.update_attributes(escalation_policy_params)

    respond_with @policy
  end

  def destroy
    @policy = current_account.escalation_policies.where(uuid: params[:id]).first
    @policy.destroy

    respond_with @policy
  end

  def assignables
    respond_with current_account.assignables_hash
  end

  private

  def escalation_policy_params
    params.require(:escalation_policy).permit(:name, :escalation_loop_limit,  escalation_rules_attributes: [ 
      :escalation_timeout, :assignable_id, :assignable_type, :_destroy, :id, :position
    ])
  end

end
