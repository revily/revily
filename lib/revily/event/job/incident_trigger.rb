module Revily
  module Event
    class Job
      class IncidentTrigger < Job
        include Job::Incidents

        def process
          current_user.contacts.each do |contact|
            contact.notify(incidents)
          end
        end

      end
    end
  end
end
