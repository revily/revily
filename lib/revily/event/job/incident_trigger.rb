module Revily
  module Event
    class Job
      class IncidentTrigger < Job

        def process
          incident.current_user.contacts.each do |contact|
            contact.notify(incident.state)
          end
        end

        def incident
          source
        end

      end
    end
  end
end
