module Revily
  module Event
    class Job
      class IncidentResolve < Job

        def process
          incident.current_user.contacts.each do |contact|
            contact.notify(:resolved, incident)
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
