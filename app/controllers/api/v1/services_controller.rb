class Api::V1::ServicesController < Api::V1::BaseController
  respond_to :json

  before_filter :authenticate_user!

  def_param_group :service do
    param :name, String, desc: 'the name of the service', required: true, action_aware: true 
    param :auto_resolve_timeout, Fixnum, desc: 'timeout in minutes after which any triggered incidents will auto-resolve ', required: true, action_aware: true
    param :acknowledge_timeout, Fixnum, desc: 'timeout in minutes that any acknowledged incidents will re-trigger', required: true, action_aware: true
    param :escalation_policy_id, String, desc: 'the id of the escalation policy associated with the service', required: true, action_aware: true
  end

  api :GET, '/services', 'List all services'
  def index
    @services = Service.all

    respond_with @services
  end

  api :GET, '/services/:id', 'Show a service'
  param :id, String, desc: 'The incident id', required: true
  def show
    @service = Service.find_by_uuid(params[:id])

    respond_with @service
  end

  api :POST, '/services', 'Create a service'
  param_group :service
  def create
    @escalation_policy = EscalationPolicy.find_by_uuid(params.delete(:escalation_policy_id))
    @service = Service.new(service_params.merge(:escalation_policy => @escalation_policy))
    @service.save

    respond_with @service
  end

  api :PUT, '/services/:id', 'Update a service'
  param :id, String, desc: 'the id of the service', required: true
  param_group :service
  def update
    @service = Service.find_by_uuid(params[:id])
    @service.update_attributes(service_params)

    respond_with @service, json: @service
  end

  def enable
    @service = Service.find_by_uuid(params[:id])
    @service.enable && hound_action(@service, 'enable')

    respond_with @service, json: @service
  end

  def disable
    @service = Service.find_by_uuid(params[:id])
    @service.disable && hound_action(@service, 'disable')

    respond_with @service, json: @service
  end

  api :DELETE, '/services/:id', 'Delete a service'
  param :id, String, desc: 'the id of the service', required: true
  def destroy
    @service = Service.find_by_uuid(params[:id])
    @service.destroy

    respond_with @service
  end

  private

  def service_params
    params.require(:service).permit(:name, :auto_resolve_timeout, :acknowledge_timeout, :escalation_policy_id)
  end
end

# == Schema Information
#
# Table name: services
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  auto_resolve_timeout :integer
#  acknowledge_timeout  :integer
#  state                :string(255)
#  uuid                 :string(255)
#  authentication_token :string(255)
#  escalation_policy_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
