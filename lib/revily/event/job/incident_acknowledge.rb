module Revily
  module Event
    class Job
      class IncidentAcknowledge < Job

        def process
          incident.current_user.contacts.each do |contact|
            contact.notify(:acknowledged, incident)
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