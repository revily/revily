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
    @policy_rule = policy_rules.where(uuid: params[:id]).first

    respond_with policy, @policy_rule
  end

  def create
    logger.info policy_rule_params

    @policy_rule = policy_rules.new(policy_rule_params)

    logger.info @policy_rule.inspect

    @policy_rule.save

    respond_with policy, @policy_rule
  end

  def update
    @policy_rule = policy_rules.where(uuid: params[:id]).first
    @policy_rule.update_attributes(policy_rule_params)

    respond_with policy, @policy_rule
  end

  def destroy
    @policy_rule = policy_rules.where(uuid: params[:id]).first
    @policy_rule.destroy

    respond_with policy, @policy_rule
  end

  private

    def policy_rule_params
      params.permit(:escalation_timeout, :position, assignment_attributes: [ :id, :type ])

      # p = Hash.new.with_indifferent_access
      # [ :escalation_timeout, :_destroy, :position ].each do |key|
      #   p[key] = params[key]
      # end
      # p[:assignment_attributes] = Hash.new.with_indifferent_access
      # p[:assignment_attributes][:id] = params[:assignment][:id]
      # p[:assignment_attributes][:type] = params[:assignment][:type]

      # p[:assignment_attributes] = params[:assignment]

      # strong_params = ActionController::Parameters.new(p)
      # strong_params.permit(
      #   :escalation_timeout, :_destroy, :position, 
      #   assignment_attributes: [ :id, :type ],
      #   assignment: [ :id, :type ]
      # )
    end

    def policy
      @policy = current_account.policies.where(uuid: params[:policy_id]).first if params[:policy_id]
    end

    def policy_rules
      @policy_rules = @policy.policy_rules
    end
end
