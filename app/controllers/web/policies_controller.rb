class Web::PoliciesController < Web::ApplicationController
  before_action :policy, only: [:show, :update, :destroy]

  def index
    @policies = Policy.all
  end

  def show
  end

  def create
    @policy = Policy.new(policy_params)

    if @policy.save
      flash[:notice] = "Policy was successfully created."
    else
      flash[:alert] = "Policy could not be created."
    end

    respond_with @policy
  end

  def update
    if @policy.update(policy_params)
      flash[:notice] = "Policy was successfully updated."
    else
      flash[:alert] = "Policy could not be updated."
    end

    respond_with @policy
  end

  def destroy
    @policy.destroy
    redirect_to policies_url, notice: 'Policy was successfully destroyed.'
  end

  private

  def policy
    @policy = Policy.find_by(uuid: params[:id])
  end

  def policy_params
    params.require(:policy).permit(:name, :loop_limit)
  end
end
