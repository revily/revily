# class V1::IncidentsController < V1::BaseController
#   respond_to :json

#   before_filter :authenticate_user!
#   before_filter :service, :incidents

#   api :GET, '/incidents', 'List all incidents'
#   api :GET, '/services/:service_id/incidents', 'List all incidents for a given service'
#   param :service_id, :number, desc: 'The service id', required: true
#   def index
#     @incidents = incidents.all

#     respond_with @incidents
#   end

#   api :GET, '/incidents/:id', 'Show an incident'
#   param :id, :number, desc: 'The incident id', required: true
#   def show
#     @incident = incidents.find_by_uuid(params[:id])

#     respond_with @incident
#   end

#   api :POST, '/services/:service_id/incidents', 'Create an incident'
#   param :service_id, String, desc: 'the id of the service', required: true
#   param :key, String, desc: 'unique key used to identify the incident', required: true
#   param :message, String, desc: 'short message defining the incident', required: true
#   param :description, String, desc: 'in-depth details of the incident'
#   def create
#     @incident = incidents.new(incident_params)
#     @incident.save

#     respond_with @incident
#   end

#   api :PUT, '/incidents/:id', 'Update an incident'
#   param :service_id, String, desc: 'the id of the service', required: true
#   param :id, String, desc: 'unique key used to identify the incident', required: true
#   param :message, String, desc: 'short message defining the incident'
#   param :description, String, desc: 'in-depth details of the incident'
#   def update
#     @incident = incidents.find_by_uuid(params[:id])
#     @incident.update_attributes(incident_params)

#     respond_with @incident
#   end

#   api :DELETE, '/incidents/:id', 'Delete an incident'
#   def destroy
#     @incident = incidents.find_by_uuid(params[:id])
#     @incident.destroy

#     respond_with @incident
#   end

#   api :PUT, '/incidents/:id/trigger', 'Update an incident'
#   param :id, String, desc: 'unique key used to identify the incident', required: true
#   def trigger
#     @incident = incidents.find_by_uuid(params[:id])
#     @incident.trigger 

#     respond_with @incident
#   end

#   api :PUT, '/incidents/:id/acknowledge', 'Update an incident'
#   param :id, String, desc: 'unique key used to identify the incident', required: true
#   def acknowledge
#     @incident = incidents.find_by_uuid(params[:id])
#     @incident.acknowledge

#     respond_with @incident
#   end

#   api :PUT, '/incidents/:id/escalate', 'Update an incident'
#   param :id, String, desc: 'unique key used to identify the incident', required: true
#   def escalate
#     @incident = incidents.find_by_uuid(params[:id])
#     @incident.escalate

#     respond_with @incident
#   end

#   api :PUT, '/incidents/:id/resolve', 'Update an incident'
#   param :id, String, desc: 'unique key used to identify the incident', required: true
#   def resolve
#     @incident = incidents.find_by_uuid(params[:id])
#     @incident.resolve

#     respond_with @incident
#   end

#   private

#   def incident_params
#     params.permit(:key, :message, :description)
#   end

#   def service
#     @service ||= Service.find_by_uuid(params[:service_id]) if params[:service_id]
#   end

#   def incidents
#     @incidents ||= (@service) ? @service.incidents : Incident
#   end
# end
