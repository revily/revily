module Revily
  module Event
    class Job
      class IncidentTrigger < Job

        def process
          incident.current_user.contacts.each do |contact|
            contact.notify(:triggered, incident)
          end
        end

        private

        def incident
          source
        end

      end
    end
  end
end
