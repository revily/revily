module Revily
  module Event
    class Job
      class IncidentTrigger < Incident

        def process
          current_user.contacts.each do |contact|
            contact.notify(incidents.triggered)
          end
        end

      end
    end
  end
end
