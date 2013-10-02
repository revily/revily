module Revily
  module Event
    class Job
      class IncidentAcknowledge< Job

        def process
          current_user.contacts.each do |contact|
            contact.notify(:acknowledged, incidents)
          end
        end

        private

        def current_user
          source.current_user
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
