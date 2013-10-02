module Revily
  module Event
    class Job
      class IncidentTrigger < Job

        def process
          current_user.contacts.each do |contact|
            contact.notify(:triggered, incidents)
          end
        end

        private

        def current_user
          incident.current_user
        end

        def incident
          source
        end
        
        def incidents
          current_user.incidents
        end

        # override #source for eager loading of associated records
        def source
          @source ||= Incident.includes(current_user: :contacts).find_by(uuid: payload["source"]["id"])
        end
      end
    end
  end
end
