class V1::PoliciesController < V1::ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :policies

  def index
    @policies = policies

    respond_with @policies
  end

  def show
    @policy = policies.find_by!(uuid: params[:id])

    respond_with @policy
  end

  def new
    @policy = policies.new

    respond_with @policy
  end

  def create
    @policy = policies.new(policy_params)
    @policy.save

    respond_with @policy
  end

  def edit
    @policy = policies.find_by!(uuid: params[:id])

    respond_with @policy
  end

  def update
    @policy = policies.find_by!(uuid: params[:id])
    @policy.update_attributes(policy_params)

    respond_with @policy
  end

  def destroy
    @policy = policies.find_by!(uuid: params[:id])
    @policy.destroy

    respond_with @policy
  end

  private

    def policies
      @policies = current_account.policies
    end

    def policy_params
      params.permit(:name, :loop_limit, policy_rules_attributes: [:escalation_timeout, :position, :assignment_id])
    end

end
